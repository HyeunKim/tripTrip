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
import 'drawer.dart';
import 'home.dart';

class UpdatePage extends StatefulWidget{
  const UpdatePage({Key? key}) : super(key:key);

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage>{
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  String? new_title;
  String? new_message;
  String? new_img;

  String? _id;
  String? _image;
  String? _title;
  String? _content;
  DateTime? _date;
  // String? _real_date;
  int? _likes;
  // String? _userId;
  // String? _name;

  // final _formKey = GlobalKey<FormState>(debugLabel: '_GuestBookState2');
  // // final _controller_title = TextEditingController(text: {_title});
  // final _controller = TextEditingController();

  Future<void> updateMessageToGuestBookDefaultImage(String title, String message) {
    return FirebaseFirestore.instance
        .collection('guestbook')
        .doc(_id)
        .update(<String, dynamic>{
      'text': message,
      'title': title,
      'img_url':'https://ichef.bbci.co.uk/news/640/cpsprodpb/14C73/production/_121170158_planepoogettyimages-1135673520.jpg',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<void> updateMessageToGuestBookWithImage(String title, String message, String imgURL) {
    return FirebaseFirestore.instance
        .collection('guestbook')
        .doc(_id)
        .update(<String, dynamic>{
      'title': title,
      'text' : message,
      'img_url' : imgURL,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
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
    } catch (e) {
      print('error occured');
    }
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        setState(() => new_img = pickedFile.path);
        setState(() => _photo = File(new_img!));
        setState(() => new_img = pickedFile.path);
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
        setState(() => new_img = pickedFile.path);
        _photo = File(new_img!);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future makeNewLog(String later_title, String later_message) async {
    setState(() => new_title = later_title);
    setState(() => new_message = later_message);

    if (new_img == null){
      updateMessageToGuestBookDefaultImage(new_title!, new_message!);
    }
    else{
      updateMessageToGuestBookWithImage(new_title!, new_message!, new_img!);
    }
  }

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
      // _userId = oneContents.userId;
      // _name = oneContents.name;
      // _real_date = DateFormat('yyyy년 MM월 dd일').format(_date!); // DateFormat('yyyy년 MM월 dd일 HH:mm:ss').format(_date!);
    });

    final _formKey = GlobalKey<FormState>(debugLabel: '_GuestBookState2');
    final _controller_title = TextEditingController(text: _title);
    final _controller = TextEditingController(text: _content);

    if (_image != "https://ichef.bbci.co.uk/news/640/cpsprodpb/14C73/production/_121170158_planepoogettyimages-1135673520.jpg"){
      setState(() {
        new_img = _image;
      });
    }


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
                  await makeNewLog(_controller_title.text, _controller.text);
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
                    const SizedBox(width: 10),
                    Text(
                      '수정',
                      style: TextStyle(
                        // fontFamily: 'Quicksand',
                          color: Color(0xFFffcdd2),
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                      ),
                    ),

                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 0, 20),
                child:
                Text(
                  "제목 [ ${_title!} ] 글을 수정하고 있습니다.",
                  style: const TextStyle(
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
                            '사진',
                            style: TextStyle(
                              color: Color(0xFFef9a9a), // Color(0xFFffcdd2),
                              fontSize: 25,
                            ),
                          ),
                          Text(
                            '수정',
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
                        child: Image.network(new_img!),
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
                          '수정',
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
                              // initialValue: "hi",
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
                    "수정하시겠습니까?",
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