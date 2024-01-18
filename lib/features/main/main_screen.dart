import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fundamental_beginner_restourant/features/main/restaurant_provider.dart';
import 'package:fundamental_beginner_restourant/util/ext/StringExt.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/restaurant_element.dart';
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
  String filterStr = "";

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
          create: (_) => RestaurantProvider(apiService: widget.apiService),
          child: Column(
            children: [
              _searchBarWidget(),
              _buildList(filterStr)
            ],
          ),
        )
    );
  }

  Widget _buildList(String filterStr) {
    return Consumer<RestaurantProvider>(
        builder: (context, state, _) {
          if (state.state == ResultState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.state == ResultState.hasData) {

            List<Restaurant> listData = [];
            if(filterStr.isEmpty) {
              listData = state.result.restaurants;
            } else {
              listData = state.result.restaurants
                  .where((itm) => itm.name.containsIgnoreCase(filterStr)).toList();
            }

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ListView.builder(
                  itemCount: listData.length,
                  itemBuilder: (context, index) {
                    return ListRestaurantContainer(restaurant: listData[index]);
                  },
                ),
              ),
            );
          } else if (state.state == ResultState.noData) {
            return Center(
              child: Material(
                child: Text(state.message),
              ),
            );
          } else if (state.state == ResultState.error) {
            return const Center(child: Material(child: Text("There is no internet connection")));
          } else {
            return const Center(child: Material(child: Text('')));
          }
        }
    );
  }

  Widget _searchBarWidget() {
    return SearchBar(
        padding: const MaterialStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 16.0)),
        onTap: () {
          debugPrint("onTap: taped");
        },
        onChanged: (value) {
          debounceQuery(value);
        },
        leading: const Icon(Icons.search)
    );
  }

  void debounceQuery(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        filterStr = value;
      });
    });
  }

}