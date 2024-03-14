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
  late final AppLifecycleListener listener;

  Future<void> getCameraPermission() async {
    await ref.read(cameraPermissionNotifierProvider.notifier).grantCameraAccess();
  }

  @override
  void initState() {
    super.initState();
    // i could also add a condition here
    // TODO make this ask for permission under condition
    Future.microtask(() async {
      // final permission = await Permission.camera.status;
      // log('1');
      // if (permission == PermissionStatus.denied ||
      //     permission == PermissionStatus.permanentlyDenied) {
      //   // final result = await Permission.camera.request();
      //   await Permission.camera.request();
      //   log('2');
      //   // if (result == PermissionStatus.granted) {
      //   //   await ref.read(cameraPermissionNotifierProvider.notifier).grantCameraAccess();
      //   //   log('3');
      //   // }
      // }
      // await Permission.camera.request();
    });
    listener = AppLifecycleListener(
      onResume: () async {
        final permission = await Permission.camera.status;
        // log('permission: $permission');
        // this is wrong
        // UPD it's not
        // if (permission == PermissionStatus.permanentlyDenied ||
        //     permission == PermissionStatus.denied) {
        // if (permission == PermissionStatus.permanentlyDenied) {
        if (permission == PermissionStatus.denied) {
          // this is or
          // permission == PermissionStatus.permanentlyDenied) {
          // if (permission == PermissionStatus.granted) {
          final result = await Permission.camera.request();
          // log('don`t you tell me this shit is here too');
          if (result == PermissionStatus.granted) {
            await ref.read(cameraPermissionNotifierProvider.notifier).grantCameraAccess();
            // log('shouldn`t this get called?');
          }
        } else if (permission == PermissionStatus.granted) {
          await ref.read(cameraPermissionNotifierProvider.notifier).grantCameraAccess();
          // log('or this?');
        }
        // log('onResume');
      },
    );
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
