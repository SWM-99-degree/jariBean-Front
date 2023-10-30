import 'package:jari_bean/cafe/model/table_display_model.dart';
import 'package:jari_bean/common/utils/utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'table_reservation_model.g.dart';

class TableReservationInfo {
  final List<TableReservationModel> tableReservationList;
  final bool isAvailable;

  TableReservationInfo({
    required this.tableReservationList,
    required this.isAvailable,
  });

  factory TableReservationInfo.fromTableDisplayModel({
    required String cafeId,
    required TableDisplayModel model,
    required DateTime startTime,
    required DateTime endTime,
  }) {
    late final bool isAvailable;
    final List<TableReservationModel> tableReservationList = [];
    if (model.isAvaliable) {
      tableReservationList.add(
        TableReservationModel(
          cafeId: cafeId,
          tableId: model.tableModel.id,
          startTime: startTime,
          endTime: endTime,
        ),
      );
      isAvailable = true;
    } else {
      tableReservationList.addAll(
        model.alternativeAvaliableTimeRangeList.map(
          (e) => TableReservationModel(
            cafeId: cafeId,
            tableId: model.tableModel.id,
            startTime: e.startTime,
            endTime: e.endTime,
          ),
        ),
      );
      isAvailable = tableReservationList.isNotEmpty;
    }

    return TableReservationInfo(
      tableReservationList: tableReservationList,
      isAvailable: isAvailable,
    );
  }
}

@JsonSerializable()
class TableReservationModel {
  final String cafeId;
  final String tableId;
  @JsonKey(name: 'startTime')
  final DateTime startTime;
  @JsonKey(name: 'endTime')
  final DateTime endTime;

  TableReservationModel({
    required this.cafeId,
    required this.tableId,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toJson() => _$TableReservationModelToJson(this);

  String toConfirmString() {
    return '${Utils.getYYYYMMDDfromDateTime(startTime)} ${Utils.getHHMMfromDateTime(startTime)} ~ ${Utils.getHHMMfromDateTime(endTime)}';
  }
}
