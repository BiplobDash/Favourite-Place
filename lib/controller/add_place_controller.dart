import 'package:favourite_place/model/place.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AddPlaceController extends GetxController{

  final titleController = TextEditingController();
  var places = <Place>[].obs;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
  }

  void savePlace(){
    if (titleController.text.isNotEmpty) {
      final newPlace = Place(title: titleController.text);
      places.add(newPlace);
      titleController.clear();
      Get.back();// Clear input field after saving
    }
  }

}