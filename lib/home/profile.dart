import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qlert/alert/profile_details.dart';
import 'package:qlert/authentication/authentication.dart';
import 'package:qlert/home/qrCode.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // Expanded(
            //   child: GestureDetector(
            //     child: Container(
            //       padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
            //       decoration: BoxDecoration(
            //           color: Colors.teal,
            //           borderRadius: BorderRadius.circular(20)),
            //       child: const Row(
            //         mainAxisAlignment: MainAxisAlignment.start,
            //         children: [
            //           Icon(
            //             Icons.groups,
            //             color: Colors.white,
            //             size: 30,
            //           ),
            //           Expanded(
            //             child: Center(
            //               child: Text(
            //                 'Add Member',
            //                 style: TextStyle(color: Colors.white),
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            // const SizedBox(
            //   width: 10,
            // ),
            // Expanded(
            //   child: GestureDetector(
            //     child: Container(
            //       padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
            //       decoration: BoxDecoration(
            //           color: Colors.teal,
            //           borderRadius: BorderRadius.circular(20)),
            //       child: const Row(
            //         mainAxisAlignment: MainAxisAlignment.start,
            //         children: [
            //           Icon(
            //             Icons.car_crash_sharp,
            //             color: Colors.white,
            //             size: 30,
            //           ),
            //           Expanded(
            //             child: Center(
            //               child: Text(
            //                 'Add Vehicle',
            //                 style: TextStyle(color: Colors.white),
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QRCodePage(
                    uid: FirebaseAuth.instance.currentUser!.uid,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
              decoration: BoxDecoration(
                  color: Colors.teal, borderRadius: BorderRadius.circular(20)),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.qr_code_2,
                    color: Colors.white,
                    size: 30,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Center(
                    child: Text(
                      'Generate QR code',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Profile(
          uid: FirebaseAuth.instance.currentUser!.uid,
          confidential: false,
        ),
        GestureDetector(
          onTap: () async {
            FirebaseBackend().signOut();
          },
          child: Container(
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
            decoration: BoxDecoration(
                color: Colors.teal, borderRadius: BorderRadius.circular(20)),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      'Sign Out',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                  size: 30,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
