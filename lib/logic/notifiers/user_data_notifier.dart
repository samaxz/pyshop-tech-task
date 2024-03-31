import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:pyshop_task_camera_app/data/models/user_data.dart';
import 'package:pyshop_task_camera_app/data/models/user_location.dart';
import 'package:pyshop_task_camera_app/logic/notifiers/camera_permission_notifier.dart';
import 'package:pyshop_task_camera_app/logic/providers/location_provider.dart';
import 'package:pyshop_task_camera_app/logic/providers/text_controller_provider.dart';
import 'package:pyshop_task_camera_app/logic/providers/user_data_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_data_notifier.g.dart';

@riverpod
class UserDataNotifier extends _$UserDataNotifier {
  @override
  AsyncValue<UserData> build() {
    // return const AsyncLoading();
    return const AsyncData(
      UserData(
        text: 'initial text',
        userLocation: UserLocation(
          latitude: 228,
          longitude: 69,
        ),
      ),
    );
  }

  Future<UserLocation> _getUserLocation() async {
    final service = ref.read(locationServiceProvider);
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

  // convert user data to FormData so that it could be sent over the internet
  // in post request's body
  Future<FormData> _convertUserDataToFormData() async {
    try {
      final text = _getControllerText();
      final location = await _getUserLocation();
      final photo = await _takePhoto();
      final convertedPhoto = File(photo.path);
      final multipartFile = await MultipartFile.fromFile(
        convertedPhoto.path,
        filename: 'test.jpg',
      );
      final formData = FormData.fromMap({
        'comment': text,
        'latitude': location.latitude,
        'longitude': location.longitude,
        // not sure if i need to add @ here or whatever
        'photo': multipartFile,
      });
      return formData;
      // TODO remove all the commented catches
      // } on DioException catch (e, st) {
      // this gets caught inside _takePhoto(), so, i have no need in using it here
      // on CameraException catch (e, st) {
      //   log(
      //     'CameraException caught inside _sendPhoto()',
      //     error: e,
      //     stackTrace: st,
      //   );
      //   rethrow;
      // could be thrown inside MultipartFile.fromFile(..)
    } on UnsupportedError catch (e, st) {
      log(
        'UnsupportedError caught inside _convertUserDataToFormData()',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  Future<void> sendUserData() async {
    try {
      if (state.isLoading) return;
      state = const AsyncLoading();
      // log('state is $state');
      final formData = await _convertUserDataToFormData();
      final service = ref.read(userDataServiceProvider);
      final response = await service.uploadUserData(formData: formData);
      state = AsyncData(
        UserData(
          // this is 100% wrong, i'm pretty sure
          text: formData.fields[0].value,
          userLocation: UserLocation(
            latitude: double.parse(formData.fields[1].value),
            longitude: double.parse(formData.fields[2].value),
          ),
        ),
      );
    } catch (e, st) {
      state = AsyncError(e, st);
    }
    log('UserDataNotifier state: $state');
  }
}
