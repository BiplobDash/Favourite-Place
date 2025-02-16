import 'package:favourite_place/controller/add_place_controller.dart';
import 'package:favourite_place/utils/config.dart';
import 'package:favourite_place/view/add_places.dart';
import 'package:favourite_place/widgets/places_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlaceScreen extends StatelessWidget {
  const PlaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final addPlaceController = Get.put(AddPlaceController());
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConfig.yourPlaces),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(
                  () => const AddPlacesScreen(),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PlacesListScreen(
          places: addPlaceController.places,
        ),
      ),
    );
  }
}
