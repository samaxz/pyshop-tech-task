import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
class CameraPermissionNotifier extends _$CameraPermissionNotifier {
  // i could also use my own class here instead
  @override
  AsyncValue<CameraController> build() {
    ref.onAddListener(() {
      grantCameraAccess();
      log('onAddListener()');
    });
    return const AsyncLoading();
  }

  Future<List<CameraDescription>> _getAvailableCameras() async {
    final cameras = await availableCameras();
    return cameras;
  }

  Future<void> grantCameraAccess() async {
    final permission = await Permission.camera.status;
    log('permission: $permission');
    // Permission.camera.onDeniedCallback(() => log('huyna'));
    // if (permission != PermissionStatus.granted) {
    if (permission == PermissionStatus.denied || permission == PermissionStatus.permanentlyDenied) {
      state = AsyncError('camera access has been denied', StackTrace.current);
      // if (permission == PermissionStatus.denied) {
      //   final permission = await Permission.camera.request();
      //   if (permission == PermissionStatus.permanentlyDenied) {
      //     state = AsyncError('camera access has been denied', StackTrace.current);
      //   }
    } else {
      final cameras = await _getAvailableCameras();
      final controller = CameraController(
        // i don't quite get it, but, it looks like on some devices 0 is front, while on
        // others it's back camera
        cameras[0],
        ResolutionPreset.max,
        enableAudio: false,
      );
      // without this, the controller doesn't initialize
      await controller.initialize();
      state = AsyncData(controller);
    }
    log('notifier state is: $state');
  }

  // in case permission was permanently denied
  Future<void> tryAgain() async {
    await openAppSettings();
    // update the permission status after opening settings
    // await Permission.camera.request();
    // Permission.camera.onDeniedCallback(() => log('user denied access'));
    // Permission.camera.request();
    // the only problem that i have here is that i need to call grantCameraAccess()
    // to update the state
    // await grantCameraAccess();
  }
}
