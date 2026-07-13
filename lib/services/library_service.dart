import '../utils/api/api_result.dart';
import '../utils/api/api_errors.dart';
import '../api/api_client.dart';
import 'package:dio/dio.dart';

class LibraryService {
  final api = ApiClient().client;
  final apiErrors = ApiErrors();

  static const String _mutationsBaseUrl = String.fromEnvironment(
    'LIBRARY_API_MUTATIONS_BASE_URL',
    defaultValue: ApiClient.defaultBaseUrl,
  );

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
      return ApiResult.failure(apiErrors.handleError(e));
    } catch (e) {
      return ApiResult.failure('Unexpected error: $e');
    }
  }

  /// [table]: 'books' or 'genres'
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
  /// [currentName]: current name used in WHERE clause
  Future<ApiResult<Map<String, dynamic>>> edit({
    required String table,
    required String currentName,
    required Map<String, dynamic> body,
  }) async {
    try {
      final encodedName = Uri.encodeComponent(currentName);
      final response = await api.patch(
        '$_mutationsBaseUrl/edit/$table/$encodedName',
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
  Future<ApiResult<Map<String, dynamic>>> delete({
    required String table,
    required String name,
  }) async {
    try {
      final encodedName = Uri.encodeComponent(name);
      final response =
          await api.delete('$_mutationsBaseUrl/delete/$table/$encodedName');
      return ApiResult.success(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      return ApiResult.failure(apiErrors.handleError(e));
    } catch (e) {
      return ApiResult.failure('Unexpected error: $e');
    }
  }
}
