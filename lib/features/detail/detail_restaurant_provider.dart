import 'package:flutter/foundation.dart';
import 'package:fundamental_beginner_restourant/domain/entities/restaurant_detail_element.dart';
import '../../domain/data/api/api_service.dart';
import '../../util/state/ResultState.dart';

class DetailRestaurantProvider extends ChangeNotifier {
  final String id;
  final ApiService apiService;

  late ResultState _state;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  late RestaurantDetailElement _restaurantsResult;
  RestaurantDetailElement get result => _restaurantsResult;


  DetailRestaurantProvider({required this.id, required this.apiService}) {
    _fetchDetailRestaurants(id);
  }

  Future<dynamic> _fetchDetailRestaurants(String id) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurant = await apiService.getRestaurantDetail(id);
      if (restaurant.restaurant != null) {
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