import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:fundamental_beginner_restourant/domain/data/local/db_service.dart';

import '../../domain/data/local/entity/restaurant_entity.dart';
import '../../util/state/ResultState.dart';

class RestaurantDbProvider extends ChangeNotifier {
  final DbService dbService;

  RestaurantDbProvider({required this.dbService});

  late ResultState _state;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  List<RestaurantEntity> _restaurants = [];
  List<RestaurantEntity> get restaurants => _restaurants;

  Future<void> insertRestaurants(RestaurantEntity restaurantEntity) async {
    await dbService.insertRestaurant(restaurantEntity);
  }

  Future<void> getRestaurant() async {
    _restaurants = await dbService.getRestaurant();
    if (_restaurants.isNotEmpty) {
      _state = ResultState.hasData;
    } else {
      _state = ResultState.noData;
      _message = 'Empty Data';
    }
    notifyListeners();
  }

  Future<bool> getIsRestaurantFav({required String id}) async {
    try {
      final restaurants = await dbService.getRestaurantById(id);
      if (restaurants.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> removeRestaurant(String id) async {
    try {
      await dbService.removeRestaurant(id);
      getRestaurant();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

}