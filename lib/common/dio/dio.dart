import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jari_bean/common/const/data.dart';
import 'package:jari_bean/common/models/default_transfer_model.dart';
import 'package:jari_bean/common/secure_storage/secure_storage.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  final storage = ref.watch<FlutterSecureStorage>(secureStorageProvider);

  dio.interceptors.add(CustomInterceptor(storage: storage));

  return dio;
});

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  CustomInterceptor({
    required this.storage,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    print('[REQ] [${options.method}] ${options.uri}');

    if (options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken');

      final token = await storage.read(key: ACCESS_TOKEN_KEY);

      options.headers.addAll({
        'ACCESS_AUTHORIZATION': token,
      });
    }
    if (options.headers['refreshToken'] == 'true') {
      options.headers.remove('refreshToken');

      final token = await storage.read(key: REFRESH_TOKEN_KEY);

      options.headers.addAll({
        'ACCESS_AUTHORIZATION': token,
      });
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final pResponse = DefualtTransferModel.fromJson(response.data);

    print(
      '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri} : ${pResponse.code} - ${pResponse.msg}',
    );
    response.data = pResponse.data;
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    /* 401 Error occurred
    -> 토큰을 재발급 받는 시도
    -> 토큰이 재발급 되면
    -> 새로운 토큰으로 요청 */
    late final DefualtTransferModel pResponse;
    try {
      pResponse = DefualtTransferModel.fromJson(err.response?.data);
      print(
        '[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri} : ${pResponse.code} - ${pResponse.msg}',
      );
    } catch (e) {
      print(
        '[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri} :  ',
      );
    }

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    if (refreshToken == null) {
      handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path ==
        '/api/token/jwt'; // check is error occurred from token refreshing api => if true, there is nothing we can do to fix this error

    if (isStatus401 && !isPathRefresh) {
      final dio = Dio();

      try {
        final resp = await dio.patch(
          '$ip/api/token/jwt',
          options: Options(
            headers: {
              'REFRESH_AUTHORIZATION': refreshToken,
            },
          ),
        );
        final pData = DefualtTransferModel.fromJson(resp.data);
        final newAccessToken = pData.data['accessToken'];
        final newRefreshToken = pData.data['refreshToken'];

        final options = err.requestOptions;

        options.headers.addAll({
          'ACCESS_AUTHORIZATION': newAccessToken,
        });

        await storage.write(key: ACCESS_TOKEN_KEY, value: newAccessToken);
        await storage.write(key: REFRESH_TOKEN_KEY, value: newRefreshToken);

        Response response = await dio.fetch(err.requestOptions);

        final pResponse = DefualtTransferModel.fromJson(response.data);

        print(
          '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri} : ${pResponse.code} - ${pResponse.msg}',
        );
        response.data = pResponse.data;

        return handler.resolve(response);
      } on DioException catch (e) {
        if (e.response?.statusCode == 401) {
          return;
        }
        return handler.reject(e);
      }
    }

    return handler.reject(err);
  }
}
