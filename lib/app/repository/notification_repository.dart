import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

String? selectedNotificationPayload;

class NotificationRepository {
  void init() async {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        !kIsWeb && Platform.isLinux
            ? null
            : await flutterLocalNotificationsPlugin
                .getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      selectedNotificationPayload = notificationAppLaunchDetails?.payload;

      /// 如果是点击 Notification 然后运行的APP
    }

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('mipmap/ic_launcher');

    final IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        ///
      },
    );

    const MacOSInitializationSettings macOSInitializationSettings =
        MacOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    final LinuxInitializationSettings linuxInitializationSettings =
        LinuxInitializationSettings(
      defaultActionName: 'Open notification',
      defaultIcon: AssetsLinuxIcon('icons/app_icon.png'),
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: androidInitializationSettings,
            iOS: iosInitializationSettings,
            macOS: macOSInitializationSettings,
            linux: linuxInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        debugPrint("notification payload: $payload");
      }
      selectedNotificationPayload = payload;
      log("notification click : $payload");
    });
  }

  Future<bool> isGranted() async {
    return Permission.notification.request().isGranted;
  }

  Future<bool> enable() async {
    if (await isGranted()) {
      const notificationDetails =
          AndroidNotificationDetails("z-chain-service", "Z-Chain通知服务");

      /// Android
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.startForegroundService(1, "Z-Chain通知服务", "若想及时获取到消息需要后台运行",
              notificationDetails: notificationDetails);

      /// IOS
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(sound: true, badge: true, alert: true);

      /// MACOS
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(sound: true, badge: true, alert: true);

      return true;
    }
    return false;
  }

  Future<void> show(String title, String content) async {
    flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch.hashCode % 10086,
        title,
        content,
        const NotificationDetails(
            android: AndroidNotificationDetails(
                "z-chain-service-message", "Z-Chain消息通知服务")));
  }
}
