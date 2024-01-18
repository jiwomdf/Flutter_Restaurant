import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fundamental_beginner_restourant/domain/entities/restaurant_element.dart';

import '../../util/stringutil/string_util.dart';

class DetailScreen extends StatelessWidget {
  final Restaurant restaurant;

  const DetailScreen({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(restaurant.name),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0)),
                    child: CachedNetworkImage(
                        imageUrl: "${StringUtil.imgMediumUrl}${restaurant.pictureId}",
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error)),
                  )),
              const Padding(
                  padding: EdgeInsets.only(left: 8, top: 16),
                  child: Text("Location")),
              Padding(
                  padding: const EdgeInsets.only(left: 8, top: 2),
                  child: Text(restaurant.city,
                      style: const TextStyle(
                          wordSpacing: 2, fontWeight: FontWeight.bold))),
              const Padding(
                  padding: EdgeInsets.only(left: 8, top: 16),
                  child: Text("Rating")),
              Padding(
                  padding: const EdgeInsets.only(left: 4, top: 2),
                  child: Row(
                    children: [
                      const Icon(Icons.star_rate_rounded),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(restaurant.rating.toString(),
                            style: const TextStyle(
                                wordSpacing: 2, fontWeight: FontWeight.bold)),
                      )
                    ],
                  )),
              const Padding(
                  padding: EdgeInsets.only(left: 8, top: 16),
                  child: Text("Foods")),
              Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4),
                  child: SizedBox(
                      height: 50,
                      child: ListView.builder(
                          itemCount: restaurant.menus.foods.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final foods = restaurant.menus.foods[index];
                            return Padding(
                                padding:
                                    const EdgeInsets.only(left: 2, right: 2),
                                child: Chip(label: Text(foods.name)));
                          }))),
              const Padding(
                  padding: EdgeInsets.only(left: 8, top: 8),
                  child: Text("Drinks")),
              Padding(
                  padding: const EdgeInsets.only(left: 8, top: 4),
                  child: SizedBox(
                    height: 50,
                    child: ListView.builder(
                        itemCount: restaurant.menus.drinks.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final drink = restaurant.menus.drinks[index];
                          return Padding(
                              padding: const EdgeInsets.only(left: 2, right: 2),
                              child: Chip(label: Text(drink.name)));
                        }),
                  )),
              Padding(
                  padding: const EdgeInsets.only(left: 8, top: 16),
                  child: Text(restaurant.description))
            ],
          ),
        ));
  }
}
