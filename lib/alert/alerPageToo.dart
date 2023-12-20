import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:camera/camera.dart';
import 'package:crop/crop.dart';
import 'package:flutter/material.dart';

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

  bool disableCapture = false;

  Map<String, Uint8List> images = {
    'first': Uint8List(0),
    'second': Uint8List(0)
  };

  final CropController controller = CropController(aspectRatio: 1);

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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Text("Take two pictures\nto verify the incident"),
                        ),
                        Row(
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
                                                color: Colors.teal, width: 2)),
                                        child: images['first']!.isEmpty
                                            ? const Center(
                                          child: Icon(
                                            Icons.car_crash_sharp,
                                          ),
                                        )
                                            : Image.memory(images['first']!, fit: BoxFit.cover,)),
                                  ),
                                ),
                                Positioned(
                                    right: 0,
                                    child: images['first']!.isEmpty
                                        ? Container()
                                        : Container(
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                            BorderRadius.circular(40)),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              images['first'] = Uint8List(0);
                                            });
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.all(2.0),
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 15,
                                            ),
                                          ),
                                        )))
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
                                                color: Colors.teal, width: 2)),
                                        child: images['second']!.isEmpty
                                            ? const Center(
                                          child: Icon(
                                            Icons.car_crash_sharp,
                                          ),
                                        )
                                            : Image.memory(images['second']!, fit: BoxFit.cover,)),
                                  ),
                                ),
                                Positioned(
                                    right: 0,
                                    child: images['second']!.isEmpty
                                        ? Container()
                                        : Container(
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                            BorderRadius.circular(40)),
                                        child: GestureDetector(
                                          onTap: () {
                                            print("clearing second");
                                            setState(() {
                                              images['second'] = Uint8List(0);
                                            });
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.all(2.0),
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 15,
                                            ),
                                          ),
                                        )))
                              ],
                            ),
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
                                aspectRatio: 0.7,
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
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              disableCapture = true;
                            });

                            XFile cameraImage =
                                await cameraController.takePicture();

                            Uint8List image =
                                File(cameraImage.path).readAsBytesSync();

                            setState(() {
                              disableCapture = false;
                            });

                            if (images['first']!.isEmpty) {
                              setState(() {
                                images['first'] = image;
                              });
                              return;
                            }

                            if (images['second']!.isEmpty) {
                              setState(() {
                                images['second'] = image;
                              });
                              return;
                            }

                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                  "You can only upload two images. Delete another image to take a new one."),
                            ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.teal,
                                borderRadius: BorderRadius.circular(38)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: (images['first']!.isNotEmpty && images['second']!.isNotEmpty)
                              ? GestureDetector(
                                onTap: (){

                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Text("Next", style: TextStyle(color: Colors.white, fontSize: 20),),
                                ),
                              )
                              :disableCapture
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Icon(
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
