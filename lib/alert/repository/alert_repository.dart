import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/alert/model/alert_model.dart';
import 'package:jari_bean/alert/provider/alert_db_provider.dart';
import 'package:jari_bean/alert/provider/alert_provider.dart';
import 'package:jari_bean/common/models/offset_pagination_model.dart';
import 'package:jari_bean/common/models/pagination_params.dart';
import 'package:jari_bean/common/repository/pagination_base_repository.dart';
import 'package:jari_bean/common/utils/utils.dart';
import 'package:sqflite/sqflite.dart';

final alertRepositoryProvider = Provider<Future<AlertRepository>>((ref) async {
  final db = await ref.read(alertDBProvider);
  final offset = ref.read(alertOffsetProvider.notifier);
  return AlertRepository(db: db, offset: offset);
});

class AlertRepository implements IPaginationBaseRepository<AlertModel> {
  final Database db;
  final StateController<int> offset;
  AlertRepository({
    required this.db,
    required this.offset,
  });

  Future<void> insertAlert(AlertModel alert) async {
    final alertJson = alert.toDB();
    await db.insert(
      'alerts',
      alertJson,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    final alertDataJson = jsonEncode(alert.data.toJson());
    /* from model to json to string
    remind that `toJson` function is a type of `Map<String, dynamic>` and it is not a string.
    so we need to convert it to string using `jsonEncode` function.
     example:
     {
      "data":{
        "matchingId": "matchingId",
        "cafeId": "cafeId",
      },
     }
     see also : https://github.com/SWM-99-degree/jariBean-Front/issues/128
    */
    await db.insert(
      'alert_data',
      {
        'id': alert.id,
        'data': alertDataJson,
      },
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

  /// get alerts using offset pagination
  /// return type is `OffsetPagination<AlertModel>`.
  /// its parameter `page` will have the page number of the next page.
  /// if there is no more page, `last` will be `true`.
  /// example:
  /// ```
  /// OffsetPagination<AlertModel>(
  ///  content: [AlertModel, AlertModel, AlertModel],
  ///  page: 2,
  ///  last: false,
  /// )
  /// ```
  /// see also : https://github.com/SWM-99-degree/jariBean-Front/issues/129
  @override
  Future<OffsetPagination<AlertModel>> paginate({
    required PaginationParams paginationParams,
  }) async {
    await Future.delayed(Duration(seconds: 1));
    final limit = paginationParams.size ?? 20;
    final offset =
        (paginationParams.page ?? 0) * (paginationParams.size ?? 20) +
            this.offset.state;
    final List<Map<String, dynamic>> maps = await db.query(
      'alerts',
      limit: limit,
      offset: offset,
      orderBy: 'receivedAt DESC',
    );
    final List<AlertModel> alerts = List.generate(maps.length, (i) {
      return AlertModel.fromDB(maps[i]);
    });
    final last = alerts.isEmpty;
    return OffsetPagination(
      content: alerts,
      page: (paginationParams.page ?? 0) + 1,
      last: last,
    );
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

  Future<AlertModel> getAlertWithData(AlertModel model) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'alert_data',
      where: 'id = ?',
      whereArgs: [model.id],
    );
    if (maps.isEmpty) {
      throw Exception('Alert has no data : $model.id');
    }
    final alertDataJson = maps[0];
    /* has items like matchingId, cafeId etc in data, 
     example:
     {
      "data":{
        "matchingId": "matchingId",
        "cafeId": "cafeId",
      },
     }
    */
    final typeToString = model.type.toString().split('.')[1];
    /* 
      typeToString is like matchingSuccess, matchingFail etc.
      since it is enum, it is not matchingSuccess but PushMessageType.matchingSuccess
      so we need to convert it to matchingSuccess by splitting and getting the last item.
     */
    final decodedData = jsonDecode(alertDataJson['data']);
    /* 
      original `data` was encoded to json string.
      so we need to decode it to json object.
      and it has return type of `Map<String, String>`
      example : 
      {
        "matchingId": "matchingId",
        "cafeId": "cafeId",
      }
     see also : https://github.com/SWM-99-degree/jariBean-Front/issues/128
     */
    final alertData = Utils.getPushMessageData(
      type: typeToString,
      data: decodedData,
    );
    return model.replaceData(alertData);
  }
}
