import 'package:dio/dio.dart';

class ApiClient {
  final Dio client = Dio(
    BaseOptions(
      baseUrl: 'https://library-api-service.vercel.app',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );
}