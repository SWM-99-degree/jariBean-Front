import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/cafe/model/cafe_description_model.dart';
import 'package:jari_bean/common/const/data.dart';
import 'package:jari_bean/common/dio/dio.dart';
import 'package:jari_bean/common/models/offset_pagination_model.dart';
import 'package:jari_bean/common/models/pagination_params.dart';
import 'package:jari_bean/common/repository/pagination_base_repository.dart';
import 'package:retrofit/retrofit.dart';

part 'hotplace_cafes_repository.g.dart';

final hotplaceCafesRepositoryProvider = Provider<HotplaceCafesRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);
    return HotplaceCafesRepository(
      dio,
      baseUrl: '$ip/api/home/best',
    );
  },
);

@RestApi()
abstract class HotplaceCafesRepository
    implements IPaginationBaseRepository<CafeDescriptionModel> {
  factory HotplaceCafesRepository(Dio dio, {String baseUrl}) =
      _HotplaceCafesRepository;
  @override
  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<OffsetPagination<CafeDescriptionModel>> paginate({
    required PaginationParams? paginationParams,
  });
}
