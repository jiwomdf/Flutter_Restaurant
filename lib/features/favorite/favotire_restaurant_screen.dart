import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fundamental_beginner_restourant/domain/data/local/db_service.dart';
import 'package:provider/provider.dart';
import '../../domain/data/api/response/restaurant_element.dart';
import '../../util/state/ResultState.dart';
import '../detail/detail_screen.dart';
import '../main/restaurant_db_provider.dart';
import '../main/widget/list_restaurants_container.dart';

class FavoriteRestaurantScreen extends StatefulWidget {
  static const routeName = '/favorite_restaurant_screen';

  const FavoriteRestaurantScreen({super.key});

  @override
  State<FavoriteRestaurantScreen> createState() => _FavoriteRestaurantScreenState();
}

class _FavoriteRestaurantScreenState extends State<FavoriteRestaurantScreen> {

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
          body: ChangeNotifierProvider<RestaurantDbProvider?>(
              create:  (_) {
                var provider = RestaurantDbProvider(dbService: DbService());
                provider.getFavRestaurant();
                return provider;
              },
              child: _favoriteList()
          )
        )
    );
  }

  Widget _favoriteList() {
    return Consumer<RestaurantDbProvider>(
        builder: (context, provider, _) {
          switch (provider.state) {
            case ResultState.loading:
              return const Center(child: CircularProgressIndicator());
            case ResultState.hasData:
              return ListView.builder(
                itemCount: provider.restaurants.length,
                itemBuilder: (context, index) {
                  return ListRestaurantContainer(restaurant: Restaurant(
                    id: provider.restaurants[index].id,
                    name: provider.restaurants[index].name,
                    description: provider.restaurants[index].description,
                    city: provider.restaurants[index].city,
                    pictureId: provider.restaurants[index].pictureId,
                    rating: provider.restaurants[index].rating,
                  ),
                    onTap: (id) async {
                      var result = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) => DetailScreen(id: id)));
                      if(result == DetailScreen.navigatorCallback) {
                        provider.getFavRestaurant();
                      }
                    },
                  );
                },
              );
            case ResultState.noData:
              return Center(child: Material(child: Text(provider.message)));
            case ResultState.error:
              return const Center(child: Material(child: Text("There is no internet connection")));
            default:
              return const Center(child: Material(child: Text('')));
          }
    });
  }
}
