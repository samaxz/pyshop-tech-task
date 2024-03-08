import 'package:camera/camera.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
Future<CameraController> cameraController(
  CameraControllerRef ref,
) async {
  late List<CameraDescription> cameras = [];
  cameras = await availableCameras();
  late final CameraController controller;
  controller = CameraController(
    cameras[0],
    ResolutionPreset.max,
  );
  // controller.initialize().then((_) {
  //   // this should probably be fixed
  //   // if (!mounted) return;
  //   // setState(() {});
  // }).catchError((Object e) {
  //   if (e is CameraException) {
  //     switch (e.code) {
  //       case 'CameraAccessDenied':
  //         // Handle access errors here.
  //         break;
  //       default:
  //         // Handle other errors here.
  //         break;
  //     }
  //   }
  // });
  // await controller.initialize();
  // return controller;
  // TODO probably handle error case here too
  return controller..initialize();
}
