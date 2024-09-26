import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:qlert/home/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:telephony/telephony.dart';
import 'firebase_options.dart';

List<CameraDescription> _cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  final Telephony telephony = Telephony.instance;
  bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
  if(!permissionsGranted!){
    exit(0);
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Inter'
        ),
        home: const HomeScreen());
  }
}
