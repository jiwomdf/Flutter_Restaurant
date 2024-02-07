import 'dart:isolate';
import 'dart:math';
import 'dart:ui';
import '../domain/data/api/api_service.dart';
import '../main.dart';
import '../util/notification/notification_helper.dart';

final ReceivePort port = ReceivePort();

class RestaurantScheduleBackgroundService {
  static RestaurantScheduleBackgroundService? _instance;
  static const String _isolateName = 'isolate';
  static SendPort? _uiSendPort;

  RestaurantScheduleBackgroundService._internal() {
    _instance = this;
  }

  factory RestaurantScheduleBackgroundService() => _instance ?? RestaurantScheduleBackgroundService._internal();

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      _isolateName,
    );
  }

  static Future<void> callback() async {
    final NotificationHelper notificationHelper = NotificationHelper();
    var result = await ApiService().getRestaurants();
    int randomNumber = Random().nextInt(result.restaurants.length - 1); // from 0 upto 99 included
    var restaurant = result.restaurants[randomNumber];
    await notificationHelper.showScheduleNotification(flutterLocalNotificationsPlugin, restaurant);
      _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}
