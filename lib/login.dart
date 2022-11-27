import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'firebase_options.dart';

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;

class LoginPage extends StatelessWidget {
  // const LoginPage({super.key, required List<FirebaseUIAction> actions});
  const LoginPage();

  @override
  Widget build(BuildContext context) {
    // signInWithGoogle();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 230.0),
            Column(
              children: <Widget>[
                // Image.asset('assets/diamond.png'),
                const SizedBox(height: 16.0),
                const Text('final..'),
              ],
            ),
            const SizedBox(height: 120.0),

            ElevatedButton(
              onPressed: () async {
                await signInWithGoogle();
                if (FirebaseAuth.instance.currentUser != null) {
                  // print(FirebaseAuth.instance.currentUser?.uid);
                  // Navigator.pushNamed(context, '/');
                  Navigator.pop(context);
                }
                // Navigator.pushNamed(context, '/home');
                // Navigator.pop(context);
              },
              // icon: const Icon(Icons.login, size: 18),
              child: const Text("GOOGLE"),
            ),
            const SizedBox(height: 12.0),

            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signInAnonymously();
                if (FirebaseAuth.instance.currentUser != null) {
                  // print(FirebaseAuth.instance.currentUser?.uid);
                  // Navigator.pushNamed(context, '/');
                  Navigator.pop(context);
                }
                // Navigator.pushNamed(context, '/home');
                // Navigator.pop(context);
              },
              // icon: const Icon(Icons.login, size: 18),
              child: const Text("Guest"),
            ),

            const SizedBox(height: 12.0),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/email_login');
              },
              // icon: const Icon(Icons.login, size: 18),
              child: const Text("Email"),
            ),


          ],
        ),
      ),
    );
  }
}

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

Future<void> init() async {
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);
}