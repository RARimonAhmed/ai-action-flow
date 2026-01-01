import 'package:ai_action_flow/app/config/constants/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../../core/utils/logger.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {
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
        onRequest: (options, handler) async {
          // Add API key from environment
          final apiKey = const String.fromEnvironment('OPENAI_API_KEY');
          if (apiKey.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $apiKey';
          }

          AppLogger.i('API Request: ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          AppLogger.i('API Response: ${response.statusCode}');
          return handler.next(response);
        },
        onError: (error, handler) {
          AppLogger.e('API Error: ${error.message}', error);
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