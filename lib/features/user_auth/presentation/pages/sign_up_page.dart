import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:qlert/alert/profile_details.dart';
import 'package:qlert/features/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:qlert/features/user_auth/presentation/pages/login_page.dart';
import 'package:qlert/features/user_auth/presentation/widgets/form_container_widget.dart';

import '../../../global/common/toast.dart';
import 'home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _bloodGroupController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _medicalHistoryController = TextEditingController();
  TextEditingController _emergencyContact1Controller = TextEditingController();
  TextEditingController _emergencyContact2Controller = TextEditingController();
  TextEditingController _vehicleNumberController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _bloodGroupController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _mobileController.dispose();
    _medicalHistoryController.dispose();
    _emergencyContact1Controller.dispose();
    _emergencyContact2Controller.dispose();
    _vehicleNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign up"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                "Sign up to Q-lert",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              buildTextField("Name", _nameController),
              buildTextField("Email", _emailController),
              buildTextField("Password", _passwordController, isPassword: true),
              buildTextField("Age", _ageController),
              buildTextField("Gender", _genderController),
              buildTextField("Blood Group", _bloodGroupController),
              buildTextField("Height (in cm)", _heightController),
              buildTextField("Weight (in kgs)", _weightController),
              buildTextField("Mobile Number", _mobileController),
              buildTextField("Medical History", _medicalHistoryController),
              buildTextField(
                  "Emergency Contact 1", _emergencyContact1Controller),
              buildTextField(
                  "Emergency Contact 2", _emergencyContact2Controller),
              buildTextField("Vehicle Number", _vehicleNumberController),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  _signUp();
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?"),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (route) => false);
                    },
                    child: Text("Log in",
                        style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        )),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          filled: true,
          fillColor: Colors.teal.withOpacity(0.3),
        ),
      ),
    );
  }

  void _signUp() async {
    try {
      String email = _emailController.text;
      String password = _passwordController.text;

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'userId': user.uid, // Store the user ID for reference
          'name': _nameController.text,
          'age': _ageController.text,
          'gender': _genderController.text,
          'bloodGroup': _bloodGroupController.text,
          'height': _heightController.text,
          'weight': _weightController.text,
          'mobileNumber': _mobileController.text,
          'medicalHistory': _medicalHistoryController.text,
          'emergencyContact1': _emergencyContact1Controller.text,
          'emergencyContact2': _emergencyContact2Controller.text,
          'vehicleNumber': _vehicleNumberController.text,
          // Add more fields as needed
        });

        showToast(message: "User is successfully created");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Profile()),
          (route) => false,
        );
      } else {
        showToast(message: "User creation failed");
      }
    } catch (e) {
      print("Error creating user: $e");
      showToast(message: "Error occurred: $e");
    }
  }
}
