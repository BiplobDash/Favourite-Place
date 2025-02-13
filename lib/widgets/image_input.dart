import 'package:favourite_place/controller/add_place_controller.dart';
import 'package:favourite_place/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageInput extends StatelessWidget {
  const ImageInput({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final addPlaceController = Get.put(AddPlaceController());
    Widget content = TextButton.icon(
      onPressed: addPlaceController.takePicture,
      label: Text(AppConfig.takePicture),
      icon: const Icon(Icons.camera),
    );

    if (addPlaceController.selectedImage != null) {
      content = GestureDetector(
        onTap: addPlaceController.takePicture,
        child: Image.file(
          addPlaceController.selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      );
    }
    return Container(
      width: double.infinity,
      height: 250,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: theme.colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: content,
    );
  }
}
