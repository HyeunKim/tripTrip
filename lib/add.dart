import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;

class AddPage extends StatefulWidget{
  const AddPage({Key? key}) : super(key:key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage>{
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {

    String? _image;

    String? title;
    String? message;

    final _formKey = GlobalKey<FormState>(debugLabel: '_logState2');
    final _controller_title = TextEditingController();
    final _controller = TextEditingController();

    final user_id = FirebaseAuth.instance.currentUser?.uid;


    Future<DocumentReference> addMessageTolog(String title, String message) {
      // if (!_loggedIn) {
      //   throw Exception('Must be logged in ');
      // }

      return FirebaseFirestore.instance
          .collection('log')
          .add(<String, dynamic>{
        'text': message,
        'title': title,
        'likes':0,
        'img_url':'https://ichef.bbci.co.uk/news/640/cpsprodpb/14C73/production/_121170158_planepoogettyimages-1135673520.jpg',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'name': FirebaseAuth.instance.currentUser!.displayName ?? '익명',
        'userId': FirebaseAuth.instance.currentUser!.uid,
      });
    }

    Future<DocumentReference> addMessageTologWithImage(String title, String message, String imgURL) {
      // if (!_loggedIn) {
      //   throw Exception('Must be logged in ');
      // }

      return FirebaseFirestore.instance
          .collection('log')
          .add(<String, dynamic>{
        'text': message,
        'title': title,
        'likes':0,
        'img_url':imgURL,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'name': FirebaseAuth.instance.currentUser!.displayName ?? '익명',
        'userId': FirebaseAuth.instance.currentUser!.uid,
      });
    }

    Future getImage() async {
      try {
        final image = await ImagePicker().pickImage(source: ImageSource.gallery);
        if (image == null) return;
        final imageTemporary = image.path;
        setState(() => _image = imageTemporary);
      }on PlatformException catch(e){
        print('Failed to pick image: $e');
      }
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
          // setState(() => _image = "https://firebasestorage.googleapis.com/v0/b/"+pickedFile.path+"?alt=media");
          print("---");
          print(_image);
          print("---");
          setState(() => _photo = File(_image!));
          // _photo = File(_image!);
          print(_photo);
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
          print(_image);
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

      print("미쳐버리겠네");
      print(_image);

      // if (_image == null){
      //   addMessageTolog(title!, message!);
      // }
      // else{
      //   addMessageTologWithImage(title!, message!, _image!);
      // }

    }

    Future makeLog_Img(String img_url) async {
      setState(() => _image = img_url);

      print("!!!!!!final!!");
      print(_image);

      if (_image == null){
        addMessageTolog(title!, message!);
      }
      else{
        addMessageTologWithImage(title!, message!, _image!);
      }

    }

    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    // TODO: Return an AsymmetricView (104)
    // TODO: Pass Category variable to AsymmetricView (104)
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
                  if (_formKey.currentState!.validate()) {
                    await makeLog(_controller_title.text, _controller.text);
                    _controller.clear();
                    _controller_title.clear();
                  }
                // makeLog(title!, message!);
                // log2(
                //   addMessage: (title, message) =>
                //       addMessageTolog(title, message),
                // )
                // : log2(
                // addMessage: (title, message) =>
                // addMessageTologWithImage(title, message, _image!),
                // ),
                // _image==null
                //     ? addMessageTolog(title!, message!)
                //     : addMessageTologWithImage(title!, message!, _image!);
                // Navigator.pop(context);
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
                  const DrawerHeader(
                      padding: EdgeInsets.fromLTRB(30, 30, 0, 0),
                      child: Text("tripTrip",
                          style: TextStyle(fontFamily: 'Quicksand', fontSize: 50,color: Colors.white,fontWeight: FontWeight.w100))
                  ),
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
                            ListTile(
                                title: Text('정보수정',style: TextStyle(fontSize: 35,color: Color(0xffff8484),fontWeight: FontWeight.w300))),
                          ],
                        )
                    )
                )
            )
          ],
        ),
      ),
      body:
      SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child:
        Column(
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
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(170, 0, 0, 0),
                      //   child: ElevatedButton(
                      //       style: ElevatedButton.styleFrom(
                      //         backgroundColor: const Color(0xFFffcdd2),
                      //         shape:
                      //             RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(18.0),
                      //         ),
                      //       ),
                      //       onPressed: () {
                      //         // 버튼을 누르면 실행될 코드 작성
                      //       },
                      //       child: const Text('SAVE')
                      //   ),
                      // ),

                    ],
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
                  const SizedBox(height: 8),
                  // const IconAndDetail(Icons.calendar_today, 'October 30'),
                  // const IconAndDetail(Icons.location_city, 'San Francisco'),
                  // Consumer<ApplicationState>(
                  //   builder: (context, appState, _) => AuthFunc(
                  //       loggedIn: appState.loggedIn,
                  //       signOut: () {
                  //         FirebaseAuth.instance.signOut();
                  //       }),
                  // ),
                  // const Divider(
                  //   height: 8,
                  //   thickness: 1,
                  //   indent: 8,
                  //   endIndent: 8,
                  //   color: Colors.grey,
                  // ),
                  // const Header("What we'll be doing"),
                  // const Paragraph(
                  //   'Join us for a day full of Firebase Workshops and Pizza!',
                  // ),
                  // Consumer<ApplicationState>(
                  //   builder: (context, appState, _) =>
                        Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // if (appState.attendees >= 2)
                        //   Paragraph('${appState.attendees} people going')
                        // else if (appState.attendees == 1)
                        //   const Paragraph('1 person going')
                        // else
                        //   const Paragraph('No one going'),
                        // if (appState.loggedIn) ...[
                          // YesNoSelection(
                          //   state: appState.attending,
                          //   onSelection: (attending) => appState.attending = attending,
                          // ),

                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Form(
                            key: _formKey,
                            child:
                            Column(
                              children: [
                                // StyledButton(
                                //   onPressed: () async {
                                //     Navigator.pushNamed(context, '/camera');
                                //
                                //   },
                                //   child: Row(
                                //     children: const [
                                //       Icon(Icons.send),
                                //       SizedBox(width: 4),
                                //       // Text('SEND'),
                                //     ],
                                //   ),
                                // ),
                                Column(
                                  children: [
                                    // Padding(
                                    //   padding: const EdgeInsets.fromLTRB(250, 0, 0, 0),
                                    //   child: ElevatedButton(
                                    //       style: ElevatedButton.styleFrom(
                                    //         elevation: 0,
                                    //         backgroundColor: const Color(0xFFef9a9a),
                                    //         shape:
                                    //         RoundedRectangleBorder(
                                    //           borderRadius: BorderRadius.circular(18.0),
                                    //         ),
                                    //       ),
                                    //       onPressed: () async {
                                    //         if (_formKey.currentState!.validate()) {
                                    //           await makeLog(_controller_title.text, _controller.text);
                                    //           _controller.clear();
                                    //           _controller_title.clear();
                                    //         }
                                    //       },
                                    //       child: const Text('SAVE')
                                    //   ),
                                    // ),
                                    TextFormField(
                                      style: const TextStyle(
                                        color: Color(0xFFffcdd2),
                                        fontSize: 30,
                                      ),
                                      controller: _controller_title,
                                      cursorColor: const Color(0xFFffcdd2),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText:'제목',
                                        hintStyle: TextStyle(fontSize: 30.0, color: Color(0xFFffcdd2)),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return '제목을 입력해주세요.';
                                        }
                                        return null;
                                      },
                                    ),
                                    // Expanded(
                                    //
                                    //   child: TextFormField(
                                    //     controller: _controller_title,
                                    //     decoration: const InputDecoration(
                                    //       hintText: '제목',
                                    //     ),
                                    //     validator: (value) {
                                    //       if (value == null || value.isEmpty) {
                                    //         return '제목을 입력해주세요.';
                                    //       }
                                    //       return null;
                                    //     },
                                    //   ),
                                    // ),
                                    const SizedBox(height: 8),
                                    const Divider(
                                      height: 8,
                                      thickness: 2,
                                      indent: 8,
                                      endIndent: 8,
                                      color: Color(0xFFffcdd2),
                                    ),

                                    const SizedBox(height: 25),
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
                                          hintText: '내용을 입력하세요.',
                                          contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return '내용을 입력해주세요.';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),


                                    const SizedBox(height: 8),

                                    const Divider(
                                      height: 8,
                                      thickness: 2,
                                      // indent: 8,
                                      // endIndent: 8,
                                      color: Color(0xFFffcdd2),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                                      child:
                                      Row(
                                        children: const [
                                          Text(
                                            '이미지',
                                            style: TextStyle(
                                              // fontFamily: 'Quicksand',
                                              color: Color(0xFFffcdd2),
                                              fontSize: 25,
                                            ),
                                          ),
                                          Text(
                                            '추가',
                                            style: TextStyle(
                                              // fontFamily: 'Quicksand',
                                                color: Colors.black54,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          // Padding(
                                          //   padding: const EdgeInsets.fromLTRB(170, 0, 0, 0),
                                          //   child: ElevatedButton(
                                          //       style: ElevatedButton.styleFrom(
                                          //         backgroundColor: const Color(0xFFffcdd2),
                                          //         shape:
                                          //             RoundedRectangleBorder(
                                          //               borderRadius: BorderRadius.circular(18.0),
                                          //         ),
                                          //       ),
                                          //       onPressed: () {
                                          //         // 버튼을 누르면 실행될 코드 작성
                                          //       },
                                          //       child: const Text('SAVE')
                                          //   ),
                                          // ),



                                        ],
                                      ),
                                    ),

                                    Container(
                                      // height: 500,
                                      // margin: const EdgeInsets.all(10),
                                      margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1.5,
                                          color: const Color(0xFFffcdd2),
                                        ),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(15.0) // POINT
                                        ),
                                      ),
                                      child:
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child:
                                          _image == null
                                              ? Image.network('https://ichef.bbci.co.uk/news/640/cpsprodpb/14C73/production/_121170158_planepoogettyimages-1135673520.jpg')
                                              : Image.file(File(_image!)),
                                        ),
                                      ),
                                    ),




                                    const SizedBox(height: 10),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pushNamed(context, '/new-add');
                                            // imgFromCamera();
                                            // print(_image);

                                            // Navigator.pop(context);
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

                                            print("gall");
                                            print(_image);
                                            makeLog_Img(_image!);
                                            print("gall");

                                            // Navigator.pop(context);
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
                                        // IconButton(
                                        //     onPressed: () {
                                        //       getImage();
                                        //
                                        //     },
                                        //     icon: const Icon(Icons.camera_alt_outlined)
                                        // ),
                                      ],
                                    ),

                                  ],
                                ),
                              ],
                            ),

                          ),
                        ),

                          // _image==null
                          // ? log2(
                          //     addMessage: (title, message) =>
                          //       makeLog(title, message),
                          //   )
                          // : log2(
                          //     addMessage: (title, message) =>
                          //         addMessageTologWithImage(title, message, _image!),
                          // ),
                        // ],
                      ],
                    ),

                ],
              ),
            ),
            const SizedBox(height: 10),



            const SizedBox(height: 70),

            // CloudStorageDemo

          ],
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

                // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                //Dialog Main Title
                // title: Column(
                //   children: <Widget>[
                //     new Text("Dialog Title"),
                //   ],
                // ),
                //
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: TextButton(
                        onPressed: () {
                          // imgFromCamera();

                          Navigator.pushNamed(context, '/temp-add');
                          // Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor:  Colors.black54,
                          textStyle: const TextStyle(fontSize: 20,),
                        ),
                        child: const Text("카메라"),
                      ),
                    ),

                    const Divider(
                      height: 8,
                      thickness: 2,
                      indent: 8,
                      endIndent: 8,
                      color: Color(0xFFffcdd2),
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor:  Colors.black54,
                          textStyle: const TextStyle(fontSize: 20,),
                        ),
                        child: const Text("갤러리"),
                      ),
                    ),
                    // Text(
                    //   "Dialog Content",
                    // ),
                  ],
                ),
                // actions: <Widget>[
                //   TextButton(
                //     child: new Text("확인"),
                //     onPressed: () {
                //       Navigator.pop(context);
                //     },
                //   ),
                // ],
              ),
          );
        });
  }

// @override
// Widget build(BuildContext context) {
//   return ProfileScreen(
//     providers: [],
//     actions: [
//       SignedOutAction(
//         ((context) {
//           Navigator.of(context).pushReplacementNamed('/home');
//         }),
//       ),
//     ],
//   );
// }
}