import 'package:dio/dio.dart';

class ApiErrors {
  String handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'The request timed out. Check your connection and try again.';
      case DioExceptionType.badResponse:
        final status = e.response?.statusCode;
        final message = _extractMessage(e.response?.data);
        return _mapStatusToMessage(status, message);
      case DioExceptionType.connectionError:
        return 'Unable to connect to the server.';
      default:
        return 'Network error. Please try again.';
    }
  }

  String _extractMessage(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      final message = responseData['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message.trim();
      }
    }
    if (responseData is String && responseData.trim().isNotEmpty) {
      return responseData.trim();
    }
    return 'No additional details.';
  }

  String _mapStatusToMessage(int? status, String apiMessage) {
    switch (status) {
      case 400:
        return 'The information provided is invalid. $apiMessage';
      case 404:
        return 'The requested record was not found. $apiMessage';
      case 409:
        if (_isGenreWithBooksConflict(apiMessage)) {
          return 'This genre cannot be deleted because it still has registered books.';
        }
        return 'Data conflict. This record already exists or is linked to another item. $apiMessage';
      case 500:
        return 'Server error. Please try again shortly.';
      default:
        return 'The operation failed (HTTP $status). $apiMessage';
    }
  }

  bool _isGenreWithBooksConflict(String message) {
    final lower = message.toLowerCase();
    return lower.contains('foreign key') ||
        lower.contains('constraint') ||
        lower.contains('related') ||
        lower.contains('book') ||
        lower.contains('books');
  }
}
