import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

List<CameraDescription> _cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _cameras = await availableCameras();
  runApp(const MyApp());
}

// void main() {
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  late CameraController controller;

  // @override
  // void initState() {
  //   super.initState();
  //   // Future.microtask(() async {
  //   //   // seems like this can't be initialized
  //   //   _cameras = await availableCameras();
  //   //   controller = CameraController(
  //   //     _cameras[0],
  //   //     // _cameras[1],
  //   //     ResolutionPreset.medium,
  //   //     // imageFormatGroup: ImageFormatGroup.yuv420,
  //   //   );
  //   //   try {
  //   //     await controller?.initialize();
  //   //   } catch (e) {
  //   //     if (e is CameraException) {
  //   //       switch (e.code) {
  //   //         case 'CameraAccessDenied':
  //   //           // Handle access errors here.
  //   //           break;
  //   //         default:
  //   //           // Handle other errors here.
  //   //           break;
  //   //       }
  //   //     }
  //   //   }
  //   // });
  //   controller = CameraController(
  //     _cameras[0],
  //     // _cameras[1],
  //     ResolutionPreset.medium,
  //     // imageFormatGroup: ImageFormatGroup.yuv420,
  //   );
  //   try {
  //     controller?.initialize();
  //   } catch (e) {
  //     if (e is CameraException) {
  //       switch (e.code) {
  //         case 'CameraAccessDenied':
  //           // Handle access errors here.
  //           break;
  //         default:
  //           // Handle other errors here.
  //           break;
  //       }
  //     }
  //   }
  // }

  // Future<void> initCamera() async {
  //   // _cameras = await availableCameras();
  //   controller = CameraController(
  //     _cameras[0],
  //     ResolutionPreset.medium,
  //     // imageFormatGroup: ImageFormatGroup.yuv420,
  //   );
  //   await controller.initialize();
  //   // if (!mounted) return;
  //   // setState(() {});
  // }

  @override
  void initState() {
    super.initState();
    // controller = CameraController(
    //   _cameras[0],
    //   ResolutionPreset.medium,
    //   imageFormatGroup: ImageFormatGroup.yuv420,
    // )..initialize();
    // Future.microtask(initCamera);
    controller = CameraController(
      _cameras[0],
      ResolutionPreset.medium,
    );
    controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

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
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('title'),
      ),
      body: !controller.value.isInitialized
          ? Container()
          : AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: CameraPreview(controller),
            ),
      // body: controller == null ? Container() : CameraPreview(controller!),
      // body: CameraPreview(controller!),
      // body: FutureBuilder(
      //   future: initCamera(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     } else if (snapshot.hasError) {
      //       return const Center(
      //         child: Text('error happened'),
      //       );
      //     }
      //     return CameraPreview(controller);
      //   },
      // ),
      // body: Container(),
    );
    // return CameraPreview(controller);
  }
}
