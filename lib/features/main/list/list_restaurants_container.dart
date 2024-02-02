import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fundamental_beginner_restourant/util/ext/StringExt.dart';
import '../../../domain/data/api/response/restaurant_element.dart';
import '../../../util/stringutil/string_util.dart';

class ListRestaurantContainer extends StatelessWidget {
  final Restaurant restaurant;
  final Function(String id) onTap;

  const ListRestaurantContainer({super.key, required this.restaurant, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: InkWell(
            onTap: () {
              onTap(restaurant.id);
            },
            child: Row(
              children: [
                Expanded(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: CachedNetworkImage(
                            imageUrl: "${StringUtil.imgSmallUrl}${restaurant.pictureId}",
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            width: 150,
                            height: 100,
                            fit: BoxFit.fill))),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(restaurant.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(
                        restaurant.description.dotText(20),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star_rate_rounded),
                          Padding(
                              padding: const EdgeInsets.only(left: 6, top: 2),
                              child: Text(restaurant.rating.toString()))
                        ],
                      )
                    ],
                  ),
                ))
              ],
            )));
  }
}
