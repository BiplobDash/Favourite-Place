import 'package:favourite_place/model/place.dart';
import 'package:favourite_place/utils/config.dart';
import 'package:favourite_place/view/place_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlacesListScreen extends StatelessWidget {
  final List<Place> places;
  const PlacesListScreen({super.key, required this.places});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Obx(() {
        if (places.isEmpty) {
          return Center(
            child: Text(
              AppConfig.noPlacesAdd,
              style: theme.textTheme.bodyLarge!
                  .copyWith(color: theme.colorScheme.onSurface),
            ),
          );
        }
        return ListView.builder(
          itemCount: places.length,
          itemBuilder: (ctx, index) => ListTile(
            title: Text(
              places[index].title,
              style: theme.textTheme.titleMedium!
                  .copyWith(color: theme.colorScheme.onSurface),
            ),
            onTap: () {
              Get.to(
                () => PlaceDetailScreen(place: places[index]),
              );
            },
          ),
        );
      }),
    );
  }
}
