import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  final Future<SharedPreferences> sharedPreferences;

  PreferencesHelper({required this.sharedPreferences});

  static const restaurantSchedulePref = 'RESTAURANT_PREF';

  Future<bool> get isRestaurantScheduleActive async {
    final prefs = await sharedPreferences;
    return prefs.getBool(restaurantSchedulePref) ?? false;
  }

  void setRestaurantScheduleActive(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(restaurantSchedulePref, value);
  }
}