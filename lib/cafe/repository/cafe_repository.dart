import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/cafe/model/cafe_description_model.dart';
import 'package:jari_bean/common/const/data.dart';
import 'package:jari_bean/common/dio/dio.dart';
import 'package:jari_bean/common/models/offset_pagination_model.dart';
import 'package:jari_bean/common/models/pagination_params.dart';
import 'package:jari_bean/common/repository/pagination_base_repository.dart';
import 'package:jari_bean/reservation/model/search_query_model.dart';
import 'package:retrofit/retrofit.dart';

part 'cafe_repository.g.dart';

final cafeRepositoryProvider = Provider<CafeSearchResultRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);
    return CafeSearchResultRepository(dio, baseUrl: '$ip/api/cafe');
  },
);

@RestApi()
abstract class CafeSearchResultRepository
    implements IPaginationBaseRepository<CafeDescriptionModel> {
  factory CafeSearchResultRepository(Dio dio, {String baseUrl}) =
      _CafeSearchResultRepository;

  @override
  @POST('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<OffsetPagination<CafeDescriptionModel>> paginate({
    required PaginationParams paginationParams,
    @Body() Map<String, dynamic> body = const {},
  });

  @POST('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<OffsetPagination<CafeDescriptionModel>> paginateWithBody({
    required PaginationParams paginationParams,
    @Body() required SearchQueryModel body,
  });
}
