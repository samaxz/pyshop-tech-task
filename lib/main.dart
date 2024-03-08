import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

List<CameraDescription> _cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera app tech task',
      debugShowCheckedModeBanner: false,
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

  @override
  void initState() {
    super.initState();
    controller = CameraController(
      _cameras[0],
      ResolutionPreset.max,
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
      body: !controller.value.isInitialized
          ? Container()
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
                // TODO remove this
                // this isn't fully functional
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 30),
                //   child: Align(
                //     alignment: Alignment.bottomCenter,
                //     child: Material(
                //       shape: const CircleBorder(),
                //       // this is for the splash to not go behind
                //       // the child circle avatar
                //       clipBehavior: Clip.antiAlias,
                //       child: InkWell(
                //         onTap: () {},
                //         onLongPress: () {},
                //         splashColor: Colors.grey,
                //         child: const CircleAvatar(
                //           radius: 33,
                //           backgroundColor: Colors.transparent,
                //           child: CircleAvatar(
                //             radius: 28,
                //             backgroundColor: Colors.black,
                //             child: CircleAvatar(
                //               radius: 26.5,
                //               backgroundColor: Colors.white,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Material(
                      shape: const CircleBorder(),
                      // this is for the splash to not go behind
                      // the child circle avatar
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () {},
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
    );
  }
}
