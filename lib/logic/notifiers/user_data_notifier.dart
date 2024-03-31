import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:pyshop_task_camera_app/data/models/user_location.dart';
import 'package:pyshop_task_camera_app/data/models/user_data.dart';
import 'package:pyshop_task_camera_app/logic/notifiers/camera_permission_notifier.dart';
import 'package:pyshop_task_camera_app/logic/providers/dio_provider.dart';
import 'package:pyshop_task_camera_app/logic/providers/location_provider.dart';
import 'package:pyshop_task_camera_app/logic/providers/text_controller_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_data_notifier.g.dart';

@riverpod
class UserDataNotifier extends _$UserDataNotifier {
  @override
  AsyncValue<UserData> build() {
    return const AsyncLoading();
  }

  Future<UserLocation> _getUserLocation() async {
    final service = ref.read(locationServiceProvider);
    // final location = await AsyncValue.guard(service.getUserLocation);
    final location = await service.getUserLocation();
    return location;
  }

  String _getControllerText() {
    final controller = ref.read(textControllerProvider);
    final text = controller.text;
    return text;
  }

  Future<XFile> _takePhoto() async {
    try {
      final controller = ref.read(cameraPermissionNotifierProvider).value!;
      final photo = await controller.takePicture();
      return photo;
    } on CameraException catch (e, st) {
      log(
        'CameraException caught in _takePhoto()',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  // convert photo to FormData so that it could be sent over the internet
  Future<FormData> _convertPhotoToFormData() async {
    try {
      final photo = await _takePhoto();
      final convertedPhoto = File(photo.path);
      final multipartFile = await MultipartFile.fromFile(
        convertedPhoto.path,
        filename: 'test.jpg',
        // filename: convertedPhoto.name,
      );
      final formData = FormData.fromMap({'file': multipartFile});
      return formData;
      // could be thrown inside _takePhoto()
    } on CameraException catch (e, st) {
      log(
        'CameraException caught inside _sendPhoto()',
        error: e,
        stackTrace: st,
      );
      rethrow;
      // could be thrown inside MultipartFile.fromFile(..)
    } on UnsupportedError catch (e, st) {
      log(
        'UnsupportedError caught inside _sendPhoto()',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  Future<void> _sendUserData() async {
    final text = _getControllerText();
    final location = await _getUserLocation();
    final photo = await _convertPhotoToFormData();
    final url = Uri.https(
      'flutter-sandbox.free.beeceptor.com',
      '/upload_photo/',
      {
        'comment': text,
        'latitude': location.latitude,
        'longitude': location.longitude,
        'photo': photo,
      },
    ).toString();
    final dio = ref.read(dioProvider);
    final response = await dio.post(url, data: photo);
  }

  Future<void> uploadUserData() async {
    try {
      final text = _getControllerText();
      // log('this for sure gets here');
      final userLocation = await _getUserLocation();
      final photo = await _takePhoto();
      // log('don`t you tell this gets executed');
      log('photo path is: ${photo.path}');
      state = AsyncData(
        UserData(
          text: text,
          userLocation: userLocation,
          photo: photo,
        ),
      );
    } on DioException catch (e, st) {
      state = AsyncError(
        e.message ?? 'unknown connection exception',
        st,
      );
    } on CameraException catch (e, st) {
      state = AsyncError(
        e.description ?? 'unknown camera exception',
        st,
      );
    }
    log('notifier state: $state');
  }
}
