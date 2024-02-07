import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fundamental_beginner_restourant/domain/data/api/api_service.dart';
import 'package:fundamental_beginner_restourant/domain/data/local/db_service.dart';
import 'package:fundamental_beginner_restourant/features/favorite/favotire_restaurant_screen.dart';
import 'package:fundamental_beginner_restourant/features/settings/setting_screen.dart';
import 'package:fundamental_beginner_restourant/service/background_service.dart';
import 'package:fundamental_beginner_restourant/util/notification/notification_helper.dart';
import 'common/navigation.dart';
import 'features/detail/detail_screen.dart';
import 'features/main/main_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationHelper notificationHelper = NotificationHelper();
  final RestaurantScheduleBackgroundService service = RestaurantScheduleBackgroundService();

  service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      theme: ThemeData(useMaterial3: true, colorScheme: const ColorScheme.dark()),
      navigatorKey: navigatorKey,
      initialRoute: MainScreen.routeName,
      routes: {
        MainScreen.routeName: (context) =>
          MainScreen(
            title: 'Restaurant App',
            apiService: ApiService(),
            dbService: DbService(),
          ),
        DetailScreen.routeName: (context) =>
            DetailScreen(id: ModalRoute.of(context)?.settings.arguments as String),
        SettingScreen.routeName: (context) =>
            const SettingScreen(),
        FavoriteRestaurantScreen.routeName: (context) =>
            const FavoriteRestaurantScreen(),
      }
    );
  }
}