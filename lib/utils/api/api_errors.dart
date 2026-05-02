import 'package:dio/dio.dart';

class ApiErrors {
  String handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Check your internet connection.';
      case DioExceptionType.badResponse:
        final status = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? 'Unknown error';
        return 'Error $status: $message';
      case DioExceptionType.connectionError:
        return 'Unable to reach the server.';
      default:
        return 'Network error: ${e.message}';
    }
  }
}