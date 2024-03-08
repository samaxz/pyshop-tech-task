import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pyshop_task_camera_app/logic/controllers/providers.dart';
import 'package:pyshop_task_camera_app/ui/widgets/photo_button.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // TODO make use of this or delete it
  // UPD commented this out for now
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   final CameraController? cameraController = controller;
  //
  //   // App state changed before we got the chance to initialize.
  //   if (cameraController == null || !cameraController.value.isInitialized) {
  //     return;
  //   }
  //
  //   if (state == AppLifecycleState.inactive) {
  //     cameraController.dispose();
  //   } else if (state == AppLifecycleState.resumed) {
  //     // _initializeCameraController(cameraController.description);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(cameraControllerProvider);
    return controller.when(
      data: (controller) => Scaffold(
        body: !controller.value.isInitialized
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    // wrapping expanded inside column, so that it
                    // doesn't write anything to the console
                    child: Column(
                      children: [
                        // this works, while fitted box throws
                        Expanded(
                          child: CameraPreview(controller),
                        ),
                      ],
                    ),
                  ),
                  const PhotoButton(),
                ],
              ),
      ),
      error: (error, stackTrace) => const Center(
        child: Text('error'),
      ),
      // this is pretty much useless
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
