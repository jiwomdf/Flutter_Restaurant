

import 'package:flutter/foundation.dart';
import 'package:fundamental_beginner_restourant/domain/entities/restaurant_element.dart';
import 'package:fundamental_beginner_restourant/util/ext/StringExt.dart';

import '../../domain/data/api/api_service.dart';
import '../../util/state/ResultState.dart';

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  late ResultState _state;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  late RestaurantElement _restaurantsResult;
  RestaurantElement get result => _restaurantsResult;


  RestaurantProvider({required this.apiService}){}

  Future<dynamic> fetchRestaurants(String keyword) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurant = await apiService.getRestaurants();
      if (restaurant.restaurants.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;

        List<Restaurant> list = restaurant.restaurants;
        if(keyword.isEmpty) {
          list = restaurant.restaurants;
        } else {
          list = restaurant.restaurants
              .where((itm) => itm.name.containsIgnoreCase(keyword)).toList();
        }
        restaurant.restaurants = list;
        notifyListeners();
        return _restaurantsResult = restaurant;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }

}