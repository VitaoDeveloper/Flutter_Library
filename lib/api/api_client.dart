import 'package:dio/dio.dart';

class ApiClient {
  static final Dio client = Dio(
    BaseOptions(
      baseUrl: 'https://library-api-service.vercel.app/',
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 5)
    )
  );
}
