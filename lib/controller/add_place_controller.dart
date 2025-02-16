import 'dart:convert';
import 'dart:io';
import 'package:favourite_place/model/place.dart';
import 'package:favourite_place/view/map_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class AddPlaceController extends GetxController {

  final titleController = TextEditingController();
  var places = <Place>[].obs;
  var selectedImage = Rx<File?>(null);
  PlaceLocation? pickedLocation;
  RxBool isGettingLocation = false.obs;
  final String _key = "AIzaSyD9bX-LxrmtDFbF5ehIVg7gtZSdtcsxwec";

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
  }

  // Save Data in Places Model
  void savePlace() {
    if (titleController.text.isNotEmpty ||
        selectedImage.value != null ||
        pickedLocation != null) {
      final newPlace = Place(
        title: titleController.text,
        image: selectedImage.value!,
        location: pickedLocation!,
      );
      places.add(newPlace);
      titleController.clear();
      Get.back(); // Clear input field after saving
    }
    onInit();
  }

  // Image Input
  void takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    if (pickedImage == null) return;
    selectedImage.value = File(pickedImage.path);
    onInit();
  }

  // Save Location
  void _savePlaceLoc(double latitude, double longitude) async{
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$_key');
    final response = await http.get(url);
    final resData = json.decode(response.body);
    final address = resData['results'][0]['formatted_address'];

    pickedLocation =
        PlaceLocation(latitude: latitude, longitude: longitude, address: address);
    isGettingLocation.value = false;
    onInit();
  }

  String get locationImage {
    if (pickedLocation == null) {
      return '';
    }
    final lat = pickedLocation!.latitude;
    final lng = pickedLocation!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=$_key';
  }

  // Get Current Location
  void getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    isGettingLocation.value = true;
    locationData = await location.getLocation();

    // Google Geocoding Api
    final lat = locationData.latitude;
    final lng = locationData.longitude;
    if (lat == null || lng == null) return;
    _savePlaceLoc(lat, lng);
  }

  // Select On Map
  void selectOnMap() async{
    final pickedLocation =  await Get.to<LatLng>(() => const MapScreen());
    if(pickedLocation == null) return;
    _savePlaceLoc(pickedLocation.latitude, pickedLocation.longitude);
  }
}
