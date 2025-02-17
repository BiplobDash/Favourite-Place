import 'dart:io';

import 'package:favourite_place/model/place.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseController extends GetxController {
  // Get Databases
  Future<Database> getDatabase() async {
    final dbPath = await getDatabasesPath();
    final db = await openDatabase(
      join(dbPath, 'places.dp'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE user_places{id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT}');
      },
      version: 1,
    );
    return db;
  }

  Future<void> loadPlaces() async {
    final db = await getDatabase();
    final data = await db.query('user_places');
    data.map(
      (row) => Place(
        id: row['id'].toString(),
        title: row['title'].toString(),
        image: File(row['image'].toString()),
        location: PlaceLocation(
          latitude: row['lat'] as double,
          longitude: row['lng'] as double,
          address: row['address'].toString(),
        ),
      ),
    ).toList();
    onInit();
  }
}
