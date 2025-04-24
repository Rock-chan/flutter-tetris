import 'package:jpush_flutter/jpush_flutter.dart';

class PushNotificationForIosService {
  static void notificationInit() {
    JPush notification = JPush();

    notification.applyPushAuthority(const NotificationSettingsIOS(
      sound: true,
      alert: true,
      badge: true,
    ));

    notification.setup(
      appKey: "1383ea0ea1647283328bcd8f",
      production: true,
      debug: false,
    );
  }
}
