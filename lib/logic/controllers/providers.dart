import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

// i should be checking permission here, before returning anything
// if the permission is granted, then return
// TODO remove this
// @riverpod
// Future<CameraController> cameraController(
//   CameraControllerRef ref,
// ) async {
//   // this isn't the best solution
//   // TODO remove this
//   // final permission = ref.watch(cameraPermissionProvider);
//   // return permission.when(
//   //   data: data,
//   //   error: error,
//   //   loading: loading,
//   // );
//   final permission = await Permission.camera.request();
//   if (permission == PermissionStatus.denied || permission == PermissionStatus.permanentlyDenied) {
//     // interesting, what should i return here?
//   }
//   List<CameraDescription> cameras = [];
//   cameras = await availableCameras();
//   late final CameraController controller;
//   controller = CameraController(
//     // i don't quite get it, but, it looks like on some devices 0 is front, while on
//     // others it's back camera
//     cameras[0],
//     ResolutionPreset.max,
//     enableAudio: false,
//   );
//   // TODO probably handle error case here too
//   return controller..initialize();
// }
//
// @riverpod
// Future<PermissionStatus> cameraPermission(
//   CameraPermissionRef ref,
// ) async {
//   final permission = await Permission.camera.request();
//   return permission;
//   // if permission is granted, then return controller
//   // otherwise, return something else
//   // final some = ref.watch(cameraControllerProvider);
//   // return some.when(
//   //   data: (controller) => ,
//   //   error: error,
//   //   loading: loading,
//   // );
// }

@riverpod
class CameraPermissionNotifier extends _$CameraPermissionNotifier {
  // i could either use my own class here or async value
  @override
  // CameraController? build() {
  AsyncValue<CameraController> build() {
    return const AsyncLoading();
  }

  Future<void> grantCameraAccess() async {
    // no idea if this should be here or not - but, for the time being, i'll leave it here
    // UPD commented this out
    // state = const AsyncLoading();
    final permission = await Permission.camera.request();
    if (permission == PermissionStatus.denied || permission == PermissionStatus.permanentlyDenied) {
      // interesting, what should i return here?
      state = AsyncError('camera access has been denied', StackTrace.current);
    } else {
      // List<CameraDescription> cameras = [];
      // cameras = await availableCameras();
      final cameras = await _getAvailableCameras();
      // late final CameraController controller;
      final controller = CameraController(
        // i don't quite get it, but, it looks like on some devices 0 is front, while on
        // others it's back camera
        cameras[0],
        ResolutionPreset.max,
        enableAudio: false,
        // i could also remove this
      )..initialize();
      // with this, the loading background is black (dk if it's good)
      // await controller.initialize();
      // i could also do controller..initialize()
      state = AsyncData(controller);
    }
  }

  Future<List<CameraDescription>> _getAvailableCameras() async {
    List<CameraDescription> cameras = [];
    cameras = await availableCameras();
    return cameras;
  }
}
