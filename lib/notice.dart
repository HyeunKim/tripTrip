import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:intl/intl.dart';
import 'home.dart';
import 'drawer.dart';
import 'package:url_launcher/url_launcher.dart';

class NoticePage extends StatefulWidget {
  const NoticePage({Key? key}) : super(key: key);

  @override
  _NoticePageState createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  final Uri _url = Uri.parse('https://flutter.dev');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.1,
          backgroundColor: Colors.white70,
          centerTitle: true,
          title: const Text(
            'tripTrip',
            style: TextStyle(
              fontFamily: 'Quicksand',
              color: Color(0xFFf8bbd0),
              fontSize: 30,
            ),
          ),

          iconTheme: const IconThemeData(color: Color(0xFFf8bbd0), size: 35),
        ),
        drawer: DrawerCustom(),
        body: Container(
          child: Text(
            "Open link",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),


        // Text("sample"),

    );
  }
}

class _launchUrl {
}
