import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/cafe/model/cafe_description_model.dart';
import 'package:jari_bean/common/const/data.dart';
import 'package:jari_bean/common/dio/dio.dart';
import 'package:jari_bean/common/models/offset_pagination_model.dart';
import 'package:jari_bean/common/models/pagination_params.dart';
import 'package:jari_bean/common/repository/pagination_base_repository.dart';
import 'package:jari_bean/history/model/history_model.dart';
import 'package:retrofit/retrofit.dart';

part 'history_repository.g.dart';

final homeRepositoryProvider = Provider<HomeRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);
    return HomeRepository(
      dio,
      baseUrl: '$ip/api/home',
    );
  },
);

@RestApi()
abstract class HomeRepository {
  factory HomeRepository(Dio dio, {String baseUrl}) = _HomeRepository;

  @GET('/reserve')
  @Headers({
    'accessToken': 'true',
  })
  Future<ReservationModel?> getTodayReservation({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });

  @GET('/best')
  @Headers({
    'accessToken': 'true',
  })
  Future<OffsetPagination<CafeDescriptionModel>> getHotplaceCafesPreview({
    @Queries() PaginationParams? paginationParams = const PaginationParams(
      page: 0,
      size: 3,
    ),
  });
}

final matchingRepositoryProvider = Provider<MatchingRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);
    return MatchingRepository(
      dio,
      baseUrl: '$ip/api/match',
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

final reservationRepositoryProvider = Provider<ReservationRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);
    return ReservationRepository(
      dio,
      baseUrl: '$ip/api/reserve',
    );
  },
);

@RestApi()
abstract class ReservationRepository
    implements IPaginationBaseRepository<ReservationModel> {
  factory ReservationRepository(Dio dio, {String baseUrl}) =
      _ReservationRepository;

  @override
  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<OffsetPagination<ReservationModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });
}
