import 'package:flutter/cupertino.dart';
import 'package:fundamental_beginner_restourant/domain/data/local/db_service.dart';

import '../../domain/data/local/entity/restaurant_entity.dart';
import '../../util/state/ResultState.dart';

class RestaurantDbProvider extends ChangeNotifier {
  final DbService dbService;

  RestaurantDbProvider({required this.dbService});

  ResultState? _state;
  ResultState? get state => _state;

  String _message = '';
  String get message => _message;

  List<RestaurantEntity> _restaurants = [];
  List<RestaurantEntity> get restaurants => _restaurants;

  bool _isFavRestaurants = false;
  bool get isFavRestaurants => _isFavRestaurants;

  Future<void> getFavRestaurant() async {
    try {
      _restaurants = await dbService.getRestaurant();
      if (_restaurants.isNotEmpty) {
        _state = ResultState.hasData;
      } else {
        _state = ResultState.noData;
        _message = 'Empty Data';
      }
    } catch (e) {
      _state = ResultState.noData;
      _message = e.toString();
    }
    notifyListeners();
  }

  Future<void> getIsRestaurantFav(String id) async {
    try {
      final restaurants = await dbService.getRestaurantById(id);
      if (restaurants.isNotEmpty) {
        _isFavRestaurants = true;
      } else {
        _isFavRestaurants = false;
      }
    } catch (e) {
      _isFavRestaurants = false;
    }
    notifyListeners();
  }

  Future<void> insertFavRestaurant(RestaurantEntity restaurantEntity) async {
    try {
      await dbService.insertRestaurant(restaurantEntity);
    } catch (e) {}
    getIsRestaurantFav(restaurantEntity.id);
  }

  Future<void> removeFavRestaurant({required String id}) async {
    try {
      await dbService.removeRestaurant(id);
    } catch (e) {}
    getIsRestaurantFav(id);
  }

}