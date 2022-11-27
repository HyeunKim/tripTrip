import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'add.dart';
import 'email_loginPage.dart';
import 'home.dart';
import 'login.dart';
import 'profile.dart';
import 'update.dart';
import 'CloudStorageDemo.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/home',
      routes: {
        '/home': (context) {
          return const HomePage();
        },
        '/sign-in': ((context) {
          return LoginPage();
        }),
        '/email_login': ((context) {
          return EmailLoginPage();
        }),
        '/add': ((context) {
          // return ProfilePage(providers: [], actions: [],);
          return AddPage();
        }),
        '/update': ((context) {
          // return ProfilePage(providers: [], actions: [],);
          return UpdatePage();
        }),
        '/camera': ((context) {
          // return ProfilePage(providers: [], actions: [],);
          return CloudStorageDemo();
        }),
        '/forgot-password': ((context) {
          final arguments = ModalRoute.of(context)?.settings.arguments
          as Map<String, dynamic>?;

          return ForgotPasswordScreen(
            email: arguments?['email'] as String,
            headerMaxExtent: 200,
          );
        }),
        '/profile': ((context) {
          // return ProfilePage(providers: [], actions: [],);
          return ProfilePage();
        })
      },
      // title: 'Firebase Meetup',

      // home: const HomePage(),
    );
  }
}