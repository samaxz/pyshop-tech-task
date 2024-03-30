import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pyshop_task_camera_app/logic/controllers/camera_permission_notifier.dart';
import 'package:pyshop_task_camera_app/ui/widgets/comment_section.dart';
import 'package:pyshop_task_camera_app/ui/widgets/send_button.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late final AppLifecycleListener listener;

  @override
  void initState() {
    super.initState();
    // TODO make this ask for permission under a certain condition
    Future.microtask(() async {
      final permission = await Permission.camera.status;
      if (permission == PermissionStatus.denied) {
        final result = await Permission.camera.request();
        if (result == PermissionStatus.granted) {
          await ref.read(cameraPermissionNotifierProvider.notifier).grantCameraAccess();
        }
      }
    });

    listener = AppLifecycleListener(
      onResume: () async {
        final permission = await Permission.camera.status;
        if (permission == PermissionStatus.denied) {
          final result = await Permission.camera.request();
          if (result == PermissionStatus.granted) {
            await ref.read(cameraPermissionNotifierProvider.notifier).grantCameraAccess();
          }
        } else if (permission == PermissionStatus.granted) {
          await ref.read(cameraPermissionNotifierProvider.notifier).grantCameraAccess();
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
            : Stack(
                children: [
                  // wrapping expanded inside column, so that it
                  // doesn't write anything to the console
                  Column(
                    children: [
                      // this works, while fitted box throws
                      Expanded(
                        child: CameraPreview(controller),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: const Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        // i somehow need to decide the height here
                        height: 100,
                        child: IntrinsicHeight(
                          child: Row(
                            // i could also wrap each child in padding, instead
                            // of using flex or expanded in the first place
                            children: [
                              SizedBox(width: 15),
                              Flexible(
                                flex: 10,
                                child: CommentSection(),
                              ),
                              SizedBox(width: 15),
                              Flexible(
                                flex: 2,
                                child: SendButton(),
                              ),
                              SizedBox(width: 15),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
