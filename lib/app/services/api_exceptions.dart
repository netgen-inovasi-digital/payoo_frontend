import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String url;
  final String message;
  final int? statusCode;
  final Response? response;

  ApiException(
      {required this.url,
      required this.message,
      this.response,
      this.statusCode});

  /// IMPORTANT NOTE
  /// here you can take advantage of toString() method to display the error for user
  /// lets make an example
  /// so in onError method when you make api you can just user apiExceptionInstance.toString() to get the error message from api

  @override
  toString() {
    String result = '';
    // Prioritaskan field 'error' jika ada
    result += response?.data?['error']?.toString() ?? '';
    // Jika kosong, coba ambil 'message'
    if (result.isEmpty) {
      result += response?.data?['message']?.toString() ?? '';
    }
    // Jika masih kosong, fallback ke message bawaan (biasanya berasal dari Dio)
    if (result.isEmpty) {
      result += message;
    }
    return result;
  }
}
