import 'package:dio/dio.dart';
import 'dio_client.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/utils/logger.dart';

class ApiProvider {
  final DioClient dioClient;

  ApiProvider(this.dioClient);

  Future get(
      String endpoint, {
        Map<String,dynamic>? queryParameters,
      }) async {
    try {
      final response = await dioClient.dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future post(
      String endpoint, {
        dynamic data,
        Map<String,dynamic>? queryParameters,
      }) async {
    try {
      final response = await dioClient.dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future put(
      String endpoint, {
        dynamic data,
        Map<String,dynamic>? queryParameters,
      }) async {
    try {
      final response = await dioClient.dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future delete(
      String endpoint, {
        Map<String,dynamic>? queryParameters,
      }) async {
    try {
      final response = await dioClient.dio.delete(
        endpoint,
        queryParameters: queryParameters,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  dynamic _handleResponse(Response response) {
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      AppLogger.d('API Success: ${response.statusCode}');
      return response.data;
    } else {
      throw ServerException(
        'Server error: ${response.statusCode}',
        response.statusCode,
      );
    }
  }

  Exception _handleError(DioException error) {
    AppLogger.e('API Error Type: ${error.type}', error);

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timeout. Please try again.');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['error']?['message'] ??
            'Server error occurred';
        return ServerException(message, statusCode);

      case DioExceptionType.cancel:
        return ServerException('Request was cancelled');

      case DioExceptionType.connectionError:
        return NetworkException(
          'No internet connection. Please check your network.',
        );

      default:
        return NetworkException(
          'An unexpected error occurred. Please try again.',
        );
    }
  }

  void dispose() {
    dioClient.dispose();
  }
}