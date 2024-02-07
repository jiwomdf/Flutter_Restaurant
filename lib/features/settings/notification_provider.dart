import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/cupertino.dart';
import '../../service/background_service.dart';
import '../../util/datetime/date_time_helper.dart';
import '../../util/preferenceshelper/preferences_helper.dart';

class NotificationProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;

  NotificationProvider({required this.preferencesHelper});

  bool _isRestaurantScheduleActive = false;
  bool get isRestaurantScheduleActive => _isRestaurantScheduleActive;

  Future<bool> scheduleRestaurant(bool value) async {
    _isRestaurantScheduleActive = value;
    if (_isRestaurantScheduleActive) {
      notifyListeners();
      return await AndroidAlarmManager.periodic(
        const Duration(hours: 24),
        1,
        RestaurantScheduleBackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }

  void getRestaurantRecommendation() async {
    _isRestaurantScheduleActive = await preferencesHelper.isRestaurantScheduleActive;
    notifyListeners();
  }

  void setDailyRestaurantRecommendation(bool value) {
    preferencesHelper.setRestaurantScheduleActive(value);
    getRestaurantRecommendation();
  }
}