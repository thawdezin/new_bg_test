import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../Utils/app_utils.dart';


Future<void> scheduleNotification(String input) async {
  //var time = Time(23, 50, 0);
  // var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //   'your_channel_id', // channel ID
  //   'Scheduled Notification', // channel name
  //  // 'Play sound at 11:50 PM', // channel description
  //   sound: RawResourceAndroidNotificationSound('noti.mp3'), // sound
  // );
  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
    'you_can_name_it_whatever',
    'flutterfcm',
    playSound: true,
    sound: RawResourceAndroidNotificationSound('noti'),
    importance: Importance.max,
    priority: Priority.high,
  );

  final DarwinInitializationSettings iOSPlatformChannelSpecifics =
  DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {});

  var darwinNotificationDetails = DarwinNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: darwinNotificationDetails,
  );
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    '$input Notification ${getCurrentTime()}',
    'Play sound at ${getCurrentTime()}',
    tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
    platformChannelSpecifics,
    uiLocalNotificationDateInterpretation:
    UILocalNotificationDateInterpretation.absoluteTime,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}