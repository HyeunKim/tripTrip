import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:path/path.dart';
import 'home.dart';
import 'drawer.dart';

class DetailPage extends StatefulWidget{
  const DetailPage({Key? key}) : super(key:key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>{
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  String? _image;

  @override
  Widget build(BuildContext context){
    final Argument oneContents = ModalRoute.of(context)!.settings.arguments as Argument;

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
          actions: <Widget>[
            Align(
              alignment : Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color(0xFFef9a9a),
                  shape:
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                // onPressed: () {
                onPressed: () {
                  print("temp..");
                },
                child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white)
                ),
              ),
            )

          ],
        ),

        drawer: DrawerCustom(),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 30, 20),
                  child:
                  Row(
                    children: const [
                      Text(
                        'trip',
                        style: TextStyle(
                          // fontFamily: 'Quicksand',
                          color: Color(0xFFffcdd2),
                          fontSize: 30,
                        ),
                      ),
                      Text(
                        '로그',
                        style: TextStyle(
                          // fontFamily: 'Quicksand',
                            color: Colors.black54,
                            fontSize: 30,
                            fontWeight: FontWeight.bold
                        ),
                      ),

                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(30, 0, 0, 20),
                  child:
                  Text(
                    '여행에 대한 기록을 자유롭게 기록하세요 !',
                    style: TextStyle(
                        color: Colors.black26,
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Container(
                  // height: 500,
                  // margin: const EdgeInsets.all(10),
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.5,
                      color: const Color(0xFFffcdd2),
                    ),
                    borderRadius: const BorderRadius.all(
                        Radius.circular(15.0) // POINT
                    ),
                  ),

                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(35, 30, 30,20),
                        child:
                        Row(
                          children: const [
                            Icon(
                              Icons.looks_one, // Icons.image_outlined,
                              color: Colors.black54, // Color(0xFFef9a9a),
                            ),
                            SizedBox(width: 8),
                            Text(
                              '여행',
                              style: TextStyle(
                                color: Color(0xFFef9a9a), // Color(0xFFffcdd2),
                                fontSize: 25,
                              ),
                            ),
                            Text(
                              '사진',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 25,
                                // fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(30, 0, 30, 10),

                        child:
                        SizedBox(
                          width: double.infinity,
                          child:
                          _image == null
                              ? Image.network('https://ichef.bbci.co.uk/news/640/cpsprodpb/14C73/production/_121170158_planepoogettyimages-1135673520.jpg')
                              : Image.file(File(_image!)),
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: const Color(0xFFef9a9a),
                              shape:
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                            child: const Text("카메라"),
                          ),
                          const SizedBox(width: 30),
                          ElevatedButton(
                            onPressed: () {
                              // await imgFromGallery();
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: const Color(0xFFef9a9a),
                              shape:
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                            child: const Text("갤러리"),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),



                    ],
                  ),
                ),

                const SizedBox(height: 30),

              ]
          ),)
    );
  }
}