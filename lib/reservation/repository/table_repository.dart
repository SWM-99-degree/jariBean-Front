import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/cafe/model/table_model.dart';
import 'package:jari_bean/common/const/data.dart';
import 'package:jari_bean/common/dio/dio.dart';
import 'package:jari_bean/reservation/model/table_query_model.dart';
import 'package:retrofit/retrofit.dart';

part 'table_repository.g.dart';

final tableRepositoryProvider = Provider<TableRepository>(
  (ref) => TableRepository(ref.watch(dioProvider), baseUrl: '$ip/api/cafe'),
);

@RestApi()
abstract class TableRepository {
  factory TableRepository(Dio dio, {String baseUrl}) = _TableRepository;

  @GET('/{id}/table')
  @Headers({'accessToken': 'true'})
  Future<List<TableDetailModel>> getTables({
    @Path() required String id,
    @Queries() required TableQueryModel query,
  });
}
