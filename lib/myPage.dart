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
  final CollectionReference album =
      FirebaseFirestore.instance.collection('album');
  final CollectionReference log =
      FirebaseFirestore.instance.collection('log');

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
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.popUntil(context, ModalRoute.withName('/sign-in'));
              },
            )
          ],
          iconTheme: const IconThemeData(color: Color(0xFFf8bbd0), size: 35),
        ),
        drawer: DrawerCustom(),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 30, 10),
                  child: Row(
                    children: const [
                      Text(
                        'MY',
                        style: TextStyle(
                          // fontFamily: 'Quicksand',
                          color: Color(0xFFffcdd2),
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 1,
                  color: Color(0xffff8484),
                  indent: 5,
                  endIndent: 5,
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ListTile(
                        title: RichText(
                            text: const TextSpan(
                                text: "MY",
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Color(0xffff8484),
                                    fontWeight: FontWeight.w300),
                                children: <TextSpan>[
                              TextSpan(
                                  text: 'trip앨범',
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300))
                            ])),
                        trailing: InkWell(
                            onTap: () {
                              //Navigator.pushNamed(context, '/album');
                            },
                            child: const Icon(Icons.arrow_forward_ios)))),
                StreamBuilder(
                    stream: album.snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if(snapshot.hasData){
                        return Container(
                          child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  for(int i=0; snapshot.data!.docs.length > i; i++)
                                    Padding(
                                        padding: EdgeInsets.all(10),
                                        child: SizedBox(
                                          width: 150,
                                          height: 100,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8.0),
                                              child: Image.network(snapshot.data!.docs[i]['imgs'][1], fit: BoxFit.cover))
                                    ))
                                ],
                              )
                          )
                        );}
                      else {
                        return const SizedBox(height: 100);
                        }
                    }),
                Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ListTile(
                        title: RichText(
                            text: const TextSpan(
                                text: "MY",
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Color(0xffff8484),
                                    fontWeight: FontWeight.w300),
                                children: <TextSpan>[
                              TextSpan(
                                  text: 'trip로그',
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300))
                            ])),
                        trailing: InkWell(
                            onTap: () {
                              //Navigator.pushNamed(context, '/album');
                            },
                            child: Icon(Icons.arrow_forward_ios)))),
                StreamBuilder(
                  stream: log.orderBy('timestamp').snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return GridView.builder(
                        shrinkWrap: true,
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
                                  onTap: () {
                                    Navigator.pushNamed(context, '/detail',
                                        arguments: Argument(
                                            documentSnapshot.id,
                                            documentSnapshot['likes'],
                                            documentSnapshot['name'],
                                            documentSnapshot['title'],
                                            documentSnapshot['img_url'],
                                            documentSnapshot['text'],
                                            // DateTime.parse(documentSnapshot['timestamp'].toString()) ,
                                            DateTime.fromMillisecondsSinceEpoch(
                                                documentSnapshot['timestamp']),
                                            documentSnapshot['userId']));
                                  },
                                  child: Image.network(
                                      documentSnapshot['img_url'],
                                      fit: BoxFit.cover)));
                        },
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                )
              ],
            )));
  }
}
