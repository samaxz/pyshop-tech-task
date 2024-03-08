import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pyshop_task_camera_app/logic/state_management/providers.dart';

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
                child: Text('Loading...'),
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
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                      bottom: 30,
                    ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Material(
                        shape: const CircleBorder(),
                        // this is for the splash to not go behind
                        // the child's constraints
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          // TODO implement onTap()
                          onTap: () {},
                          // TODO implement onLongPress()
                          onLongPress: () {},
                          splashColor: Colors.grey,
                          child: Container(
                            width: 76,
                            height: 76,
                            padding: const EdgeInsets.all(5),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
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
