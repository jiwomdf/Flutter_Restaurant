import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fundamental_beginner_restourant/features/main/restaurant_provider.dart';
import 'package:provider/provider.dart';
import 'list/list_restaurants_container.dart';
import '../../domain/data/api/api_service.dart';
import '../../util/state/ResultState.dart';

class MainScreen extends StatefulWidget {

  final String title;
  final ApiService apiService;

  const MainScreen({super.key, required this.title, required this.apiService});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  Timer? _debounce;
  late final RestaurantProvider _provider;

  @override
  void dispose() {
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
        ),
        body: ChangeNotifierProvider<RestaurantProvider>(
          create: (_) {
            _provider = RestaurantProvider(apiService: widget.apiService);
            _provider.fetchRestaurants("");
            return _provider;
        },
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
                      return ListRestaurantContainer(restaurant: state.result.restaurants[index]);
                    },
                  ),
                ),
              );
            case ResultState.noData:
              return Center(
                child: Material(
                  child: Text(state.message),
                ),
              );
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
      _provider.fetchRestaurants(value);
    });
  }

}