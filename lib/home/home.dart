import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:qlert/home/camera.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        CameraApp()
      ],
    );
  }
}
