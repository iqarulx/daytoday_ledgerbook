import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin notification =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await notification.initialize(initializationSettings);

    // Request permissions for notifications
    await requestPermissions();

    // Create the default download channel
    const AndroidNotificationChannel downloadChannel =
        AndroidNotificationChannel(
      'download_channel',
      'Download Progress',
      description: 'Shows download progress notifications',
      importance: Importance.max,
    );

    await notification
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(downloadChannel);
  }

  static Future requestPermissions() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
    // iOS-specific request
    await notification
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static final notificationId = Random().nextInt(10000);

  static Future download({required String title, String? payload}) async {
    await notification.show(
      notificationId,
      'Download',
      title,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'download_channel',
          'Download Progress',
          channelDescription: 'Shows download progress',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }
}
