

import 'dart:convert';
import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fundamental_beginner_restourant/domain/data/local/entity/restaurant_entity.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/data/api/response/restaurant_element.dart';
import '../navigation/Navigation.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid = const AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = const IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
          if (payload != null) {
            log('notification payload: $payload');
          }
          selectNotificationSubject.add(payload ?? 'empty payload');
        });
  }

  Future<void> showScheduleNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      Restaurant restaurant) async {
    var channelId = "1";
    var channelName = "channel_01";
    var channelDescription = "Restaurant Schedule Channel";

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: const DefaultStyleInformation(true, true)
    );

    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();

    var titleNotification = "<b>Recommendation Restaurant</b>";
    var titleNews = restaurant.name;

    await flutterLocalNotificationsPlugin.show(
        0,
        titleNotification,
        titleNews,
        NotificationDetails(
            android: androidPlatformChannelSpecifics,
            iOS: iOSPlatformChannelSpecifics
        ),
        payload: json.encode(restaurant.toJson())
    );
  }

  Future<void> showScheduleOnNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var channelId = "2";
    var channelName = "channel_02";
    var channelDescription = "Schedule On Channel";

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: const DefaultStyleInformation(true, true)
    );

    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();

    var titleNotification = "Schedule Notification is on";
    await flutterLocalNotificationsPlugin.show(
        1,
        titleNotification,
        null,
        NotificationDetails(
            android: androidPlatformChannelSpecifics,
            iOS: iOSPlatformChannelSpecifics
        ),
        payload: null
    );
  }

  void configureSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen(
          (String payload) async {
        var data = RestaurantEntity.fromJson(json.decode(payload));
        var article = data.name;
        Navigation.intentWithData(route, article);
      },
    );
  }
}
