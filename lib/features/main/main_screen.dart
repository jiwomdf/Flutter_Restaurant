import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fundamental_beginner_restourant/domain/data/local/db_service.dart';
import 'package:fundamental_beginner_restourant/features/favorite/favotire_restaurant_screen.dart';
import 'package:fundamental_beginner_restourant/features/main/restaurant_provider.dart';
import 'package:fundamental_beginner_restourant/features/main/widget/list_restaurants_container.dart';
import 'package:provider/provider.dart';
import '../../common/navigation.dart';
import '../../util/notification/notification_helper.dart';
import '../detail/detail_screen.dart';
import '../settings/setting_screen.dart';
import '../../domain/data/api/api_service.dart';
import '../../util/state/ResultState.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/main_screen';

  final String title;
  final ApiService apiService;
  final DbService dbService;

  const MainScreen({super.key, required this.title, required this.apiService, required this.dbService});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final NotificationHelper _notificationHelper = NotificationHelper();

  Timer? _debounce;
  RestaurantProvider? _provider;

  @override
  void initState() {
    super.initState();
    _notificationHelper
        .configureSelectNotificationSubject(DetailScreen.routeName);
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .inversePrimary,
          title: Text(widget.title),
          actions: [
            IconButton(icon: const Icon(Icons.star_rate_sharp), onPressed: () {
              Navigation.intent(FavoriteRestaurantScreen.routeName);
            }),
            IconButton(icon: const Icon(Icons.settings), onPressed: () {
              Navigation.intent(SettingScreen.routeName);
            })
          ]
        ),
        body: MultiProvider(
          providers: [
            ChangeNotifierProvider<RestaurantProvider>(
              create: (_) {
                _provider = RestaurantProvider(apiService: widget.apiService);
                _provider?.fetchRestaurants("");
                return _provider!;
              },
            )
          ],
          child: Column(
            children: [
              _searchBarWidget(),
              _buildList()
            ],
          ),
        )
    );
  }

  Widget _buildList() {
    return Consumer<RestaurantProvider>(
        builder: (context, state, _) {
          switch (state.state) {
            case ResultState.loading:
              return const Center(child: CircularProgressIndicator());
            case ResultState.hasData:
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: ListView.builder(
                    itemCount: state.result.restaurants.length,
                    itemBuilder: (context, index) {
                      return ListRestaurantContainer(
                        restaurant: state.result.restaurants[index],
                        onTap: (id){
                          Navigation.intentWithData(DetailScreen.routeName, id);
                        },
                      );
                    },
                  ),
                ),
              );
            case ResultState.noData:
              return Center(child: Material(child: Text(state.message)));
            case ResultState.error:
              return const Center(child: Material(child: Text("There is no internet connection")));
            default:
              return const Center(child: Material(child: Text('')));
          }
        }
    );
  }

  Widget _searchBarWidget() {
    return SearchBar(
        padding: const MaterialStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 16.0)),
        onTap: () {},
        onChanged: (value) {
          debounceQuery(value);
        },
        leading: const Icon(Icons.search),
        hintText: "Search Here",
    );
  }

  void debounceQuery(String value) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _provider?.fetchRestaurants(value);
    });
  }

}