import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;

import 'home.dart';
import 'drawer.dart';


class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final currentUser = FirebaseAuth.instance;

  final CollectionReference _guestbook =
  FirebaseFirestore.instance.collection('guestbook');

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

          body:StreamBuilder(
            stream: _guestbook.orderBy('timestamp').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                  itemCount: snapshot.data!.docs.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16),
                  itemBuilder: (BuildContext context, int index) {
                    final DocumentSnapshot documentSnapshot =
                    snapshot.data!.docs[index];
                    return Card(
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                            onTap: (){
                              Navigator.pushNamed(
                                  context,
                                  '/detail',
                                  arguments: Argument(
                                      documentSnapshot.id,
                                      documentSnapshot['likes'],
                                      documentSnapshot['name'],
                                      documentSnapshot['title'],
                                      documentSnapshot['img_url'],
                                      documentSnapshot['text'],
                                      // DateTime.parse(documentSnapshot['timestamp'].toString()) ,
                                      DateTime.fromMillisecondsSinceEpoch(documentSnapshot['timestamp']),
                                      documentSnapshot['userId']
                                  )
                              );
                            },
                            child: Image.network(documentSnapshot['img_url'],fit: BoxFit.cover)
                        )
                    );
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )
      );
  }
}
