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
