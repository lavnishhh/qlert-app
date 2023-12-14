import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 25, 30, 0),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 5),
                        color: Colors.black.withOpacity(.2),
                        spreadRadius: 2,
                        blurRadius: 10)
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.account_circle,
                        color: Colors.white,
                        size: 40,
                      )),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Batman',
                        style: TextStyle(color: Colors.black, fontSize: 30),
                      ),
                      Text(
                        'uid:98562387236',
                        style: TextStyle(
                            color: Colors.grey.shade700, fontSize: 14),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(200))),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 20,
                children: [
                  itemDashboard(
                      'Mobile', '994567879', Icons.call, Colors.deepOrange, 18),
                  itemDashboard('Email', 'dhonibaba@email.com',
                      Icons.email_rounded, Colors.green, 14),
                  itemDashboard(
                      'Age', '22', Icons.person_2_rounded, Colors.purple, 18),
                  itemDashboard(
                      'Gender', 'M', Icons.male_rounded, Colors.brown, 18),
                  itemDashboard('Blood group', 'O+ve', Icons.bloodtype,
                      Colors.indigo, 18),
                  itemDashboard('Height', "6'0", Icons.height, Colors.teal, 18),
                  itemDashboard(
                      'Weight', '69kg', Icons.scale_rounded, Colors.blue, 18),
                  itemDashboard('Vehicle No', 'KA 03 FF 1234',
                      Icons.car_crash_outlined, Colors.pinkAccent, 18),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 25, 30, 0),
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 5),
                        color: Colors.black.withOpacity(.2),
                        spreadRadius: 2,
                        blurRadius: 10)
                  ]),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.medical_information,
                          color: Colors.white,
                          size: 35,
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Medical history',
                      style: TextStyle(color: Colors.black, fontSize: 25),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                      style:
                          TextStyle(color: Colors.grey.shade700, fontSize: 14),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20)
        ],
      ),
    );
  }

  itemDashboard(String title, String data, IconData iconData, Color background,
          double size) =>
      Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 5),
                  color: Colors.black.withOpacity(.2),
                  spreadRadius: 2,
                  blurRadius: 10)
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: background,
                  shape: BoxShape.circle,
                ),
                child: Icon(iconData, color: Colors.white)),
            const SizedBox(height: 8),
            Text(
              title.toUpperCase(),
              style: TextStyle(color: Colors.black, fontSize: 20),
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
