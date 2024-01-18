

import 'package:flutter/foundation.dart';
import 'package:fundamental_beginner_restourant/domain/entities/restaurant_element.dart';

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


  RestaurantProvider({required this.apiService}) {
    _fetchRestaurants();
  }

  Future<dynamic> _fetchRestaurants() async {
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