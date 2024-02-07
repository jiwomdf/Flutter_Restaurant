import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fundamental_beginner_restourant/features/settings/notification_provider.dart';
import 'package:fundamental_beginner_restourant/util/preferenceshelper/preferences_helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import '../../util/notification/notification_helper.dart';
import '../detail/detail_screen.dart';

class SettingScreen extends StatefulWidget {
  static const routeName = '/setting_screen';

  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  final NotificationHelper _notificationHelper = NotificationHelper();

  @override
  void initState() {
    super.initState();
    _notificationHelper.configureSelectNotificationSubject(DetailScreen.routeName);
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) {
              var provider = NotificationProvider(
                  preferencesHelper: PreferencesHelper(
                      sharedPreferences: SharedPreferences.getInstance())
              );
              provider.getRestaurantRecommendation();
              return provider;
            })
          ],
          child: Consumer<NotificationProvider>(
            builder: (BuildContext context, NotificationProvider provider, Widget? child) {
              return Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Setting",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Restaurant Notification",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Text("Enable Notification")
                            ],
                          ),
                          Switch.adaptive(
                            value: provider.isRestaurantScheduleActive,
                            onChanged: (value) async {
                              if (Platform.isIOS) {
                              } else {
                                provider.scheduleRestaurant(true);
                                provider.setDailyRestaurantRecommendation(value);
                                await _notificationHelper
                                    .showScheduleOnNotification(flutterLocalNotificationsPlugin);
                              }
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          )),
    ));
  }
}
