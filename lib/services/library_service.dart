import '../utils/api/api_result.dart';
import '../api/api_client.dart';
import 'package:dio/dio.dart';

class LibraryService {
  final api = ApiClient().client;

  /// Returns raw map: { "Fiction": ["Book A", "Book B"], ... }
  Future<ApiResult<Map<String, List<String>>>> getAll() async {
    try {
      final response = await api.get('/getall');
      final raw = response.data as Map<String, dynamic>;

      final result = raw.map(
        (genre, books) => MapEntry(
          genre,
          (books as List).map((b) => b.toString()).toList(),
        ),
      );

      return ApiResult.success(result);
    } on DioException catch (e) {
      return ApiResult.failure(_handleError(e));
    } catch (e) {
      return ApiResult.failure('Unexpected error: $e');
    }
  }

  /// [table]: 'books' or 'genres'
  Future<ApiResult<Map<String, dynamic>>> create({
    required String table,
    required String name,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await api.post('/create/$table/$name', data: body);
      return ApiResult.success(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      return ApiResult.failure(_handleError(e));
    } catch (e) {
      return ApiResult.failure('Unexpected error: $e');
    }
  }

  /// [table]: 'books' or 'genres'
  /// [currentName]: current name used in WHERE clause
  Future<ApiResult<Map<String, dynamic>>> edit({
    required String table,
    required String currentName,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await api.patch('/edit/$table/$currentName', data: body);
      return ApiResult.success(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      return ApiResult.failure(_handleError(e));
    } catch (e) {
      return ApiResult.failure('Unexpected error: $e');
    }
  }

  /// [table]: 'books' or 'genres'
  Future<ApiResult<Map<String, dynamic>>> delete({
    required String table,
    required String name,
  }) async {
    try {
      final response = await api.delete('/delete/$table/$name');
      return ApiResult.success(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      return ApiResult.failure(_handleError(e));
    } catch (e) {
      return ApiResult.failure('Unexpected error: $e');
    }
  }

  String _handleError(DioException e) {
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
