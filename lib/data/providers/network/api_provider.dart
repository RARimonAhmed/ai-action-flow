import 'package:dio/dio.dart';
import 'dio_client.dart';
import '../../../core/errors/exceptions.dart';

class ApiProvider {
  final DioClient dioClient;

  ApiProvider(this.dioClient);

  Future get(String endpoint) async {
    try {
      final response = await dioClient.dio.get(endpoint);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future post(String endpoint, {dynamic data}) async {
    try {
      final response = await dioClient.dio.post(endpoint, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future put(String endpoint, {dynamic data}) async {
    try {
      final response = await dioClient.dio.put(endpoint, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future delete(String endpoint) async {
    try {
      final response = await dioClient.dio.delete(endpoint);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  dynamic _handleResponse(Response response) {
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return response.data;
    } else {
      throw ServerException('Server error: ${response.statusCode}');
    }
  }

  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timeout');
      case DioExceptionType.badResponse:
        return ServerException('Server error: ${error.response?.statusCode}');
      case DioExceptionType.cancel:
        return ServerException('Request cancelled');
      default:
        return NetworkException('Network error occurred');
    }
  }
}