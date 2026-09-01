import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> background(RemoteMessage message) async {
  log(
    "Background notification: "
    "${message.notification?.title}",
  );

  log(
    "Body: "
    "${message.notification?.body}",
  );
}

class NotificationService {
  static Future<void> initialize() async {
    // Background message
    FirebaseMessaging.onBackgroundMessage(background);

    // Notification permission
    NotificationSettings settings = await FirebaseMessaging.instance
        .requestPermission();

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      log("Notification permission denied");
      return;
    }

    // Daily topic
    await FirebaseMessaging.instance.subscribeToTopic("daily");

    log("Notification authorized");
    log("Subscribed to daily topic");

    // Foreground message
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log(
        "Foreground notification: "
        "${message.notification?.title}",
      );

      log(
        "Body: "
        "${message.notification?.body}",
      );
    });

    log("Foreground listener started");
  }
}
