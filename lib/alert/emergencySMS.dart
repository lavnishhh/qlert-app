
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qlert/authentication/authentication.dart';
import 'package:telephony/telephony.dart';

class EmergencySMSSender {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random rnd = Random();


  Future<Map<String, dynamic>> createReport(Map<String, Uint8List?> images, GeoPoint? location, String id) async {
    try {
      DocumentSnapshot<Map<String, dynamic>>? userSnapshot =
      await _firestore.collection('users').doc(id).get();

      print("s");

      if (userSnapshot.exists) {

        print("m");

        final Map<String, dynamic> userData = userSnapshot.data()!;
        final String? emergencyContact1 = userData['emergencyContact1'] as String?;
        final String? emergencyContact2 = userData['emergencyContact2'] as String?;

        if (emergencyContact1 == null || emergencyContact2 == null) {
          return {'contacts':[], 'id':''};
        }

        Map<String, dynamic> data = {
          'images': [
            'https://via.placeholder.com/200',
            'https://via.placeholder.com/200'
          ],
          'location': location,
          'time': Timestamp.now(),
          'victim': FirebaseAuth.instance.currentUser?.uid,
        };

        DocumentReference documentReference = await FirebaseFirestore.instance.collection('reports').doc(getRandomString(10));
            documentReference.set(data);

        if (images['first'] != null && images['second'] != null) {

          print("uploading");

          // Access results of completed uploads
          String? imageOne = await FirebaseBackend().uploadImageToFirebaseStorage(File.fromRawPath(images['first']!), 'reports/${documentReference.id}/image_one');
          String? imageTwo = await FirebaseBackend().uploadImageToFirebaseStorage(File.fromRawPath(images['second']!), 'reports/${documentReference.id}/image_two');

          print("uploaded");

          await documentReference.update({
            'images': [imageOne, imageTwo]
          });

          print("updated");
        }

        return {'contacts':[emergencyContact1, emergencyContact2], 'id':documentReference.id};
      }
    } catch (e) {
      print('Error sending emergency SMS: $e');
    }
    return {'contacts':[], 'id':''};
  }

  Future<void> sendEmergencySMS(String message, List<String> recipients, String id) async {

    for (var address in recipients) {
      final Telephony telephony = Telephony.instance;
      telephony.sendSms(
          to: address,
          message: "Your family member has been in an accident. Check below for further updates- https://q-lert.github.io/reports/?report=$id"
      );
    }
  }

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(

      length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
}
