
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qlert/authentication/authentication.dart';
import 'package:telephony/telephony.dart';

class EmergencySMSSender {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> createReport(Map<String, Uint8List?> images, GeoPoint? location) async {
    try {
      DocumentSnapshot<Map<String, dynamic>>? userSnapshot =
      await _firestore.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).get();

      if (userSnapshot.exists ?? false) {
        final Map<String, dynamic> userData = userSnapshot.data()!;
        final String? emergencyContact1 = userData['emergencyContact1'] as String?;
        final String? emergencyContact2 = userData['emergencyContact2'] as String?;

        if (emergencyContact1 == null || emergencyContact2 == null) {
          return [];
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

        DocumentReference documentReference = await FirebaseFirestore.instance.collection('reports').add(data);

        if (images['first'] != null && images['second'] != null) {

          List<Future<String?>> uploadFutures = [
            FirebaseBackend().uploadImageToFirebaseStorage(File.fromRawPath(images['first']!), 'reports/${documentReference.id}/image_one'),
            FirebaseBackend().uploadImageToFirebaseStorage(File.fromRawPath(images['second']!), 'reports/${documentReference.id}/image_two'),
          ];

          List<String?> results = await Future.wait(uploadFutures);

          // Access results of completed uploads
          String? imageOne = results[0];
          String? imageTwo = results[1];

          await documentReference.update({
            'images': [imageOne, imageTwo]
          });
        }

        return [emergencyContact1, emergencyContact2];
      }
    } catch (e) {
      print('Error sending emergency SMS: $e');
    }
    return [];
  }

  Future<void> sendEmergencySMS(String message, List<String> recipients) async {

    for (var address in recipients) {
      final Telephony telephony = Telephony.instance;
      telephony.sendSms(
          to: address,
          message: "May the force be with you!"
      );
    }
  }
}
