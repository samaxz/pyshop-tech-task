import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'camera_permission_notifier.g.dart';

@riverpod
class CameraPermissionNotifier extends _$CameraPermissionNotifier {
  @override
  AsyncValue<CameraController> build() {
    ref.onAddListener(() => grantCameraAccess());
    return const AsyncLoading();
  }

  Future<List<CameraDescription>> _getAvailableCameras() async {
    try {
      final cameras = await availableCameras();
      return cameras;
    } on CameraException catch (e, st) {
      log(
        'CameraException inside _getAvailableCameras()',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  Future<void> grantCameraAccess() async {
    final permission = await Permission.camera.status;
    if (permission == PermissionStatus.denied || permission == PermissionStatus.permanentlyDenied) {
      state = AsyncError(
        'camera access has been denied',
        StackTrace.current,
      );
    } else {
      final cameras = await _getAvailableCameras();
      final controller = CameraController(
        cameras[0],
        ResolutionPreset.max,
        enableAudio: false,
      );
      try {
        // without this, the controller doesn't initialize
        await controller.initialize();
        state = AsyncData(controller);
      } on CameraException catch (e, st) {
        log(
          'CameraException inside grantCameraAccess()',
          error: e,
          stackTrace: st,
        );
        state = AsyncError(e, st);
      }
    }
  }

  // in case permission was permanently denied
  Future<void> tryAgain() async {
    // this is used so that the user won't open settings while the
    // status is changing
    final status = await Permission.camera.status;
    if (status == PermissionStatus.granted) return;
    await openAppSettings();
  }
}
