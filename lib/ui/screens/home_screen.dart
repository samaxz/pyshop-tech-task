import 'dart:developer';

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
  // void didChangeAppLifecycleState(AppLifecycleState state) async {
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
  //   if (state == AppLifecycleState.resumed) {
  //     final permission = await Permission.camera.status;
  //     if (permission != PermissionStatus.granted) {
  //       log('huyna');
  //     }
  //     // if (granted) {
  //     //   //do whatever you want
  //     // }
  //   }
  // }

  late final AppLifecycleListener listener;

  Future<void> getCameraPermission() async {
    await ref.read(cameraPermissionNotifierProvider.notifier).grantCameraAccess();
  }

  @override
  void initState() {
    super.initState();
    listener = AppLifecycleListener(
      onResume: () async {
        final permission = await Permission.camera.status;
        // this is the only right way, since if the case is permanently denied, then
        // the only solution would be to open app settings
        // otherwise, all the other non-granted cases will suffice
        // although, i could also select specific cases, it's just that i'm too lazy
        // to actually do that
        // if (permission != PermissionStatus.granted) {
        // this works well
        if (permission == PermissionStatus.permanentlyDenied) {
          final result = await Permission.camera.request();
          if (result == PermissionStatus.granted) return;
          // final permission = await Permission.camera.request();
          // if (permission == PermissionStatus.denied)
          // if (permission == PermissionStatus.denied) {
          // permission == PermissionStatus.permanentlyDenied) {
          // this gets called infinitely
          // await ref.read(cameraPermissionNotifierProvider.notifier).grantCameraAccess();
          // log('onResume');
        }
      },
      // TODO remove this
      // this gets called far too often
      // onStateChange: (state) async {
      //   // log('state: $state');
      //   if (state == AppLifecycleState.resumed) {
      //     // final permission = await Permission.camera.request();
      //     // if (permission != PermissionStatus.granted) {
      //     //   // log('should this get called?');
      //     //   await ref.read(cameraPermissionNotifierProvider.notifier).grantCameraAccess();
      //     // }
      //     // getCameraPermission();
      //     final permission = await Permission.camera.status;
      //     // if (permission != PermissionStatus.granted) {
      //     if (permission != PermissionStatus.granted) {
      //       // log('huyna');
      //       await ref.read(cameraPermissionNotifierProvider.notifier).grantCameraAccess();
      //     }
      //   }
      // },
    );
    // Future.microtask(getCameraPermission);
  }

  @override
  void dispose() {
    listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cameraPermission = ref.watch(cameraPermissionNotifierProvider);
    return cameraPermission.when(
      data: (controller) => Scaffold(
        resizeToAvoidBottomInset: false,
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
                      const CommentSection(),
                    ],
                  ),
                ),
              ),
      ),
      error: (error, stackTrace) => Center(
        child: ElevatedButton(
          onPressed: ref.read(cameraPermissionNotifierProvider.notifier).tryAgain,
          child: const Text('try again'),
        ),
      ),
      // this is pretty much useless
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
