# GodEye Push Notification Service

A professional, easy-to-use Flutter package for real-time push notifications and background services. This package allows you to receive notifications directly from your own Socket.io backend without relying on Firebase Cloud Messaging (FCM).

## Features

- **Firebase-Free**: Receive push notifications directly from your backend.
- **Background Service**: Stays alive even when the app is minimized or closed.
- **Local Notifications**: Automatic display of notifications with customizable styles.
- **Socket.io Integration**: Real-time connection with low latency.
- **Easy Configuration**: Set up in minutes with minimal code.

## Getting Started

### 1. Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  godeye_push_notification:
    git:
      url: https://github.com/GodEye2004/push-notification.git
      path: packages/godeye_push_notification
```

*(Note: Once published to pub.dev, you can use the standard versioning)*

### 2. Android Configuration

Ensure your `AndroidManifest.xml` has the necessary permissions and service declarations:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
<uses-permission android:name="android.permission.VIBRATE"/>
```

### 3. Usage

Initialize the service in your `main()` function:

```dart
import 'package:godeye_push_notification/godeye_push_notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final pushService = PushNotificationService();
  await pushService.initialize(
    serverUrl: "https://your-backend-api.com",
    appId: "your-unique-app-id",
  );

  runApp(const MyApp());
}
```

### 4. Device Registration

Register the device to start receiving targeted notifications:

```dart
pushService.onSocketId.listen((socketId) async {
  if (socketId != null) {
    bool success = await pushService.registerDevice(
      socketId: socketId,
      deviceId: "unique_device_id",
      deviceModel: "iPhone 15",
    );
  }
});
```

## Backend Integration

Your backend should emit a `push-notification` event to the corresponding socket ID:

```javascript
io.to(socketId).emit('push-notification', {
  notification: {
    title: "Hello World",
    body: "This is a real-time notification!"
  },
  data: {
    click_action: "FLUTTER_NOTIFICATION_CLICK"
  }
});
```

## License

MIT
