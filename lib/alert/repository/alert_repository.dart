import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/alert/model/alert_model.dart';
import 'package:jari_bean/alert/provider/alert_db_provider.dart';
import 'package:sqflite/sqflite.dart';

final alertRepositoryProvider = Provider<Future<AlertRepository>>((ref) async {
  final db = await ref.read(alertDBProvider);
  return AlertRepository(db: db);
});

class AlertRepository {
  final Database db;
  AlertRepository({required this.db});

  Future<void> insertAlert(AlertModel alert) async {
    final alertJson = alert.toJson();
    final alertData = alert.data;
    alertJson.remove('data');

    await db.insert(
      'alerts',
      alertJson,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // duplicate json to prevent modifying original json
    final alertDataJson = Map<String, dynamic>.from(alertData.toJson());
    alertDataJson['id'] = alert.id;
    alertDataJson.remove('detailedBody');
    await db.insert(
      'alert_data',
      alertDataJson,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> markAsRead(String id) async {
    await db.update(
      'alerts',
      {'isRead': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAlert(String id) async {
    await db.delete(
      'alerts',
      where: 'id = ?',
      whereArgs: [id],
    );
    print('deleted alert $id');
  }

  // get alerts using cursor pagination
  Future<List<AlertModel>> getAlerts(int? offset) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'alerts',
      limit: 20,
      offset: offset ?? 0,
      orderBy: 'receivedAt DESC',
    );
    return List.generate(maps.length, (i) {
      return AlertModel.fromDB(maps[i]);
    });
  }

  Future<Map<String, dynamic>> getAlertData(String id) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'alert_data',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) {
      throw Exception('Alert data not found');
    }
    return maps[0];
  }

  Future<AlertModel> getAlert(String id) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'alerts',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) {
      throw Exception('Alert not found');
    }
    return AlertModel.fromDB(maps[0]);
  }
}
