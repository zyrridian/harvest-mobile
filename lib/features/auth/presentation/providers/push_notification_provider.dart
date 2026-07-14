import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/core/services/godeye_push_notification.dart';
import 'package:harvest_app/core/providers/dio_provider.dart';
import 'package:harvest_app/features/auth/presentation/providers/auth_controller.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

final pushNotificationServiceProvider = Provider<void>((ref) {
  final pushService = PushNotificationService();
  final authState = ref.watch(authControllerProvider);

  // Only register device if user is authenticated
  if (authState.maybeMap(authenticated: (_) => true, orElse: () => false)) {
    pushService.onSocketId.listen((socketId) async {
      if (socketId != null) {
        final dio = ref.read(dioProvider);
        
        // Get generic device id/model if device_info_plus doesn't have it natively or is skipped
        String deviceId = "unknown";
        String deviceModel = "unknown";
        
        try {
          final deviceInfo = DeviceInfoPlugin();
          if (Platform.isAndroid) {
            final androidInfo = await deviceInfo.androidInfo;
            deviceId = androidInfo.id;
            deviceModel = androidInfo.model;
          } else if (Platform.isIOS) {
            final iosInfo = await deviceInfo.iosInfo;
            deviceId = iosInfo.identifierForVendor ?? "unknown";
            deviceModel = iosInfo.model;
          }
        } catch (e) {
          // ignore
        }

        try {
          await dio.post(
            '/v1/users/push-token',
            data: {
              'socketId': socketId,
              'deviceId': deviceId,
              'deviceModel': deviceModel,
            },
          );
        } catch (e) {
          // Silent fail for push token registration
        }
      }
    });
  }
});
