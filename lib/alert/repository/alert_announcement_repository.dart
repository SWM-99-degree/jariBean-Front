import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/alert/model/alert_announcement_model.dart';
import 'package:jari_bean/common/const/data.dart';
import 'package:jari_bean/common/dio/dio.dart';
import 'package:jari_bean/common/models/offset_pagination_model.dart';
import 'package:jari_bean/common/models/pagination_params.dart';
import 'package:jari_bean/common/repository/pagination_base_repository.dart';
import 'package:retrofit/retrofit.dart';

part 'alert_announcement_repository.g.dart';

final alertAnnouncementRepositoryProvider =
    Provider<AlertAnnouncementRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);
    return AlertAnnouncementRepository(
      dio,
      baseUrl: '$ip/api/notification',
    );
  },
);

@RestApi()
abstract class AlertAnnouncementRepository
    implements IPaginationBaseRepository<AlertAnnouncementModel> {
  factory AlertAnnouncementRepository(Dio dio, {String baseUrl}) =
      _AlertAnnouncementRepository;

  @override
  @GET('')
  @Headers({
    'accessToken': 'true',
  })
  Future<OffsetPagination<AlertAnnouncementModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });

  @GET('')
  @Headers({
    'accessToken': 'true',
  })
  Future<OffsetPagination<AlertAnnouncementModel>> latestAlert({
    @Queries() PaginationParams? paginationParams = const PaginationParams(
      size: 1,
    ),
  });
}
