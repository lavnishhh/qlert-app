import 'package:flutter_sms/flutter_sms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class EmergencySMSSender {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendEmergencySMS() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await _firestore.collection('users').doc('userId').get();

      if (userSnapshot.exists) {
        final Map<String, dynamic> userData = userSnapshot.data()!;
        final String emergencyContact1 = userData['emergencyContact1'];
        final String emergencyContact2 = userData['emergencyContact2'];

        QuerySnapshot<Map<String, dynamic>> reportsSnapshot =
            await _firestore.collection('reports').get();

        if (reportsSnapshot.docs.isNotEmpty) {
          final List<String> reportLinks = [];
          final List<String> locationLinks = [];

          for (QueryDocumentSnapshot<Map<String, dynamic>> doc
              in reportsSnapshot.docs) {
            final List<dynamic> images = doc['images'];

            for (String image in images.cast<String>()) {
              reportLinks.add(image);
            }

            final GeoPoint? location = doc['location'];
            if (location != null) {
              final double latitude = location.latitude;
              final double longitude = location.longitude;

              final String googleMapsLink =
                  'https://www.google.com/maps?q=$latitude,$longitude';

              locationLinks.add(googleMapsLink);
            }
          }

          final String reportLinksMessage =
              'Here are the images: ${reportLinks.join(', ')}';
          final String locationLinkMessage =
              'Here is the exact location: ${locationLinks.isNotEmpty ? locationLinks.first : ''}';
          final String message =
              'Your loved one has been involved in an accident. You are receiving this message since you are an emergency contact.Here are the images and the location:\n$reportLinksMessage\n$locationLinkMessage';

          _sendSMS(message, [emergencyContact1, emergencyContact2]);
        }
      }
    } catch (e) {
      print('Error sending emergency SMS: $e');
    }
  }

  Future<void> _sendSMS(String message, List<String> recipients) async {
    try {
      await sendSMS(message: message, recipients: recipients);
      print('Emergency SMS sent successfully!');
    } catch (error) {
      print('Failed to send SMS: $error');
    }
  }
}
