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
    // grantCameraAccess();
    ref.onAddListener(() {
      // log('onAddListener()');
      grantCameraAccess();
    });
    // these don't work
    // ref.onResume(() {
    //   log('onResume()');
    // });
    // ref.onCancel(() {
    //   log('onCancel()');
    // });
    // ref.onRemoveListener(() {
    //   log('onRemoveListener()');
    // });
    return const AsyncLoading();
  }

  Future<List<CameraDescription>> _getAvailableCameras() async {
    final cameras = await availableCameras();
    return cameras;
  }

  Future<void> grantCameraAccess() async {
    final permission = await Permission.camera.status;
    // without either of these, the method throws and state is stuck on loading state
    // perhaps, i could add try/catch here
    // if (permission == PermissionStatus.denied || permission == PermissionStatus.permanentlyDenied) {
    if (permission != PermissionStatus.granted) {
      state = AsyncError('camera access has been denied', StackTrace.current);
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
    // UPD decided to add this here
    // state = const AsyncLoading();
    // *******
    // final permission = await Permission.camera.request();
    // if (permission != PermissionStatus.granted) {
    //   await openAppSettings();
    //   // await grantCameraAccess();
    // } else {
    //   await grantCameraAccess();
    // }
    // *****
    await openAppSettings();
    // *****
    // await openAppSettings().then((value) async {
    //   await grantCameraAccess();
    // });
    // Future.delayed(Duration(seconds: 1), () => grantCameraAccess());
    // await grantCameraAccess();
  }
}
