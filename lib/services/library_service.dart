import 'package:dio/dio.dart';
import '../api/api_client.dart';
import '../models/genre.dart';
import '../utils/api/api_result.dart';
import '../utils/api/api_errors.dart';

class LibraryService {
  final api = ApiClient().client;
  final apiErrors = ApiErrors();

  static const String _mutationsBaseUrl = String.fromEnvironment(
    'LIBRARY_API_MUTATIONS_BASE_URL',
    defaultValue: ApiClient.defaultBaseUrl,
  );

  /// Returns a list of [Genre], each containing its [Book]s.
  Future<ApiResult<List<Genre>>> getAll() async {
    try {
      final response = await api.get('/getall');
      final raw = response.data as List<dynamic>;
      final genres = raw
          .map((g) => Genre.fromJson(g as Map<String, dynamic>))
          .toList();
      return ApiResult.success(genres);
    } on DioException catch (e) {
      return ApiResult.failure(apiErrors.handleError(e));
    } catch (e) {
      return ApiResult.failure('Unexpected error: $e');
    }
  }

  /// [table]: 'books' or 'genres'
  /// For books, body must include 'name' and 'genre_id'.
  /// For genres, body must include 'name'.
  Future<ApiResult<Map<String, dynamic>>> create({
    required String table,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await api.post('/create/$table/', data: body);
      return ApiResult.success(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      return ApiResult.failure(apiErrors.handleError(e));
    } catch (e) {
      return ApiResult.failure('Unexpected error: $e');
    }
  }

  /// [table]: 'books' or 'genres'
  /// [id]: UUID of the record to update.
  Future<ApiResult<Map<String, dynamic>>> edit({
    required String table,
    required String id,
    required Map<String, dynamic> body,
  }) async {
    try {
      final encodedId = Uri.encodeComponent(id);
      final response = await api.patch(
        '$_mutationsBaseUrl/edit/$table/$encodedId',
        data: body,
      );
      return ApiResult.success(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      return ApiResult.failure(apiErrors.handleError(e));
    } catch (e) {
      return ApiResult.failure('Unexpected error: $e');
    }
  }

  /// [table]: 'books' or 'genres'
  /// [id]: UUID of the record to delete.
  Future<ApiResult<Map<String, dynamic>>> delete({
    required String table,
    required String id,
  }) async {
    try {
      final encodedId = Uri.encodeComponent(id);
      final response = await api.delete('$_mutationsBaseUrl/delete/$table/$encodedId');
      return ApiResult.success(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      return ApiResult.failure(apiErrors.handleError(e));
    } catch (e) {
      return ApiResult.failure('Unexpected error: $e');
    }
  }
}