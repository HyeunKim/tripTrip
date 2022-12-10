import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'add.dart';
import 'email_loginPage.dart';
import 'home.dart';
import 'login.dart';
import 'notice.dart';
import 'profile.dart';
import 'update.dart';
import 'CloudStorageDemo.dart';
import 'detail.dart';
import 'tempAdd.dart';
import 'newAddPage.dart';
import 'coin.dart';
import 'album.dart';
import 'album_inside.dart';
import 'gallery_sample.dart';
import 'myPage.dart';
import 'log.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/sign-in',
      routes: {
        '/home': (context) {
          return HomePage();
        },
        '/sign-in': ((context) {
          return const LoginPage();
        }),
        '/album': ((context) {
          return const AlbumPage();
        }),
        '/album-inside': ((context) {
          return AlbumInsidePage();
        }),
        '/sample': ((context) {
          return SamplePage();
        }),
        '/email_login': ((context) {
          return const EmailLoginPage();
        }),
        '/add': ((context) {
          // return ProfilePage(providers: [], actions: [],);
          return const AddPage();
        }),
        '/update': ((context) {
          // return ProfilePage(providers: [], actions: [],);
          return const UpdatePage();
        }),
        '/detail': ((context) {
          // return ProfilePage(providers: [], actions: [],);
          return DetailPage();
        }),
        '/notice': ((context) {
          // return ProfilePage(providers: [], actions: [],);
          return NoticePage();
        }),
        '/coin': ((context) {
          // return ProfilePage(providers: [], actions: [],);
          return CoinPage();
        }),
        '/camera': ((context) {
          // return ProfilePage(providers: [], actions: [],);
          return CloudStorageDemo();
        }),

        '/temp-add': ((context) {
          // return ProfilePage(providers: [], actions: [],);
          return AddScreen();
        }),

        '/new-add': ((context) {
          // return ProfilePage(providers: [], actions: [],);
          return newAddScreen();
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
          return const ProfilePage();
        }),
        '/my-page': ((context) {
          // return ProfilePage(providers: [], actions: [],);
          return const MyPage();
        }),
        '/log': ((context) {
          return const LogPage();
        }),
      },
      // title: 'Firebase Meetup',

      title: 'tripTrip',
      theme: ThemeData(
        fontFamily: 'NanumGothicRegular',
        brightness: Brightness.light,
        backgroundColor: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // primaryColor: const Color(0xFFffebee),
        primaryColor: Colors.red,
        // primarySwatch: '#ffebee'.toColor(),
        // primarySwatch: Color(0xFFffebee),
        scaffoldBackgroundColor: Colors.white,
      ),

      // home: const HomePage(),
    );
  }
}