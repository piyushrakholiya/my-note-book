import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper myDatabase = DatabaseHelper._();

  Database? _database;

  // Profile table
  static const String profileTable = "profile";

  static const String profileId = "id";
  static const String profileImagePath = "imagePath";

  // ================= DATABASE =================

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();

    return _database!;
  }

  Future<Database> _initDatabase() async {
    final Directory appDir = await getApplicationDocumentsDirectory();

    final String path = join(appDir.path, 'my_notebook.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $profileTable (
            $profileId INTEGER PRIMARY KEY AUTOINCREMENT,
            $profileImagePath TEXT
          )
        ''');
      },
    );
  }

  // ================= IMAGE =================

  Future<String?> saveImagePermanently(XFile image) async {
    final Directory appDir = await getApplicationDocumentsDirectory();

    final String extensionPath = extension(image.path);

    final String fileName =
        '${DateTime.now().millisecondsSinceEpoch}$extensionPath';

    final String newPath = '${appDir.path}/$fileName';

    final File newImage = await File(image.path).copy(newPath);

    return newImage.path;
  }

  // ================= PROFILE IMAGE =================

  Future<bool> saveProfileImage(String imagePath) async {
    final db = await database;

    // જૂનો profile image path કાઢી નાખે
    await db.delete(profileTable);

    final int rows = await db.insert(profileTable, {
      profileImagePath: imagePath,
    });

    return rows > 0;
  }

  Future<String?> getProfileImage() async {
    final db = await database;

    final List<Map<String, dynamic>> result = await db.query(
      profileTable,
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first[profileImagePath] as String?;
    }

    return null;
  }

  Future<bool> deleteProfileImage() async {
    final db = await database;

    final int rows = await db.delete(profileTable);

    return rows > 0;
  }
}
