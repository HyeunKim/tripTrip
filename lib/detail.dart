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
import 'package:intl/intl.dart';
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

  String? _id;
  String? _image;
  String? _title;
  String? _content;
  DateTime? _date;
  String? _real_date;
  int? _likes;
  String? _userId;
  String? _name;

  final user_id = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context){
    final Argument oneContents = ModalRoute.of(context)!.settings.arguments as Argument;

    setState(() {
      _id = oneContents.id;
      _title = oneContents.title;
      _content = oneContents.message;
      _image = oneContents.img_url;
      _likes = oneContents.likes;
      _date = oneContents.timestamp;
      _userId = oneContents.userId;
      _name = oneContents.name;
      _real_date = DateFormat('yyyy년 MM월 dd일').format(_date!); // DateFormat('yyyy년 MM월 dd일 HH:mm:ss').format(_date!);
    });

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
          // actions: <Widget>[
          //   Align(
          //     alignment : Alignment.center,
          //     child: ElevatedButton(
          //       style: ElevatedButton.styleFrom(
          //         elevation: 0,
          //         backgroundColor: const Color(0xFFef9a9a),
          //         shape:
          //         RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(18.0),
          //         ),
          //       ),
          //       // onPressed: () {
          //       onPressed: () {
          //         print("temp..");
          //       },
          //       child: const Text(
          //           "Save",
          //           style: TextStyle(color: Colors.white)
          //       ),
          //     ),
          //   )
          //
          // ],
        ),

        drawer: DrawerCustom(),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child:
            Column(
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

                if (_userId == user_id)
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: (){
                                Navigator.pushNamed(context, '/update',
                                    arguments: Argument(
                                        _id!,
                                        _likes!,
                                        _name!,
                                        _title!,
                                        _image!,
                                        _content!,
                                        _date!,
                                        _userId!
                                    )
                                );
                              },
                            child: const Text(style: TextStyle(fontSize: 15.0, color: Color(0xFFffcdd2)),"편집"),
                              // icon: const Icon(Icons.edit, color: Color(0xFFef9a9a))
                          ),
                          // const SizedBox(width: 0),
                          TextButton(
                              onPressed: (){
                                CollectionReference guestbook = FirebaseFirestore.instance.collection('guestbook');

                                guestbook
                                    .doc(_id)
                                    .delete();
                                flutterDialog(context);
                                // Navigator.pop(context);
                              },
                            child: const Text(style: TextStyle(fontSize: 15.0, color: Color(0xFFffcdd2)),"삭제"),
                              // icon: const Icon(Icons.delete_outline, color: Color(0xFFef9a9a))
                          ),
                        ],
                    ),
                  ),

                // const Padding(
                //   padding: EdgeInsets.fromLTRB(30, 0, 0, 20),
                //   child:
                //   Text(
                //     '여행에 대한 기록을 자유롭게 기록하세요 !',
                //     style: TextStyle(
                //         color: Colors.black26,
                //         fontSize: 15,
                //         fontWeight: FontWeight.bold
                //     ),
                //   ),
                // ),
                Container(
                  // height: 500,
                  // margin: const EdgeInsets.all(10),
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFffebee).withOpacity(0.5),
                    // color: const Color(0xFFffebee),
                    border: Border.all(
                      width: 1.5,
                      color: const Color(0xFFffcdd2),
                      // color: Theme.of(context).accentColor,
                    ),
                    borderRadius: const BorderRadius.all(
                        Radius.circular(15.0) // POINT
                    ),
                  ),

                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Padding(
                        padding : const EdgeInsets.fromLTRB(275, 20, 10,0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:  [
                              const Icon(
                                Icons.favorite,
                                color: Color(0xFFffcdd2),
                              ),
                              const SizedBox(width: 5),
                              Text(style: const TextStyle(fontSize: 20.0, color: Color(0xFFffcdd2)),_likes.toString()),
                            ]
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(35, 0, 30,25),
                        child:
                            Text(style: const TextStyle(fontSize: 30.0, color: Color(0xFFef9a9a)),_title!),
                      ),
                      const Divider(
                        height: 8,
                        thickness: 2,
                        indent: 10,
                        endIndent: 10,
                        color: Color(0xFFffcdd2),
                      ),
                      const SizedBox(height: 15),

                      Padding(
                        padding : const EdgeInsets.fromLTRB(220, 0, 10, 10),
                        child: Column(
                          children: [
                            Text(style: const TextStyle(fontSize: 15.0, color: Color(0xFFffcdd2)),_real_date!),
                            Padding(
                              padding : const EdgeInsets.fromLTRB(0,10,10,15),
                              child:
                                Align(
                                  alignment: Alignment.topRight,
                                  child:Text(style: const TextStyle(fontSize: 15.0, color: Color(0xFFffcdd2)),_name!),)
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
                          _image == 'https://ichef.bbci.co.uk/news/640/cpsprodpb/14C73/production/_121170158_planepoogettyimages-1135673520.jpg'
                              ? Image.network('https://ichef.bbci.co.uk/news/640/cpsprodpb/14C73/production/_121170158_planepoogettyimages-1135673520.jpg')
                              : Image.file(File(_image!)),
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                        child:Text(style: const TextStyle(fontSize: 23.0, color: Colors.black54),_content!),

                      ),

                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     ElevatedButton(
                      //       onPressed: () {
                      //       },
                      //       style: ElevatedButton.styleFrom(
                      //         elevation: 0,
                      //         backgroundColor: const Color(0xFFef9a9a),
                      //         shape:
                      //         RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(18.0),
                      //         ),
                      //       ),
                      //       child: const Text("카메라"),
                      //     ),
                      //     const SizedBox(width: 30),
                      //     ElevatedButton(
                      //       onPressed: () {
                      //         // await imgFromGallery();
                      //       },
                      //       style: ElevatedButton.styleFrom(
                      //         elevation: 0,
                      //         backgroundColor: const Color(0xFFef9a9a),
                      //         shape:
                      //         RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(18.0),
                      //         ),
                      //       ),
                      //       child: const Text("갤러리"),
                      //     ),
                      //   ],
                      // ),

                      const SizedBox(height: 10),



                    ],
                  ),
                ),

                const SizedBox(height: 30),

              ]
          ),)
    );
  }

  void flutterDialog(BuildContext context) {
    showDialog(
      context: context,
      //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
      // barrierDismissible: false,
      builder: (BuildContext context) {
        return SizedBox(
          width: 50,
          child: AlertDialog(
            // backgroundColor: Color(0xFFffebee),
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                SizedBox(height: 45),
                Center(
                  child:
                  Text(
                    "정말로 삭제하시겠습니까?",
                    style: TextStyle(color: Color(0xFFe57373), fontSize: 20), // Color(0xFFe57373)
                  ),
                ),
                SizedBox(height: 15),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "확인",
                  style: TextStyle(color: Colors.black87, fontSize: 20), // Color(0xFFe57373)
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                  // Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}