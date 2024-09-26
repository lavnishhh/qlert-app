import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qlert/home/Image_preview.dart';

class Profile extends StatefulWidget {
  final String uid;
  final bool confidential;

  const Profile({super.key, required this.uid, required this.confidential});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // Map<String, dynamic> data = {
  //   'email': 'Not Found',
  //   'name': "Not Found",
  //   'age': "Not Found",
  //   'gender': "Not Found",
  //   'bloodGroup': "Not Found",
  //   'height': "Not Found",
  //   'weight': "Not Found",
  //   'mobileNumber': "Not Found",
  //   'medicalHistory': "Not Found",
  //   'emergencyContact1': "Not Found",
  //   'emergencyContact2': "Not Found",
  //   'vehicleNumber': "Not Found",
  // };

  BoxShadow boxShadow = BoxShadow(
      offset: const Offset(0, 0),
      color: Colors.black.withOpacity(.2),
      spreadRadius: 1,
      blurRadius: 5);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.fromLTRB(0, 250, 0, 0),
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.teal,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text('No data available'),
            );
          } else {
            // Data successfully loaded, use it here
            if (!snapshot.data!.exists) {
              return Container(
                child: Text("Not found"),
              );
            }
            final data = snapshot.data!.data() as Map<String, dynamic>;
            // Example displaying user's name
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [boxShadow]),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ProfileImagePreview(data: data)));
                              },
                              child: Container(
                                  padding: const EdgeInsets.all(0.5),
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: Colors.teal,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Hero(
                                      tag: 'image-animation',
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Image.network(
                                            data['picture'],
                                            fit: BoxFit.fill,
                                          )))),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              data['name'],
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 30),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'uid:${widget.uid}',
                          style: TextStyle(
                              color: Colors.grey.shade700, fontSize: 14),
                        )
                      ],
                    ),
                  ),
                ),
                widget.confidential
                    ? Container()
                    : Container(
                        // padding: const EdgeInsets.symmetric(horizontal: 30),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(200))),
                        child: GridView.count(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          children: [
                            itemDashboard('Mobile', data['mobileNumber'],
                                Icons.call, Colors.deepOrange, 18),
                            itemDashboard('Email', data['email'],
                                Icons.email_rounded, Colors.green, 14),
                          ],
                        ),
                      ),
                Container(
                  // padding: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(200))),
                  child: GridView.count(
                    padding: const EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    children: [
                      itemDashboard('Age', data['age'] + ' years',
                          Icons.person_2_rounded, Colors.purple, 18),
                      itemDashboard('Gender', data['gender'],
                          Icons.male_rounded, Colors.brown, 18),
                      itemDashboard('Blood Group', data['bloodGroup'],
                          Icons.bloodtype, Colors.indigo, 18),
                      itemDashboard('Height', data['height'] + " cm",
                          Icons.height, Colors.teal, 18),
                      itemDashboard('Weight', data['weight'] + " kg",
                          Icons.scale_rounded, Colors.blue, 18),
                      itemDashboard('Vehicle No', data['vehicleNumber'],
                          Icons.car_crash_outlined, Colors.red, 18),
                    ],
                  ),
                ),
                widget.confidential
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [boxShadow]),
                          child: Column(
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.emergency,
                                    color: Colors.red,
                                    size: 30,
                                  )),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Emergency Contacts',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 30),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "+91 ${data['emergencyContact1']}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    "+91 ${data['emergencyContact2']}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 16),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [boxShadow]),
                    child: Column(
                      children: [
                        Container(
                            padding: const EdgeInsets.all(10),
                            child: const Icon(
                              Icons.medical_information,
                              color: Colors.green,
                              size: 30,
                            )),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Medical Info',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 30),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          data['medicalHistory'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.grey.shade700, fontSize: 14),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20)
              ],
            );
          }
        },
      ),
    );
  }

  itemDashboard(String title, String data, IconData iconData, Color background,
          double size) =>
      Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [boxShadow]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  iconData,
                  color: background,
                  size: 30,
                )),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(color: Colors.black, fontSize: 22),
            ),
            const SizedBox(height: 4),
            Text(
              data,
              style: TextStyle(color: Colors.grey.shade700, fontSize: size),
            )
          ],
        ),
      );
}
