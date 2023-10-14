import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/cafe/model/cafe_description_model.dart';
import 'package:jari_bean/common/const/data.dart';
import 'package:jari_bean/common/dio/dio.dart';
import 'package:jari_bean/common/models/offset_pagination_model.dart';
import 'package:jari_bean/reservation/model/search_query_model.dart';
import 'package:retrofit/retrofit.dart';

part 'cafe_repository.g.dart';

final cafeRepositoryProvider = Provider<CafeRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);
    return CafeRepository(dio, baseUrl: '$ip/api/cafe');
  },
);

@RestApi()
abstract class CafeRepository {
  factory CafeRepository(Dio dio, {String baseUrl}) = _CafeRepository;

  @POST('/')
  Future<OffsetPagination<CafeDescriptionModel>> search(
    @Body() SearchQueryModel searchQuery,
  );
}
