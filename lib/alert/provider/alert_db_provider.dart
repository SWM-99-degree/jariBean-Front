import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final alertDBProvider = Provider<Future<Database>>((ref) async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, 'alert_db.db');
  if (kDebugMode) deleteDatabase(path); // Todo: remove this line in production
  final db = await openDatabase(
    path,
    version: 1,
    onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
    onCreate: (db, version) {
      db.execute('''
        CREATE TABLE alerts(
          id TEXT PRIMARY KEY,
          title TEXT,
          body TEXT,
          type TEXT NOT NULL,
          receivedAt TEXT NOT NULL,
          isRead INTEGER,
          data TEXT
        )''');
      db.execute('''
        CREATE TABLE alert_data(
          id TEXT PRIMARY KEY,
          data TEXT,
          CONSTRAINT fk_alert_id
            FOREIGN KEY (id)
            REFERENCES alerts(id)
            ON DELETE CASCADE
        )
      ''');
    },
  );
  return db;
});
