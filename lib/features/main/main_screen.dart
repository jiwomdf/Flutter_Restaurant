import 'package:flutter/material.dart';
import 'package:fundamental_beginner_restourant/features/main/restaurant_provider.dart';
import 'package:provider/provider.dart';
import '../../domain/data/api/api_service.dart';
import '../../domain/entities/restaurant_element.dart';
import '../../util/state/ResultState.dart';
import 'list/list_restaurants_container.dart';

class MainScreen extends StatefulWidget {

  final String title;
  final ApiService apiService;

  const MainScreen({super.key, required this.title, required this.apiService});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

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
              _buildList()
            ],
          ),
        )
    );
  }

  Widget _buildList() {
    return Consumer<RestaurantProvider>(
        builder: (context, state, _) {
          if (state.state == ResultState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.state == ResultState.hasData) {
            return Expanded(
              child: ListView.builder(
                itemCount: state.result.restaurants.length,
                itemBuilder: (context, index) {
                  return ListRestaurantContainer(restaurant: state.result.restaurants[index]);
                },
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
          debugPrint("value: $value");
        },
        leading: const Icon(Icons.search)
    );
  }

}