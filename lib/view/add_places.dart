import 'package:favourite_place/controller/add_place_controller.dart';
import 'package:favourite_place/utils/config.dart';
import 'package:favourite_place/widgets/image_input.dart';
import 'package:favourite_place/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPlacesScreen extends StatefulWidget {
  const AddPlacesScreen({super.key});

  @override
  State<AddPlacesScreen> createState() => _AddPlacesScreenState();
}

class _AddPlacesScreenState extends State<AddPlacesScreen> {
  @override
  Widget build(BuildContext context) {
    final addPlaceController = Get.put(AddPlaceController());
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConfig.addNewPlace),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: AppConfig.title,
              ),
              style: TextStyle(color: theme.colorScheme.onSurface),
              controller: addPlaceController.titleController,
            ),
            const SizedBox(
              height: 10,
            ),
            const ImageInput(),
            const SizedBox(
              height: 10,
            ),
            const LocationInput(),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton.icon(
              onPressed: ()async{
                final result = await addPlaceController.savePlace();
                result.fold(
                      (failure) => Get.snackbar("Error", failure.message,
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white),
                      (success) => Get.snackbar("Success", "Place added successfully!",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white),
                );
              },
              label: Text(AppConfig.addPlace),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
