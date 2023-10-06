import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/common/const/data.dart';
import 'package:jari_bean/common/dio/dio.dart';
import 'package:jari_bean/common/models/offset_pagination_model.dart';
import 'package:jari_bean/common/models/pagination_params.dart';
import 'package:jari_bean/common/repository/pagination_base_repository.dart';
import 'package:jari_bean/history/model/history_model.dart';
import 'package:retrofit/retrofit.dart';

part 'history_repository.g.dart';

final matchingRepositoryProvider = Provider<MatchingRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);
    return MatchingRepository(
      dio,
      baseUrl: '$ip/api/matching',
    );
  },
);

@RestApi()
abstract class MatchingRepository
    implements IPaginationBaseRepository<MatchingModel> {
  factory MatchingRepository(Dio dio, {String baseUrl}) = _MatchingRepository;

  @override
  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<OffsetPagination<MatchingModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });
}
