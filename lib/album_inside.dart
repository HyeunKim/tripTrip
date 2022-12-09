import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:galleryimage/galleryimage.dart';
// import 'package:gallery_view/gallery_view.dart';
// import 'package:galleryimage/galleryimage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'album.dart';
import 'dart:io';

class AlbumInsidePage extends StatefulWidget {
  const AlbumInsidePage({Key? key}) : super(key: key);

  @override
  _AlbumInsidePageState createState() => _AlbumInsidePageState();
}

class _AlbumInsidePageState extends State<AlbumInsidePage> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  String? _id;
  String? _album_name;

  String? _netImage;

  int? _imgCount = 0;

  final user_id = FirebaseAuth.instance.currentUser?.uid;

  final ImagePicker imgpicker = ImagePicker();
  List<XFile>? imagefiles;
  List<String>? DownloadedImage = [""];

  openImages(BuildContext context, String? id) async {
    var i = 0;
    try {
      var pickedfiles = await imgpicker.pickMultiImage();
      if(pickedfiles != null){
        imagefiles = pickedfiles;

         imagefiles!.map((imageone){
           uploadFile(context, imageone, id, i);
           i++;
          }).toList();

        setState(() {
          _imgCount = imagefiles!.length;
          print("_imgCount");
          print(_imgCount);
        });
      }else{
        print("No image is selected.");
      }

    }catch (e) {
      print("error while picking file.");
    }
  }

  // Future<List> uploadFiles(List<XFile> _images, String? id) async {
  //   var imageUrls = await Future.wait(_images.map((_image) => uploadFile(_image, _id)));
  //   print("print!!");
  //   print(imageUrls);
  //   return imageUrls;
  // }

  Future<void> addImage(BuildContext context, String? id, int i, String imgURL) {
    return FirebaseFirestore.instance
        .collection('album')
        .doc(id)
        .update(<String, dynamic>{
          'imgs':FieldValue.arrayUnion([imgURL]),
      // 'img_url$i':imgURL,
    });

  }

  Future uploadFile(BuildContext context, XFile _image, String? id, int i) async {
    var _photo = File(_image!.path);
    print("photo 추가");
    print(_photo);
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = 'albums/$id/files/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      await ref.putFile(_photo!);
      _netImage = await ref.getDownloadURL();
      DownloadedImage?.add(_netImage!);
      addImage(context, id, i, _netImage!);
    } catch (e) {
      print('error occured');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Argument oneContents =
    ModalRoute.of(context)!.settings.arguments as Argument;
    final currentUser = FirebaseAuth.instance;
    final CollectionReference likeCol =
    FirebaseFirestore.instance.collection(oneContents.id);

    setState(() {
      _id = oneContents.id;
      _album_name = oneContents.album_name;
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

        ),
        // drawer: DrawerCustom(),
        floatingActionButton: Container(
          alignment: Alignment.bottomRight,
          // padding: const EdgeInsets.fromLTRB(100, 0, 150, 0),
          child: FloatingActionButton.extended(
            elevation: 0,
            backgroundColor: const Color(0xFFef9a9a),
            onPressed: () async {
              await openImages(context, _id);

              // 사진이 스토리지나 클라우드에는 저장이 바로 되지만,
              // 로드가 바로 안되기 때문에 앨범들이 있는 곳으로 나오고
              // 시간이 좀 지나고 들어가면 내가 추가한 사진들이 나옴.
              Navigator.pop(context);
              // 버튼을 누르면 실행될 코드 작성
            },
            label: const Text("사진 추가"),
            // shape: const Icon(Icons.add_circle),
          ),
        ),

        body: StreamBuilder(
            stream: likeCol.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return
                SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child:
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 30, 20),
                        child: Row(
                          children: [
                            Text(
                              _album_name!,
                              style: const TextStyle(
                                // fontFamily: 'Quicksand',
                                color: Color(0xFFef9a9a),
                                // color: Color(0xFF616161),
                                fontSize: 30,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: InkWell(
                          // 앨범의 첫번째 사진으로 Text 부분 바꾸기
                          child: Container(
                              // width: 160,
                              // height: 160,
                              // color: Color(0xFFeeeeee),
                              child:
                              GalleryImage(
                                titleGallery:oneContents.album_name,
                                // Theme.of(context),
                                numOfShowImages: oneContents.imgs.length-1,
                                imageUrls: [
                                  for(int i = 1; i<oneContents.imgs.length; i++)
                                    oneContents.imgs[i],
                                ],
                              ),
                            // Image.network('https://colorate.azurewebsites.net/SwatchColor/E2E2E2')
                          ),
                          // onLongPress: (){
                          //   print(oneContents.imgs[i]);
                          //   print("사진 길게 누름!!!");
                          // }
                            // 사진 삭제 묻는 alert
                            // AlbumLongTouchDialog(context, documentSnapshot.id, documentSnapshot['album_name']);
                          // },
                        ),

                        // GalleryImage(
                        //   titleGallery:oneContents.album_name,
                        //   // Theme.of(context),
                        //   numOfShowImages: oneContents.imgs.length-1,
                        //   imageUrls: [
                        //
                        //     for(int i = 1; i<oneContents.imgs.length; i++)
                        //       oneContents.imgs[i],
                        //   ],
                        // ),
                      ),

                      ),

                      const SizedBox(height: 30),
                    ]
                ),
              );
            }) /**/
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
