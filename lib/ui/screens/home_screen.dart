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
    listener = AppLifecycleListener(
      onResume: () async {
        final permission = await Permission.camera.status;
        if (permission == PermissionStatus.permanentlyDenied) {
          final result = await Permission.camera.request();
          if (result == PermissionStatus.granted) {
            await ref.read(cameraPermissionNotifierProvider.notifier).grantCameraAccess();
          }
        }
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
