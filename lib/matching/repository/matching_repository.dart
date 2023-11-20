import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/common/const/data.dart';
import 'package:jari_bean/common/dio/dio.dart';
import 'package:jari_bean/matching/model/matching_body_model.dart';
import 'package:retrofit/retrofit.dart';

part 'matching_repository.g.dart';

final matchingRepositoryProvider = Provider<MatchingRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);
    return MatchingRepository(
      dio,
      baseUrl: '$ip/api',
    );
  },
);

@RestApi()
abstract class MatchingRepository {
  factory MatchingRepository(Dio dio, {String baseUrl}) = _MatchingRepository;

  @POST('/match')
  @Headers({
    'accessToken': 'true',
  })
  Future<void> matching({@Body() required MatchingBodyModel body});
}
