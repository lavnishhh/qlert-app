import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qlert/alert/profile_details.dart';
import 'package:qlert/authentication/authentication.dart';
import 'package:qlert/features/user_auth/presentation/pages/login_page.dart';
import 'package:qlert/features/user_auth/presentation/widgets/form_container_widget.dart';

import '../../../global/common/toast.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _medicalHistoryController = TextEditingController();
  final TextEditingController _emergencyContact1Controller = TextEditingController();
  final TextEditingController _emergencyContact2Controller = TextEditingController();
  final TextEditingController _vehicleNumberController = TextEditingController();

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
        title: const Text("Sign up"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Sign up to Q-lert",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              const Text(
                "Account Data",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              buildTextField("Email", _emailController),
              buildTextField("Password", _passwordController, isPassword: true),
              const Text(
                "Personal Data",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              buildTextField("Name", _nameController),
              buildTextField("Mobile Number", _mobileController),
              const SizedBox(height: 20),
              const Text(
                "Medical Data",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              buildTextField("Age", _ageController),
              buildTextField("Gender", _genderController),
              buildTextField("Blood Group", _bloodGroupController),
              buildTextField("Height (in cm)", _heightController),
              buildTextField("Weight (in kgs)", _weightController),
              buildTextField("Medical History", _medicalHistoryController),
              const SizedBox(height: 20),
              const Text(
                "Emergency Contacts Data",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              buildTextField(
                  "Emergency Contact 1", _emergencyContact1Controller),
              buildTextField(
                  "Emergency Contact 2", _emergencyContact2Controller),
              buildTextField("Vehicle Number", _vehicleNumberController),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {

                  RegExp emailRegExp = RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    caseSensitive: false,
                    multiLine: false,
                  );
                  if(!emailRegExp.hasMatch(_emailController.text)){
                    Fluttertoast.showToast(msg: "Please enter a valid email.");
                    return;
                  }


                  RegExp phoneRegex = RegExp(r'^[0-9]{10}$');
                  if(!phoneRegex.hasMatch(_mobileController.text)){
                    Fluttertoast.showToast(msg: "Please enter a valid phone number.");
                    return;
                  }

                  if(int.tryParse(_ageController.text)!=null){
                    Fluttertoast.showToast(msg: "Please enter a valid age.");
                    return;
                  }

                  _signUp();
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Center(
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
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                          (route) => false);
                    },
                    child: const Text("Log in",
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FormContainerWidget(
            controller: controller,
            isPasswordField: isPassword,
          ),
        ),
      ],
    );
  }

  void _signUp() async {
    try {
      String email = _emailController.text;
      String password = _passwordController.text;

      AuthenticationState authenticationState = await Authentication().signUp(email, password);

      switch(authenticationState){
        case AuthenticationState.alreadyExists:
          Fluttertoast.showToast(msg: "Account already exists. Please Log in instead.");
          return;
        case AuthenticationState.doesNotExist:
          Fluttertoast.showToast(msg: "Account has been banned/blocked. Please contact support.");
          return;
        case AuthenticationState.error:
          Fluttertoast.showToast(msg: "Error creating account. Please try again later.");
          return;
        case AuthenticationState.authenticated:
          // TODO: Handle this case.
      }

      await Authentication().updateDataForUser({
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
        MaterialPageRoute(builder: (context) => const Profile()),
        (route) => false,
      );
        } catch (e) {
      print("Error creating user: $e");
      showToast(message: "Error occurred: $e");
    }
  }
}
