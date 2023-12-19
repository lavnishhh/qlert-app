// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:firebase_core/firebase_core.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   File? _imageFile;
//
//   Future<void> _uploadImage() async {
//     if (_imageFile == null) {
//       print("No image selected");
//       return;
//     }
//
//     try {
//       // Create a unique filename for the image using the current timestamp
//       String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//       firebase_storage.Reference storageReference = firebase_storage
//           .FirebaseStorage.instance
//           .ref()
//           .child('images/$fileName.jpg');
//
//       // Upload the image
//       await storageReference.putFile(_imageFile!);
//
//       // Get the download URL
//       String downloadURL = await storageReference.getDownloadURL();
//
//       print("Image uploaded. Download URL: $downloadURL");
//     } catch (e) {
//       print("Error uploading image: $e");
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _loadImageFromAssets();
//   }
//
//   Future<void> _loadImageFromAssets() async {
//     final ByteData data = await rootBundle.load('assets/your_image.jpg');
//     final List<int> bytes = data.buffer.asUint8List();
//
//     setState(() {
//       _imageFile = File.fromRawPath(bytes);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Firebase Image Upload'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (_imageFile != null) Image.file(_imageFile!),
//             ElevatedButton(
//               onPressed: _uploadImage,
//               child: Text('Upload Image'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
