import 'dart:developer';

import 'package:dio/dio.dart';

class UserDataService {
  final Dio _dio;

  const UserDataService(this._dio);

  static const _domain = 'flutter-sandbox.free.beeceptor.com';
  static const _endpoint = '/upload_photo/';

  Future<Response> uploadUserData({
    required FormData formData,
  }) async {
    try {
      final uri = Uri.https(_domain, _endpoint);
      // log('uri: $uri');
      final response = await _dio.postUri(uri, data: formData);
      // log('response: $response');
      return response;
    } on DioException catch (e, st) {
      log(
        'DioException caught inside uploadUserData()',
        error: e.message,
        stackTrace: st,
      );
      rethrow;
    }
  }
}
