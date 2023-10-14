import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/common/const/data.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

part 'geocode_repository.g.dart';

final geocodeRepositoryProvider = Provider<GeocodeRepository>((ref) {
  final dio = Dio();
  return GeocodeRepository(
    dio,
    baseUrl: 'https://dapi.kakao.com/v2/local',
  );
});

@RestApi()
abstract class GeocodeRepository {
  factory GeocodeRepository(Dio dio, {String baseUrl}) = _GeocodeRepository;

  @GET('/geo/coord2regioncode.json')
  @Headers({'Authorization': 'KakaoAK $kakaoClientId'})
  Future<GeocodeModel> getGeocode(
    @Query('x') double longitude,
    @Query('y') double latitude,
    @Query('input_coord') String inputCoord,
    @Query('output_coord') String outputCoord,
  );
}

@JsonSerializable()
class GeocodeModel {
  final List<GeocodeDocument> documents;

  GeocodeModel({
    required this.documents,
  });

  factory GeocodeModel.fromJson(Map<String, dynamic> json) =>
      _$GeocodeModelFromJson(json);
}

@JsonSerializable()
class GeocodeDocument {
  @JsonKey(name: 'region_type')
  final String regionType;
  @JsonKey(name: 'address_name')
  final String addressName;

  GeocodeDocument({
    required this.addressName,
    required this.regionType,
  });

  factory GeocodeDocument.fromJson(Map<String, dynamic> json) =>
      _$GeocodeDocumentFromJson(json);
}
