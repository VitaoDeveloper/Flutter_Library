import 'package:dio/dio.dart';

class ApiClient {
  static const String defaultBaseUrl = String.fromEnvironment(
    'LIBRARY_API_BASE_URL',
    defaultValue: 'https://library-api-service.vercel.app',
  );

  final Dio client = Dio(
    BaseOptions(
      baseUrl: defaultBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );
}
