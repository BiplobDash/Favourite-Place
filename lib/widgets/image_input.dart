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
      child: Obx((){
        if (addPlaceController.selectedImage.value != null) {
          return GestureDetector(
            onTap: ()async{
              final result = await addPlaceController.takePicture();
              result.fold(
                    (failure) => Get.snackbar("Error", failure.message,
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white),
                    (success) => Get.snackbar("Success", "Image Selected Successfully!",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white),
              );
            },
            child: Image.file(
              addPlaceController.selectedImage.value!,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          );
        }
        return TextButton.icon(
          onPressed: addPlaceController.takePicture,
          label: Text(AppConfig.takePicture),
          icon: const Icon(Icons.camera),
        );
      }),
    );
  }
}
