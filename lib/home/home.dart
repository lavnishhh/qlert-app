import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qlert/features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:qlert/home/scanner.dart';
import 'package:qlert/home/profile.dart';
import '../authentication/authentication.dart';
import '../features/user_auth/presentation/pages/login_page.dart';
import 'package:qlert/home/vehicleSearch.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SignInState isUserSignedIn = SignInState.loading;
  Widget sheetWidget = Container();
  double maxHeight = 0.5;

  @override
  void initState() {
    super.initState();

    maxHeight = 0.5;
    sheetWidget = const SignInPrompts();

    FirebaseBackend().checkUserSignIn().then((value) {
      setState(() {
        isUserSignedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isUserSignedIn == SignInState.loading) {
      sheetWidget = const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user != null) {
          if (sheetWidget is UserProfilePage) {
            return;
          }
          setState(() {
            maxHeight = 1;
            sheetWidget = const UserProfilePage();
          });
          return;
        }
        if (sheetWidget is! SignInPrompts) {
          setState(() {
            maxHeight = 0.5;
            sheetWidget = const SignInPrompts();
          });
        }
      });
    }
    // else if (isUserSignedIn == SignInState.notSignedIn) {
    //   sheetWidget = const SignInPrompts();
    // } else if (isUserSignedIn == SignInState.signedIn) {
    //   maxHeight = 1;
    //   sheetWidget = const UserProfilePage();
    // }

    return Scaffold(
      body: Stack(
        children: [
          // Your existing CameraApp or other widgets
          const ScannerCameraApp(),
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            maxChildSize: maxHeight,
            snap: true,
            snapSizes: const [0.3],
            builder: (BuildContext context, ScrollController scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          width: 50,
                          height: 4,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      VehicleSearch(),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Center(
                          child: sheetWidget,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SignInPrompts extends StatefulWidget {
  const SignInPrompts({super.key});

  @override
  State<SignInPrompts> createState() => _SignInPromptsState();
}

class _SignInPromptsState extends State<SignInPrompts> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    double maxHeight = 0.3 * height;

    return SizedBox(
      height: maxHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.teal, borderRadius: BorderRadius.circular(50)),
              child: const Center(
                child: Text(
                  "Login",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignUpPage(),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.teal, borderRadius: BorderRadius.circular(50)),
              child: const Center(
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
