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
  // TODO probably handle error case here too
  return controller..initialize();
}
