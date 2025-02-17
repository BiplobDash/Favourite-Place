import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:favourite_place/controller/database_controller.dart';
import 'package:favourite_place/model/error_handling.dart';
import 'package:favourite_place/model/place.dart';
import 'package:favourite_place/view/map_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart' as syspaths;

class AddPlaceController extends GetxController {
  final titleController = TextEditingController();
  var places = <Place>[].obs;
  var selectedImage = Rx<File?>(null);
  PlaceLocation? pickedLocation;
  RxBool isGettingLocation = false.obs;
  final String _key = "AIzaSyBESyqXBQJqyHidmmxNay_GAVCmssWZfzE";

  final dbController = Get.put(DatabaseController());

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
  }



  // Save Data in Places Model
  Future<Either<Failure, Place>> savePlace() async {
    try {
      if (titleController.text.isEmpty || selectedImage.value == null || pickedLocation == null) {
        return Left(Failure("All fields are required"));
      }

      final appDir = await syspaths.getApplicationDocumentsDirectory();
      final filename = basename(selectedImage.value!.path);
      final copiedImage = await selectedImage.value!.copy('${appDir.path}/$filename');

      final newPlace = Place(
        title: titleController.text,
        image: copiedImage,
        location: pickedLocation!,
      );

      final db = await dbController.getDatabase();
      await db.insert('user_places', {
        'id': newPlace.id,
        'title': newPlace.title,
        'image': newPlace.image.path,
        'lat': newPlace.location.latitude,
        'lng': newPlace.location.longitude,
        'address': newPlace.location.address,
      });

      places.add(newPlace);
      titleController.clear();
      Get.back();
      onInit();
      return Right(newPlace);
    } catch (e) {
      return Left(Failure("Failed to save place: ${e.toString()}"));
    }
  }


  // Take Picture
  Future<Either<Failure, File>> takePicture() async {
    try {
      final imagePicker = ImagePicker();
      final pickedImage = await imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 600,
      );

      if (pickedImage == null) {
        return Left(Failure("No image selected"));
      }

      final imageFile = File(pickedImage.path);
      selectedImage.value = imageFile;
      onInit();
      return Right(imageFile);
    } catch (e) {
      return Left(Failure("Failed to capture image: ${e.toString()}"));
    }
  }

  // Save Location
  Future<Either<Failure, PlaceLocation>> _savePlaceLoc(double latitude, double longitude) async {
    try {
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$_key');
      final response = await http.get(url);

      if (response.statusCode != 200) {
        return Left(Failure("Failed to fetch location"));
      }

      final resData = json.decode(response.body);
      if (resData['results'].isEmpty) {
        return Left(Failure("No address found for this location"));
      }

      final address = resData['results'][0]['formatted_address'];

      pickedLocation = PlaceLocation(
          latitude: latitude, longitude: longitude, address: address);
      isGettingLocation.value = false;
      onInit();
      return Right(pickedLocation!);
    } catch (e) {
      return Left(Failure("Error fetching location: ${e.toString()}"));
    }
  }

  // Location Image
  String get locationImage {
    if (pickedLocation == null) {
      return '';
    }
    final lat = pickedLocation!.latitude;
    final lng = pickedLocation!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=$_key';
  }

  // Get Current Location
  Future<Either<Failure, PlaceLocation>> getCurrentLocation() async {
    try {
      Location location = Location();

      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return Left(Failure("Location service is disabled"));
        }
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return Left(Failure("Location permission denied"));
        }
      }

      isGettingLocation.value = true;
      final locationData = await location.getLocation();

      final lat = locationData.latitude;
      final lng = locationData.longitude;
      if (lat == null || lng == null) {
        return Left(Failure("Failed to get location"));
      }

      return await _savePlaceLoc(lat, lng);
    } catch (e) {
      return Left(Failure("Error getting location: ${e.toString()}"));
    }
  }

  // Select Map
  Future<Either<Failure, PlaceLocation>> selectOnMap() async {
    try {
      final pickedLoc = await Get.to<LatLng>(() => const MapScreen());

      if (pickedLoc == null) {
        return Left(Failure("No location selected"));
      }

      return await _savePlaceLoc(pickedLoc.latitude, pickedLoc.longitude);
    } catch (e) {
      return Left(Failure("Error selecting location: ${e.toString()}"));
    }
  }
}
