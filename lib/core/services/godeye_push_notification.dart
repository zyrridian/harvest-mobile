import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Channel constants (shared between isolates)
// ─────────────────────────────────────────────────────────────────────────────
const _kChannelId = 'push_notifications_channel_v3';
const _kChannelName = 'Push Notifications';

// ─────────────────────────────────────────────────────────────────────────────
// FCM Background Handler — top-level, called when app is terminated/background
// ─────────────────────────────────────────────────────────────────────────────
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    Firebase.app();
  } catch (_) {
    await Firebase.initializeApp();
  }

  debugPrint('[FCM BG] messageId=${message.messageId}');

  // Only show local notification for pure data messages.
  // Notification messages are shown automatically by the OS.
  if (message.notification == null && message.data.isNotEmpty) {
    final plugin = FlutterLocalNotificationsPlugin();
    await plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
    await plugin.show(
      DateTime.now().millisecond % 100000,
      message.data['title'] ?? 'New Notification',
      message.data['body'] ?? '',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _kChannelId,
          _kChannelName,
          importance: Importance.max,
          priority: Priority.high,
          channelShowBadge: true,
        ),
        iOS: DarwinNotificationDetails(badgeNumber: 1),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PushNotificationService
// ─────────────────────────────────────────────────────────────────────────────
class PushNotificationService {
  static final PushNotificationService _instance =
      PushNotificationService._internal();
  factory PushNotificationService() => _instance;
  PushNotificationService._internal();

  static const String _deviceIdKey = 'push_device_id';

  String? _serverUrl;
  String? _appId;
  String? _deviceId;
  String? _deviceModel;
  String? _appVersion;

  /// Stream of RemoteMessage when user taps a notification
  final StreamController<RemoteMessage> _notificationTapController =
      StreamController<RemoteMessage>.broadcast();
  Stream<RemoteMessage> get onNotificationTap =>
      _notificationTapController.stream;

  // ─── Device ID ─────────────────────────────────────────────────────────────
  Future<String> _getPersistentDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString(_deviceIdKey);
    if (deviceId != null) return deviceId;

    final info = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final android = await info.androidInfo;
      deviceId = 'android_${android.id}';
    } else if (Platform.isIOS) {
      final ios = await info.iosInfo;
      deviceId =
          'ios_${ios.identifierForVendor ?? DateTime.now().millisecondsSinceEpoch}';
    } else {
      deviceId = 'unknown_${DateTime.now().millisecondsSinceEpoch}';
    }

    await prefs.setString(_deviceIdKey, deviceId);
    return deviceId;
  }

  // ─── FCM Token ─────────────────────────────────────────────────────────────
  Future<String?> _getFcmToken() async {
    try {
      Firebase.app();
    } catch (_) {
      try {
        await Firebase.initializeApp();
      } catch (e) {
        debugPrint('[FCM] Firebase initialization failed (missing google-services.json?): $e');
        return null;
      }
    }
    try {
      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission(alert: true, badge: true, sound: true);
      final token = await messaging.getToken();
      debugPrint('[FCM] Token: $token');
      return token;
    } catch (e) {
      debugPrint('[FCM] getToken error: $e');
      return null;
    }
  }

  // ─── Token Refresh ──────────────────────────────────────────────────────────
  Future<void> _sendUpdatedPushToken(String token) async {
    if (_serverUrl == null || _deviceId == null || _appId == null) return;
    try {
      await http.post(
        Uri.parse('$_serverUrl/update-fcm-token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'app_id': _appId,
          'device_id': _deviceId,
          'push_token': token,
        }),
      );
      debugPrint('[FCM] Token refreshed on server');
    } catch (e) {
      debugPrint('[FCM] Token refresh error: $e');
    }
  }

  // ─── Initialize ────────────────────────────────────────────────────────────
  Future<void> initialize({
    required String serverUrl,
    required String appId,
    String? deviceModel,
    String? appVersion,
  }) async {
    _serverUrl = serverUrl;
    _appId = appId;
    _deviceModel = deviceModel ?? 'Unknown Device';
    _appVersion = appVersion ?? '1.0.0';

    _deviceId = await _getPersistentDeviceId();
    final fcmToken = await _getFcmToken();

    if (fcmToken != null) {
      // Must be called before runApp (registered in main.dart),
      // but we call here in case library user forgets.
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // Foreground FCM messages
      FirebaseMessaging.onMessage.listen((msg) {
        debugPrint('[FCM FG] messageId=${msg.messageId}');
        _showLocalNotificationFg(msg);
      });

      // App opened from background notification tap
      FirebaseMessaging.onMessageOpenedApp.listen((msg) {
        debugPrint('[FCM] Opened from background notification');
        _notificationTapController.add(msg);
      });

      // App launched from terminated notification tap
      final initialMsg = await FirebaseMessaging.instance.getInitialMessage();
      if (initialMsg != null) {
        debugPrint('[FCM] App launched from notification');
        Future.delayed(
          const Duration(milliseconds: 500),
          () => _notificationTapController.add(initialMsg),
        );
      }

      // Token auto-refresh
      FirebaseMessaging.instance.onTokenRefresh.listen(_sendUpdatedPushToken);
    }

    // Local notifications channel setup
    final plugin = FlutterLocalNotificationsPlugin();
    await plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _kChannelId,
            _kChannelName,
            description: 'Push notifications channel',
            importance: Importance.high,
          ),
        );

    await plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );

    // Background service (Socket.IO)
    final service = FlutterBackgroundService();
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
        notificationChannelId: _kChannelId,
        initialNotificationTitle: 'Push Service',
        initialNotificationContent: 'Connecting...',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(),
    );

    // Pass config to background isolate
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (await service.isRunning()) {
        service.invoke('set_config', {
          'serverUrl': serverUrl,
          'appId': appId,
          'deviceId': _deviceId,
          'deviceModel': _deviceModel,
          'appVersion': _appVersion,
          'fcmToken': fcmToken,
        });
        timer.cancel();
      }
    });
  }

  // ─── Show local notification (foreground FCM) ──────────────────────────────
  void _showLocalNotificationFg(RemoteMessage message) {
    final title =
        message.notification?.title ?? message.data['title'] ?? 'New Message';
    final body = message.notification?.body ?? message.data['body'] ?? '';

    FlutterLocalNotificationsPlugin().show(
      DateTime.now().millisecond % 100000,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _kChannelId,
          _kChannelName,
          importance: Importance.max,
          priority: Priority.high,
          channelShowBadge: true,
        ),
        iOS: DarwinNotificationDetails(badgeNumber: 1),
      ),
    );
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────
  Stream<String?> get onSocketId => FlutterBackgroundService()
      .on('socket_id')
      .map((event) => event?['id'] as String?);

  void requestSocketId() => FlutterBackgroundService().invoke('get_socket_id');
}

// ─────────────────────────────────────────────────────────────────────────────
// Background Service Entry Point (runs in a separate Dart isolate)
// ─────────────────────────────────────────────────────────────────────────────
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  try {
    DartPluginRegistrant.ensureInitialized();
  } catch (e) {
    debugPrint('[BG] DartPluginRegistrant error: $e');
  }

  final plugin = FlutterLocalNotificationsPlugin();
  try {
    await plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
  } catch (e) {
    debugPrint('[BG] LocalNotifications init error: $e');
  }

  String? serverUrl;
  String? appId;
  String? deviceId;
  String? deviceModel;
  String? appVersion;
  String? fcmToken;

  service.on('set_config').listen((event) {
    if (event != null && serverUrl == null) {
      serverUrl = event['serverUrl'];
      appId = event['appId'];
      deviceId = event['deviceId'];
      deviceModel = event['deviceModel'];
      appVersion = event['appVersion'];
      fcmToken = event['fcmToken'];
      service.invoke('config_ack', {});

      _initSocket(
        service,
        plugin,
        serverUrl!,
        appId!,
        deviceId!,
        deviceModel!,
        appVersion!,
        fcmToken,
      );
    }
  });

  if (service is AndroidServiceInstance) {
    service
        .on('setAsForeground')
        .listen((_) => service.setAsForegroundService());
    service
        .on('setAsBackground')
        .listen((_) => service.setAsBackgroundService());
  }
  service.on('stopService').listen((_) => service.stopSelf());
}

// ─────────────────────────────────────────────────────────────────────────────
// Show notification from background isolate
// ─────────────────────────────────────────────────────────────────────────────
Future<void> _showLocalNotification(
  FlutterLocalNotificationsPlugin plugin,
  Map<String, dynamic> data,
) async {
  final title =
      data['notification']?['title'] ?? data['title'] ?? 'New Message';
  final body = data['notification']?['body'] ?? data['body'] ?? '';

  await plugin.show(
    DateTime.now().millisecond % 100000,
    title,
    body,
    NotificationDetails(
      android: AndroidNotificationDetails(
        _kChannelId,
        _kChannelName,
        importance: Importance.max,
        priority: Priority.high,
        channelShowBadge: true,
        styleInformation: BigTextStyleInformation(
          body,
          htmlFormatBigText: true,
          contentTitle: title,
          htmlFormatContentTitle: true,
        ),
      ),
      iOS: const DarwinNotificationDetails(badgeNumber: 1),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Socket.IO connection (background isolate)
// ─────────────────────────────────────────────────────────────────────────────
void _initSocket(
  ServiceInstance service,
  FlutterLocalNotificationsPlugin plugin,
  String serverUrl,
  String appId,
  String deviceId,
  String deviceModel,
  String appVersion,
  String? fcmToken,
) {
  final socket = io.io(
    serverUrl,
    io.OptionBuilder()
        .setTransports(['websocket', 'polling'])
        .enableAutoConnect()
        // Send deviceId in both auth and query parameters for compatibility
        .setAuth({'deviceId': deviceId})
        .setQuery({'deviceId': deviceId})
        .build(),
  );

  socket.onConnect((_) async {
    debugPrint('[Socket] Connected: ${socket.id}');

    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: 'Push Service',
        content: 'Connected ✓',
      );
      service.invoke('socket_id', {'id': socket.id});
    }

    // Register device (sends FCM token to server)
    try {
      await http.post(
        Uri.parse('$serverUrl/register-device'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'app_id': appId,
          'device_id': deviceId,
          'platform': Platform.isAndroid ? 'android' : 'ios',
          'os_version': Platform.operatingSystemVersion,
          'app_version': appVersion,
          'device_model': deviceModel,
          'push_token': fcmToken, // real FCM token (not socket.id)
        }),
      );
      debugPrint('[Socket] Device registered');
    } catch (e) {
      debugPrint('[Socket] Register error: $e');
    }

    // Fetch pending notifications from server
    try {
      final resp = await http.get(
        Uri.parse('$serverUrl/pending-notifications/$deviceId'),
      );
      if (resp.statusCode == 200) {
        final pending = jsonDecode(resp.body) as List;
        for (final n in pending) {
          await _showLocalNotification(
            plugin,
            Map<String, dynamic>.from(n as Map),
          );
        }
        if (pending.isNotEmpty) {
          debugPrint('[Socket] ${pending.length} pending shown');
        }
      }
    } catch (e) {
      debugPrint('[Socket] Pending fetch error: $e');
    }
  });

  socket.onDisconnect((_) {
    debugPrint('[Socket] Disconnected');
    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: 'Push Service',
        content: 'Reconnecting...',
      );
    }
  });

  socket.on('push-notification', (data) async {
    debugPrint('[Socket] Notification received');
    await _showLocalNotification(
      plugin,
      data is Map<String, dynamic>
          ? data
          : Map<String, dynamic>.from(data as Map),
    );
  });

  service.on('get_socket_id').listen((_) {
    if (socket.connected && socket.id != null) {
      service.invoke('socket_id', {'id': socket.id});
    }
  });

}
