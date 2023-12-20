import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:qlert/home/scanner.dart';

import '../main.dart';

class Alerting extends StatefulWidget {
  const Alerting({super.key});

  @override
  State<Alerting> createState() => _AlertingState();
}

class _AlertingState extends State<Alerting>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  bool isCameraMode = true;
  bool isCameraInitialized = false;

  late CameraController cameraController;

  Map<String, Uint8List> images = {'first':Uint8List(0), 'second':Uint8List(0)};

  @override
  void initState() {
    super.initState();

    availableCameras().then((List<CameraDescription> cameras) {
      print("C");
      print(cameras);
      if (cameras.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("No cameras found"),
        ));
        return;
      }

      cameraController = CameraController(cameras[0], ResolutionPreset.max);

      cameraController.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          isCameraInitialized = true;
        });
      }).catchError((Object e) {
        print("error");
        print(e);
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
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1, end: 1.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.teal,
        title: const Text('Alerting the Authorities'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Center(
                child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              width: 75,
                              height: 75,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.teal,
                                          width: 2
                                      )
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.car_crash_sharp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(40)
                                ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Icon(Icons.close, color: Colors.white, size: 20,),
                                  )
                              ),
                            )
                          ],
                        ),
                        Stack(
                          children: [
                            SizedBox(
                              width: 75,
                              height: 75,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.teal,
                                          width: 2
                                      )
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.car_crash_sharp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(40)
                                ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Icon(Icons.close, color: Colors.white, size: 20,),
                                  )
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Hero(
                    tag: 'alert-add',
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: const Offset(5, 5),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: isCameraInitialized
                          ? Center(
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: OverflowBox(
                                    alignment: Alignment.center,
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: SizedBox(
                                        width: 1,
                                        height:
                                            cameraController.value.aspectRatio,
                                        child: CameraPreview(cameraController),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const Center(
                              child: CircularProgressIndicator(
                                color: Colors.teal,
                              ),
                            ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: (){
                            cameraController.takePicture();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(38)
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.camera,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
