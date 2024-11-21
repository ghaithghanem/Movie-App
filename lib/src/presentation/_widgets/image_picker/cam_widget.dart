import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../../../config/router/app_router.gr.dart';

class CameraApp extends StatefulWidget {
  /// Default Constructor
  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => CameraAppState();
}

class CameraAppState extends State<CameraApp> {
  CameraController? controller;
  late Future<void> cameraValue;
  bool isRecoring = false;
  bool flash = false;
  bool iscamerafront = true;
  double transform = 0;
  @override
  void initState() {
    super.initState();

    if (cameras.isNotEmpty) {
      controller = CameraController(cameras[0], ResolutionPreset.max);
      controller?.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      }).catchError((Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              // Handle access errors here.
              debugPrint('Camera access was denied.');
              break;
            default:
              // Handle other errors here.
              debugPrint('Camera error: ${e.description}');
              break;
          }
        }
      });
    } else {
      debugPrint('No cameras are available.');
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: CameraPreview(controller!)),
          Positioned(
            bottom: 0.0,
            child: Container(
              color: Colors.black,
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          icon: Icon(
                            flash ? Icons.flash_on : Icons.flash_off,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () {
                            setState(() {
                              flash = !flash;
                            });
                            flash
                                ? controller?.setFlashMode(FlashMode.torch)
                                : controller?.setFlashMode(FlashMode.off);
                          }),
                      GestureDetector(
                        onLongPress: () async {
                          await controller?.startVideoRecording();
                          setState(() {
                            isRecoring = true;
                          });
                        },
                        onLongPressUp: () async {
                          XFile? videopath =
                              await controller?.stopVideoRecording();
                          setState(() {
                            isRecoring = false;
                          });
                          context.router.push(
                            VideoRoutePage(path: videopath!.path),
                          );
                        },
                        onTap: () {
                          if (!isRecoring) takePhoto(context);
                        },
                        child: isRecoring
                            ? const Icon(
                                Icons.radio_button_on,
                                color: Colors.red,
                                size: 80,
                              )
                            : const Icon(
                                Icons.panorama_fish_eye,
                                color: Colors.white,
                                size: 70,
                              ),
                      ),
                      IconButton(
                          icon: Transform.rotate(
                            angle: transform,
                            child: const Icon(
                              Icons.flip_camera_ios,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              iscamerafront = !iscamerafront;
                              transform = transform + pi;
                            });
                            int cameraPos = iscamerafront ? 0 : 1;
                            controller = CameraController(
                                cameras[cameraPos], ResolutionPreset.high);
                            cameraValue = controller!.initialize();
                          }),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Text(
                    "Hold for Video, tap for photo",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void takePhoto(BuildContext context) async {
    XFile? file = await controller?.takePicture();
    context.router.push(
      CameraRoutePage(path: file!.path),
    );
  }
}
