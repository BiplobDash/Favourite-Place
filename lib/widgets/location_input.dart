import 'package:favourite_place/controller/add_place_controller.dart';
import 'package:favourite_place/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocationInput extends StatelessWidget {
  const LocationInput({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final addPlaceController = Get.put(AddPlaceController());

    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: theme.colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: Obx(() {
            if (addPlaceController.pickedLocation != null) {
              return Image.network(
                addPlaceController.locationImage,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
            }
            if (addPlaceController.isGettingLocation.value) {
              return const CircularProgressIndicator();
            }
            return Text(
              AppConfig.noLocationChosen,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge!.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            );
          }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: ()async{
                final result = await addPlaceController.getCurrentLocation();
                result.fold(
                      (failure) => Get.snackbar("Error", failure.message,
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white),
                      (success) => Get.snackbar("Success", "Get Current Location Successfully!",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white),
                );
              },
              label: Text(
                AppConfig.getCurrentLocation,
              ),
              icon: const Icon(Icons.location_on),
            ),
            TextButton.icon(
              onPressed: () async{
                final result = await addPlaceController.selectOnMap();
                result.fold(
                      (failure) => Get.snackbar("Error", failure.message,
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white),
                      (success) => Get.snackbar("Success", "Select On Map Successfully!",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white),
                );
              },
              label: Text(
                AppConfig.selectOnMap,
              ),
              icon: const Icon(Icons.map),
            ),
          ],
        ),
      ],
    );
  }
}
