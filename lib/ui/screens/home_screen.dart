import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pyshop_task_camera_app/logic/controllers/providers.dart';
import 'package:pyshop_task_camera_app/ui/widgets/comment_section.dart';

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

  // this needs to get called only in case access was either denied
  // for once or permanently
  Future<void> getCameraPermission() async {
    final status = await Permission.camera.request();
    if (status == PermissionStatus.denied ||
        status == PermissionStatus.permanentlyDenied) {
      await Permission.camera.request();
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(getCameraPermission);
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(cameraControllerProvider);
    return controller.when(
      data: (controller) => Scaffold(
        resizeToAvoidBottomInset: false,
        // resizeToAvoidBottomPadding: false,
        body: !controller.value.isInitialized
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height,
                  ),
                  child: Stack(
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
                      // TODO remove this
                      // const PhotoButton(),
                      const CommentSection(),
                    ],
                  ),
                ),
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
