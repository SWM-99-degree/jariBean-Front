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
      print(err.response?.data);
      pResponse = DefualtTransferModel.fromJson(err.response?.data);
      print(
        '[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri} : ${pResponse.code} - ${pResponse.msg}',
      );
    } catch (e) {
      print(
        '[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri} : 500 Internal Server Error',
      );
    }

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    if (refreshToken == null) {
      handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh =
        err.requestOptions.path == '/auth/token'; //token 리프레시 하다가 발생한 에러인가?

    if (isStatus401 && !isPathRefresh) {
      final dio = Dio();

      try {
        final resp = await dio.post(
          '$ip/auth/token',
          options: Options(
            headers: {
              'ACCESS_AUTHORIZATION': refreshToken,
            },
          ),
        );
        final accessToken = resp.data['accessToken'];

        final options = err.requestOptions;

        options.headers.addAll({
          'ACCESS_AUTHORIZATION': accessToken,
        });

        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        final response = await dio.fetch(err.requestOptions);

        return handler.resolve(response);
      } on DioException catch (e) {
        return handler.reject(e);
      }
    }

    return handler.reject(err);
  }
}
