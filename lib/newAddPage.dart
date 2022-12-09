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
import 'drawer.dart';

class newAddScreen extends StatefulWidget{
  const newAddScreen({Key? key}) : super(key:key);

  @override
  _newAddScreenState createState() => _newAddScreenState();
}

class _newAddScreenState extends State<newAddScreen>{
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  String? title;
  String? message;
  String? _image;
  String? _netImage;

  final _formKey = GlobalKey<FormState>(debugLabel: '_GuestBookState2');
  final _controller_title = TextEditingController();
  final _controller = TextEditingController();

  Future<DocumentReference> addMessageToGuestBookDefaultImage(String title, String message) {
    return FirebaseFirestore.instance
        .collection('guestbook')
        .add(<String, dynamic>{
      'text': message,
      'title': title,
      'likes':0,
      'img_url':'https://ichef.bbci.co.uk/news/640/cpsprodpb/14C73/production/_121170158_planepoogettyimages-1135673520.jpg',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'name': FirebaseAuth.instance.currentUser!.displayName ?? 'anoy',
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }

  Future<DocumentReference> addMessageToGuestBookWithImage(String title, String message, String imgURL) {
    return FirebaseFirestore.instance
        .collection('guestbook')
        .add(<String, dynamic>{
      'text': message,
      'title': title,
      'likes':0,
      'img_url':imgURL,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'name': FirebaseAuth.instance.currentUser!.displayName ?? 'anoy',
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }

  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = 'files/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      await ref.putFile(_photo!);
      _netImage = await ref.getDownloadURL();
    } catch (e) {
      print('error occured');
    }
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        setState(() => _image = pickedFile.path);
        setState(() => _photo = File(_image!));
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        setState(() => _image = pickedFile.path);
        _photo = File(_image!);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future makeLog(String later_title, String later_message) async {
    setState(() => title = later_title);
    setState(() => message = later_message);

    if (_image == null){
      addMessageToGuestBookDefaultImage(title!, message!);
    }
    else{
      addMessageToGuestBookWithImage(title!, message!, _netImage!);
    }
  }

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
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await makeLog(_controller_title.text, _controller.text);
                    _controller.clear();
                    _controller_title.clear();
                    flutterDialog(context);
                  }
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
                          // height: 500,
                          // margin: const EdgeInsets.all(10),
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
                              onPressed: () async {
                                await imgFromCamera();
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
                              onPressed: () async {
                                await imgFromGallery();
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

                        const SizedBox(height: 18),
                        const Divider(
                          height: 8,
                          thickness: 2,
                          // indent: 8,
                          // endIndent: 8,
                          color: Color(0xFFffcdd2),
                        ),
                        const SizedBox(height: 28),

                        Row(
                          children: const [
                            SizedBox(width: 35),
                            Icon(
                              Icons.looks_two, // Icons.image_outlined,
                              color: Colors.black54, // Color(0xFFef9a9a),
                            ),
                            SizedBox(width: 8),
                            Text(
                              '로그',
                              style: TextStyle(
                                color: Color(0xFFef9a9a), // Color(0xFFffcdd2),
                                fontSize: 25,
                              ),
                            ),
                            Text(
                              '작성',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 25,
                                // fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Form(
                            key: _formKey,
                            child:

                            Column(
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                style: const TextStyle(
                                  color: Color(0xFFffcdd2),
                                  fontSize: 30,
                                ),
                                controller: _controller_title,
                                cursorColor: const Color(0xFFffcdd2),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  labelText: '제목',
                                  labelStyle: TextStyle(fontSize: 30.0, color: Colors.black54),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '제목을 입력해주세요.';
                                  }
                                  return null;
                                  },
                              ),
                              // const SizedBox(height: 5),
                              const Divider(
                                height: 8,
                                thickness: 2,
                                // indent: 8,
                                // endIndent: 8,
                                color: Color(0xFFffcdd2),
                              ),
                              const SizedBox(height: 15),
                              SizedBox(
                                height: 320,
                                // width: 200,
                                child: TextFormField(
                                  cursorColor: Color(0xFFffcdd2),
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                  controller: _controller,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '내용을 입력해주세요.',
                                    labelStyle: TextStyle(fontSize: 30.0, color: Colors.black54),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 2.0),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '내용을 한 자 이상 입력해주세요.';
                                    }
                                    return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                  ),
                ),

                const SizedBox(height: 30),

              ]
          ),
        ),
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
                    "저장되었습니다.",
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