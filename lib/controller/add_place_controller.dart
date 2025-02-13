import 'dart:io';

import 'package:favourite_place/model/place.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddPlaceController extends GetxController {
  final titleController = TextEditingController();
  var places = <Place>[].obs;
  File? selectedImage;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
  }

  void savePlace() {
    if (titleController.text.isNotEmpty) {
      final newPlace = Place(title: titleController.text);
      places.add(newPlace);
      titleController.clear();
      Get.back(); // Clear input field after saving
    }
  }

  void takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    if(pickedImage == null) return;
    selectedImage = File(pickedImage.path);
    onInit();
  }
}
