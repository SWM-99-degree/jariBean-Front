import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/cafe/model/table_model.dart';

final tableRepositoryProvider = Provider<TableRepository>((ref) {
  return TableRepository();
});

class TableRepository {
  Future<List<TableModel>> getTables(String id) async {
    return [
      TableModel(
        id: '1',
        name: '테이블 이름',
        maxHeadcount: 2,
        imgUrl: 'https://picsum.photos/110/300',
        tableOptionsList: [
          TableType.HIGH,
          TableType.RECTANGLE,
          TableType.PLUG,
          TableType.BACKREST,
        ],
        avaliableTimeRangeList: [
          AvaliableTimeRange(
            startTime: DateTime(2023, 09, 06, 11, 30),
            endTime: DateTime(2023, 09, 06, 12, 30),
          ),
          AvaliableTimeRange(
            startTime: DateTime(2023, 08, 25, 13, 30),
            endTime: DateTime(2023, 08, 25, 14, 00),
          ),
        ],
      ),
      TableModel(
        id: '2',
        name: '테이블 이름',
        maxHeadcount: 4,
        imgUrl: 'https://picsum.photos/110/300',
        tableOptionsList: [
          TableType.HIGH,
          TableType.PLUG,
          TableType.BACKREST,
        ],
        avaliableTimeRangeList: [
          AvaliableTimeRange(
            startTime: DateTime(2023, 08, 25, 9, 30),
            endTime: DateTime(2023, 08, 25, 12, 30),
          ),
          AvaliableTimeRange(
            startTime: DateTime(2023, 08, 25, 13, 30),
            endTime: DateTime(2023, 08, 25, 16, 30),
          ),
        ],
      ),
      TableModel(
        id: '3',
        name: '테이블 이름',
        maxHeadcount: 6,
        imgUrl: 'https://picsum.photos/110/300',
        tableOptionsList: [
          TableType.PLUG,
          TableType.BACKREST,
        ],
        avaliableTimeRangeList: [
          AvaliableTimeRange(
            startTime: DateTime(2023, 08, 25, 0, 0),
            endTime: DateTime(2023, 08, 25, 20, 30),
          ),
<<<<<<< Updated upstream
=======
          
>>>>>>> Stashed changes
        ],
      ),
    ];
  }
}
