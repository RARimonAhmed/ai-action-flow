import 'package:ai_action_flow/app/config/constants/api_constants.dart';
import 'package:ai_action_flow/core/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final apiKey = dotenv.env['OPENAI_API_KEY'];

          if (apiKey != null && apiKey.isNotEmpty) {
            options.headers[ApiConstants.authHeader] = 'Bearer $apiKey';
          }

          AppLogger.i('API → ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          AppLogger.i('RESPONSE ← ${response.statusCode}');
          return handler.next(response);
        },
        onError: (error, handler) {
          AppLogger.e('ERROR ✖ ${error.message}', error);
          return handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;

  void dispose() {
    _dio.close(force: true);
    AppLogger.i('DioClient disposed');
  }
}