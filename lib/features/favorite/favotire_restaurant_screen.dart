import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fundamental_beginner_restourant/domain/data/local/db_service.dart';
import 'package:provider/provider.dart';
import '../../domain/data/api/response/restaurant_element.dart';
import '../../util/state/ResultState.dart';
import '../detail/detail_screen.dart';
import '../main/list/list_restaurants_container.dart';
import '../main/restaurant_db_provider.dart';

class FavoriteRestaurantScreen extends StatefulWidget {

  const FavoriteRestaurantScreen({super.key});

  @override
  State<FavoriteRestaurantScreen> createState() => _FavoriteRestaurantScreenState();
}

class _FavoriteRestaurantScreenState extends State<FavoriteRestaurantScreen> {
  RestaurantDbProvider? _provider;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme
                  .of(context)
                  .colorScheme
                  .inversePrimary,
              title: const Text("Favorite")
          ),
          body: ChangeNotifierProvider<RestaurantDbProvider>(
              create:  (_) {
                _provider = RestaurantDbProvider(dbService: DbService());
                _provider?.getFavRestaurant();
                return _provider!;
              },
              child: _favoriteList()
          )
        )
    );
  }

  Widget _favoriteList() {
    return Consumer<RestaurantDbProvider>(
        builder: (context, state, _) {
          switch (state.state) {
            case ResultState.loading:
              return const Center(child: CircularProgressIndicator());
            case ResultState.hasData:
              return ListView.builder(
                itemCount: state.restaurants.length,
                itemBuilder: (context, index) {
                  return ListRestaurantContainer(restaurant: Restaurant(
                    id: state.restaurants[index].id,
                    name: state.restaurants[index].name,
                    description: state.restaurants[index].description,
                    city: state.restaurants[index].city,
                    pictureId: state.restaurants[index].pictureId,
                    rating: 0.0,
                  ),
                    onTap: (id) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return DetailScreen(id: id);
                      }));
                    },
                  );
                },
              );
            case ResultState.noData:
              return Center(child: Material(child: Text(state.message)));
            case ResultState.error:
              return const Center(child: Material(child: Text("There is no internet connection")));
            default:
              return const Center(child: Material(child: Text('')));
          }
    });
  }
}
