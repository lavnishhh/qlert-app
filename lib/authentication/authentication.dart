import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

enum AuthenticationState {authenticated, alreadyExists, doesNotExist, error}
enum SignInState {signedIn, notSignedIn, loading, error}

class FirebaseBackend {
  static final FirebaseBackend _instance = FirebaseBackend._internal();

  factory FirebaseBackend() {
    return _instance;
  }

  FirebaseBackend._internal();

  Future<AuthenticationState> signUp(String email, String password) async {

    try{

      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      print(userCredential);

      if (user != null) {

        print("user");
        print(user.uid);

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
            {
              'email':email,
              'password':password,
              'accountCompleted':false,
            }
        );

        return AuthenticationState.authenticated;

      }

      return AuthenticationState.doesNotExist;
    }
    on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('Email already in use. Please use a different email.');
      }
      print('Error creating user: ${e.message}');
      return AuthenticationState.alreadyExists;
    }
    catch(e, st){
      print("Error authenticating");
      print(e);
      print(st);
      return AuthenticationState.error;
    }
  }

  Future<SignInState> checkUserSignIn() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // User is already signed in, navigate to the main screen or perform any action
      print('User is signed in: ${user.uid}');
      return SignInState.signedIn;
    } else {
      // User is not signed in
      print('No user signed in');
      return SignInState.notSignedIn;
    }
  }

  updateDataForUser(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update(data);
  }

  Future<SignInState> signOut() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      User? user = auth.currentUser;
      if (user == null) {
        return SignInState.notSignedIn; // User is already signed out
      } else {
        await auth.signOut();
        return SignInState.notSignedIn; // User signed out successfully
      }
    } catch (e) {
      print('Error checking sign out status: $e');
      return SignInState.error; // Failed to sign out or error occurred
    }
  }

  Future<String?> uploadImageToFirebaseStorage(File imageFile,String path) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child(path);

      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);

      String imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      return null;
    }
  }

}