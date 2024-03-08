import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
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
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 30),
                //   child: Align(
                //     alignment: Alignment.bottomCenter,
                //     child: const CircleAvatar(
                //       radius: 30.0,
                //       backgroundColor: Colors.red,
                //     ),
                //   ),
                // ),
                // this'll be on top, creating the ripple effect
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 30),
                //   child: Align(
                //     alignment: Alignment.bottomCenter,
                //     child: Material(
                //       color: Colors.transparent,
                //       // color: Theme.of(context).cardColor,
                //       // color: Colors.blue,
                //       // borderRadius: BorderRadius.circular(40),
                //       child: InkWell(
                //         onTap: () {},
                //         splashColor: Colors.grey,
                //         // borderRadius: BorderRadius.circular(40),
                //         child: Ink(
                //           width: 100,
                //           height: 100,
                //           // color: Colors.yellow,
                //           child: const CircleAvatar(
                //             radius: 30.0,
                //             backgroundColor: Colors.transparent,
                //             // backgroundColor: Colors.red,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // this works
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Material(
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      // color: Colors.transparent,
                      color: Theme.of(context).cardColor,
                      // color: Colors.blue,
                      // borderRadius: BorderRadius.circular(40),
                      child: InkWell(
                        onTap: () {},
                        splashColor: Colors.red,
                        // borderRadius: BorderRadius.circular(40),
                        // child: Container(
                        //   width: 70,
                        //   height: 70,
                        //   // color: Colors.white,
                        // ),
                        // this is just to use circle
                        child: const CircleAvatar(
                          radius: 33,
                          backgroundColor: Colors.transparent,
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
