import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pyshop_task_camera_app/data/models/user_location.dart';

class LocationService {
  final Dio _dio;

  const LocationService(this._dio);

  static const _domain = 'api.bigdatacloud.net';
  static const _endpoint = '/data/reverse-geocode-client';

  Future<UserLocation> getUserLocation() async {
    try {
      final uri = Uri.https(_domain, _endpoint);
      final response = await _dio.getUri(uri);
      final data = Map<String, dynamic>.from(response.data);
      final userLocation = UserLocation.fromJson(data);
      return userLocation;
    } on DioException catch (e, st) {
      log(
        'DioException caught inside getUserLocation()',
        error: e.message,
        stackTrace: st,
      );
      rethrow;
    }
  }
}
