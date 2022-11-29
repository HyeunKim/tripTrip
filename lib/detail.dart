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

class DetailPage extends StatefulWidget{
  const DetailPage({Key? key}) : super(key:key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>{
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;


  String? title;
  String? message;
  String? _image;

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

    print(_image);

    if (_image == null){
      addMessageToGuestBookDefaultImage(title!, message!);
    }
    else{
      addMessageToGuestBookWithImage(title!, message!, _image!);
    }

  }



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
                onPressed: () async {
                  print("temp..");

                  if (_formKey.currentState!.validate()) {
                    await makeLog(_controller_title.text, _controller.text);
                    _controller.clear();
                    _controller_title.clear();
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

        // floatingActionButton: Container(
        //   // alignment: Alignment.center,
        //   padding: const EdgeInsets.fromLTRB(100, 0, 150, 0),
        //   child: FloatingActionButton(
        //     elevation: 0,
        //     backgroundColor: const Color(0xFFef9a9a),
        //     onPressed: () {
        //       flutterDialog(context);
        //       // 버튼을 누르면 실행될 코드 작성
        //     },
        //     child: const Icon(Icons.add_a_photo),
        //   ),
        // ),

        drawer: Drawer(
          backgroundColor: const Color(0xffFFCCCC),
          child: Column(
            children: <Widget>[
              Expanded(
                // ListView contains a group of widgets that scroll inside the drawer
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Padding(padding: const EdgeInsets.fromLTRB(35, 60, 0, 50),
                      child:Align(
                        alignment: Alignment.topLeft,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/home');
                          },
                          style: TextButton.styleFrom(
                              foregroundColor:  Colors.white,
                              textStyle: const TextStyle(fontFamily: 'Quicksand', fontSize: 40,color: Colors.white,fontWeight: FontWeight.w100)),


                          child: const Text("tripTrip"),
                        ),
                      ),
                    ),

                    // const DrawerHeader(
                    //     padding: EdgeInsets.fromLTRB(30, 30, 0, 0),
                    //     child: Text("tripTrip",
                    //         style: TextStyle(fontFamily: 'Quicksand', fontSize: 50,color: Colors.white,fontWeight: FontWeight.w100))
                    // ),
                    Padding(padding: const EdgeInsets.only(left: 40),
                        child:ListTile(
                          minLeadingWidth: 20,
                          leading: const Text('/',style: TextStyle(fontFamily: 'Quicksand',fontSize: 40,color: Colors.white,fontWeight: FontWeight.w100)),
                          title: const Text("MY",style: TextStyle(fontSize: 25,color: Color(0xffff8484),fontWeight: FontWeight.w300 ),),
                          onTap:(){
                            if(FirebaseAuth.instance.currentUser==null){
                              Navigator.pushNamed(context, '/sign-in');
                            }else{
                              FirebaseAuth.instance.signOut();
                              if(FirebaseAuth.instance.currentUser==null){
                                Navigator.pushNamed(context, '/sign-in');
                              }
                              // Navigator.popUntil(context, ModalRoute.withName('/sign-in'));//Navigator.pushNamed(context, '/MY');
                              // _signOut();
                              // Navigator.popUntil(context, ModalRoute.withName('/sign-in'));//Navigator.pushNamed(context, '/MY');
                            }
                          },
                        )
                    ),
                    Padding(padding: const EdgeInsets.only(left: 40),
                        child:ListTile(
                          minLeadingWidth: 20,
                          leading: const Text('/',style: TextStyle(fontFamily: 'Quicksand',fontSize: 40,color: Colors.white,fontWeight: FontWeight.w100)),
                          title: RichText(text: const TextSpan(text: "trip",
                              style: TextStyle(fontSize: 25,color: Color(0xffff8484),fontWeight: FontWeight.w300),
                              children: <TextSpan>[TextSpan(text: '앨범', style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.w300))])
                          ),
                          onTap: (){
                            Navigator.pushNamed(context, '/sign-in');
                          },
                        )
                    ),
                    Padding(padding: const EdgeInsets.only(left: 40),
                        child:ListTile(
                          minLeadingWidth: 20,
                          leading: const Text('/',style: TextStyle(fontFamily: 'Quicksand',fontSize: 40,color: Colors.white,fontWeight: FontWeight.w100)),
                          title: RichText(text: const TextSpan(text: "trip",
                              style: TextStyle(fontSize: 25,color: Color(0xffff8484),fontWeight: FontWeight.w300),
                              children: <TextSpan>[TextSpan(text: '로그', style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.w300))])
                          ),
                          onTap: (){
                            Navigator.pushNamed(context, '/home');
                          },
                        )
                    ),
                    Padding(padding: const EdgeInsets.only(left: 40),
                        child:ListTile(
                          minLeadingWidth: 20,
                          leading: const Text('/',style: TextStyle(fontFamily: 'Quicksand',fontSize: 40,color: Colors.white,fontWeight: FontWeight.w100)),
                          title: RichText(text: const TextSpan(text: "trip",
                              style: TextStyle(fontSize: 25,color: Color(0xffff8484),fontWeight: FontWeight.w300),
                              children: <TextSpan>[TextSpan(text: '코인', style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.w300))])
                          ),
                          onTap: (){
                            Navigator.pushNamed(context, '/');
                          },
                        )
                    ),
                  ],
                ),
              ),
              // This container holds the align
              Container(
                // This align moves the children to the bottom
                  child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      // This container holds all the children that will be aligned
                      // on the bottom and should not scroll with the above ListView
                      child: Container(
                          child: Column(
                            children: const <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(15, 0, 0, 15),
                                child: ListTile(
                                    title: Text('정보수정',style: TextStyle(fontSize: 25,color: Color(0xffff8484),fontWeight: FontWeight.w300))),
                              )
                            ],
                          )
                      )
                  )
              )
            ],
          ),
        ),
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
                        // height: 500,
                        // margin: const EdgeInsets.all(10),
                        margin: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                        // padding: const EdgeInsets.all(8),
                        // decoration: BoxDecoration(
                        //   border: Border.all(
                        //     width: 1.5,
                        //     color: const Color(0xFFffcdd2),
                        //   ),
                        //   borderRadius: const BorderRadius.all(
                        //       Radius.circular(10.0) // POINT
                        //   ),
                        // ),

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
          ),)
    );
  }
}