import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final alertDBProvider = Provider<Future<Database>>((ref) async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'alert_db.db');
  final db = await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) {
      //create two tables
      db.execute('''
        CREATE TABLE alerts(
          id TEXT PRIMARY KEY,
          title TEXT,
          body TEXT,
          type TEXT NOT NULL,
          receivedAt TEXT NOT NULL,
          detailedBody TEXT,
          isRead INTEGER
        )''');
      db.execute('''
        CREATE TABLE alert_data(
          id TEXT PRIMARY KEY,
          matchingId TEXT,
  		    cafeId TEXT,
  	      reservationId TEXT,
          announcementId TEXT,
          adsId TEXT
        )''');
    },
  );
  return db;
});
