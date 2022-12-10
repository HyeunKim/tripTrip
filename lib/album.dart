import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:outline_search_bar/outline_search_bar.dart';
import 'package:path/path.dart';
import 'drawer.dart';


import 'dart:async';                                     // new

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart'        // new
//     hide EmailAuthProvider, PhoneAuthProvider;           // new
import 'package:firebase_core/firebase_core.dart';       // new
import 'package:firebase_ui_auth/firebase_ui_auth.dart'; // new

import 'firebase_options.dart';                          // new
// import 'src/authentication.dart';
import 'package:provider/provider.dart';

class Argument {
  String id;
  String album_name;
  List<dynamic> imgs;

  Argument(this.id, this.album_name, this.imgs);
}

class AlbumPage extends StatefulWidget{
  const AlbumPage({Key? key}) : super(key:key);

  @override
  _AlbumPageState createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage>{

  Future<void> addNewAlbum(String album_title) {
    return FirebaseFirestore.instance
        .collection("album").doc(album_title)
        .set({
      'imgs':[""],
      'album_name' : album_title,
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  final CollectionReference _album =
  FirebaseFirestore.instance.collection('album');

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.white70,
        centerTitle: true,
        title: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/home');
          },
          child: const Text(
            'tripTrip',
            style: TextStyle(
              fontFamily: 'Quicksand',
              color: Color(0xFFf8bbd0),
              fontSize: 30,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFf8bbd0), size: 35),
      ),

      drawer: DrawerCustom(),

      floatingActionButton: Container(
        // alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(100, 0, 150, 0),
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: const Color(0xFFef9a9a),
          onPressed: () {
            flutterDialog(context);
            // 버튼을 누르면 실행될 코드 작성
          },
          child: const Icon(Icons.add),
        ),
      ),

      body: StreamBuilder(
        stream: _album.orderBy('timestamp').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
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
                                  '앨범',
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
                      const Divider(
                          height: 8,
                          thickness: 2,
                          indent: 15,
                          endIndent: 15,
                          color: Color(0xFFffcdd2),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(25, 10, 0, 20),
                        child:
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "다른 사람들의 여행 앨범들을 살펴보세요!",
                            style: TextStyle(
                                color: Colors.black26,
                                fontSize: 13,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                      Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child:
                        GridView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 3 / 4,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 5
                          ),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            final DocumentSnapshot documentSnapshot =
                            snapshot.data!.docs[index];
                            return SingleChildScrollView(
                                child: Column(

                                  children: [
                                    Card(
                                      // 카드 밑에 그림자 주고싶으면 하기
                                      elevation: 0,
                                      shadowColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        // card border radius 없애기
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: InkWell(
                                        // 앨범의 첫번째 사진으로 Text 부분 바꾸기
                                        child: Container(
                                            width: 160,
                                            height: 160,
                                            color: Color(0xFFeeeeee),
                                            child: documentSnapshot['imgs'].length > 1?
                                            Image.network(documentSnapshot['imgs'][1], fit: BoxFit.cover):
                                                Container()
                                                // Image.network('https://colorate.azurewebsites.net/SwatchColor/E2E2E2')
                                        ),
                                        onTap: (){
                                          // 해당 앨범으로 이동
                                          Navigator.pushNamed(
                                              context,
                                              '/album-inside',
                                              arguments: Argument(
                                                documentSnapshot.id,
                                                documentSnapshot['album_name'],
                                                documentSnapshot['imgs'],
                                              )
                                          );
                                        },
                                        onLongPress: (){
                                          // 이름수정 / 삭제 묻는 alert
                                          // 앨범 하나 전체 삭제 묻는 alert
                                          AlbumLongTouchDialog(context, documentSnapshot.id, documentSnapshot['album_name']);
                                        },
                                      ),

                                    ),
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          documentSnapshot['album_name'],
                                          style: TextStyle(color: Colors.black54, fontSize: 20, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(18, 5, 0, 0),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          (documentSnapshot['imgs'].length-1).toString(),
                                          style: TextStyle(color: Colors.black38, fontSize: 15),
                                        ),
                                      ),
                                    ),


                                  ],
                                ),
                            );

                          },
                        ),
                      ),

                    ],
                ),
            );

          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      )
    );
  }

  void AlbumLongTouchDialog(BuildContext context, String id, String name) {
    showDialog(
      context: context,
      //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
      // barrierDismissible: false,
      builder: (BuildContext context) {
        return SizedBox(
          width: 50,
          child: AlertDialog(
            backgroundColor: Color(0xFFffebee),
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: TextButton(
                    onPressed: () {
                      EditAlbumName(context, id, name);
                      // Navigator.pushNamed(context, '/앨범사진추가하는 페이지');
                    },
                    style: TextButton.styleFrom(
                      foregroundColor:  Color(0xFFe57373),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    child: const Text("이름 수정하기"),
                  ),
                ),

                const Divider(
                  height: 8,
                  thickness: 2,
                  indent: 8,
                  endIndent: 8,
                  color: Colors.white,
                ),
                Center(
                  child: TextButton(
                    onPressed: () {
                      DeleteDialog(context, id);
                      // Navigator.pushNamed(context, '/new-add');
                    },
                    style: TextButton.styleFrom(
                      foregroundColor:  Color(0xFFe57373),
                      textStyle: const TextStyle(fontSize: 20,),
                    ),
                    child: const Text("앨범 삭제하기"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void DeleteDialog(BuildContext context, String id) {
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
                  child: Text(
                    "정말로 삭제하시겠습니까?",
                    style: TextStyle(
                        color: Color(0xFFe57373),
                        fontSize: 20), // Color(0xFFe57373)
                  ),
                ),
                SizedBox(height: 15),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "확인",
                  style: TextStyle(
                      color: Colors.black87, fontSize: 20), // Color(0xFFe57373)
                ),
                onPressed: () {
                  CollectionReference album =
                  FirebaseFirestore.instance
                      .collection('album');

                  album.doc(id).delete();
                  // Navigator.pushNamed(context, '/home');
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void flutterDialog(BuildContext context) {
    final _formKey_2 = GlobalKey<FormState>();
    final _controller = TextEditingController();

    showDialog(
      context: context,
      //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
      // barrierDismissible: false,
      builder: (BuildContext context) {
        return SizedBox(
          width: 50,
          child: AlertDialog(
            // backgroundColor: Color(0xFFbdbdbd),
            // backgroundColor: Colors.black,
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Center(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(55, 30, 50, 18),
                    child: Text(
                      "새로운 앨범",
                      style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold), // Color(0xFFe57373)
                    ),
                  ),
                ),
                // SizedBox(height: 45),
                const Center(
                  child:
                  Text(
                    "이 앨범 이름을 입력해주세요.",
                    style: TextStyle(color: Color(0xFFe57373), fontSize: 16), // Color(0xFFe57373)
                  ),
                ),
                SizedBox(height: 40),
                Form(
                  key: _formKey_2,
                  child:
                  TextFormField(
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                    ),
                    controller: _controller,
                    cursorColor: Colors.black38,
                    decoration: InputDecoration(
                      // border: InputBorder.none,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '앨범 이름을 입력해주세요.';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              Center(
                child:  TextButton(
                  child: const Text(
                    "저장",
                    style: TextStyle(
                      color: Color(0xFFe57373),
                      fontSize: 20,
                    ), // Color(0xFFe57373)
                  ),
                  onPressed: () {
                    // Navigator.pushNamed(context, '/sample');
                    //herehere


                    if (_formKey_2.currentState!.validate()) {
                      print("앨범 저장하기");
                      // appState.
                      addNewAlbum(_controller.text);
                      // makeLog(_controller.text, _controller.text);
                      _controller.clear();
                    }
                    // Navigator.pushNamed(context, '/home');
                    Navigator.pop(context);



                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void EditAlbumName(BuildContext context, String id, String name) {
    final _formKey_2 = GlobalKey<FormState>();
    // final _controller = TextEditingController();
    final _controller = TextEditingController(text: name);

    showDialog(
      context: context,
      //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SizedBox(
          width: 50,
          child: AlertDialog(
            // backgroundColor: Color(0xFFbdbdbd),
            // backgroundColor: Colors.black,
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Center(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(55, 30, 50, 18),
                    child: Text(
                      "앨범 이름 수정",
                      style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold), // Color(0xFFe57373)
                    ),
                  ),
                ),
                // SizedBox(height: 45),
                const Center(
                  child:
                  Text(
                    "수정할 이름을 입력해주세요.",
                    style: TextStyle(color: Color(0xFFe57373), fontSize: 16), // Color(0xFFe57373)
                  ),
                ),
                SizedBox(height: 40),
                Form(
                  key: _formKey_2,
                  child:
                  TextFormField(
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                    ),
                    controller: _controller,
                    cursorColor: Colors.black38,
                    decoration: InputDecoration(
                      // border: InputBorder.none,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '앨범 이름을 입력해주세요.';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              Center(
                child:  TextButton(
                  child: const Text(
                    "저장",
                    style: TextStyle(
                      color: Color(0xFFe57373),
                      fontSize: 20,
                    ), // Color(0xFFe57373)
                  ),
                  onPressed: () {
                    if (_formKey_2.currentState!.validate()) {
                      // appState.
                      FirebaseFirestore.instance
                          .collection('album')
                          .doc(id)
                          .update(<String, dynamic>{
                      'album_name': _controller.text
                      });
                      _controller.clear();
                    }
                    // Navigator.pushNamed(context, '/home');
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}