import 'package:favourite_place/controller/add_place_controller.dart';
import 'package:favourite_place/model/place.dart';
import 'package:favourite_place/view/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlaceDetailScreen extends StatelessWidget {
  final Place place;
  const PlaceDetailScreen({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final addPlaceController = Get.put(AddPlaceController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          place.title,
          style: theme.textTheme.bodyLarge!
              .copyWith(color: theme.colorScheme.onSurface),
        ),
      ),
      body: Stack(
        children: [
          if (place.image.existsSync()) // Image file exists or not
            Image.file(
              place.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) =>
              const Center(child: Text("Error loading image")),
            )
          else
            const Center(child: Text("No image available")),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [

                GestureDetector(
                  onTap: () {
                    Get.to(() => MapScreen(
                          location: place.location,
                          isSelecting: false,
                        ),);
                  },
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage:
                          place.location.address.isNotEmpty
                          ? NetworkImage(
                            addPlaceController.locationImage,
                          )
                              : null,
                          child: place.location.address.isEmpty
                          ? const Icon(Icons.location_off, size: 40)
                              : null,
                          ),
                  ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black54,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Text(
                    place.location.address.isNotEmpty
                        ? place.location.address
                        : "No Address Available",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge!
                        .copyWith(color: theme.colorScheme.onSurface),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
