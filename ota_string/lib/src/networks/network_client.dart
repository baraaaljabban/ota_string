import 'package:dio/dio.dart';

class NetworkClient {
  static final NetworkClient? _instance = NetworkClient._internal();

  factory NetworkClient() => _instance ?? NetworkClient._internal();

  NetworkClient._internal();

  Future<Response<Map<String, dynamic>>> getStringTranslation(String uri) async {
    return Dio().get<Map<String, dynamic>>(uri);
  }
}