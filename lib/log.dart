import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:flutter/material.dart';
import 'package:flutter_gallery_3d/gallery3d.dart';

import 'drawer.dart';
import 'home.dart';


class LogPage extends StatefulWidget{
  const LogPage({Key? key}) : super(key:key);

  @override
  _LogPageState createState() => _LogPageState();
}

class _LogPageState extends State<LogPage>{

  Future _signOut()  async{
    await FirebaseAuth.instance.signOut();
  }

  final currentUser = FirebaseAuth.instance;
  final CollectionReference _log =
  FirebaseFirestore.instance.collection('log');

  var imageUrlList = [
    "https://i.natgeofe.com/n/93231b5d-3b4f-4bd6-bcf4-4172ebda2011/parliment-square-london-england_2x3.jpg",
    "https://www.tourw.co.kr/data/tour/1521247178_1.jpg",
    "https://images.squarespace-cdn.com/content/v1/586ebc34d482e9c69268b69a/1624386887478-9Z3XA27D8WFVDWKW00QS/20201230173806551_JRT8E1VC.png",
    "https://a.cdn-hotels.com/gdcs/production68/d1303/c8fa75d8-6932-459b-9660-8340f097ebd7.jpg",
    "https://www.hanbit.co.kr/data/editor/20191017121027_wgbsqeit.png",
    "https://a.cdn-hotels.com/gdcs/production48/d1804/5274c100-5336-4f8b-9d7a-c1f4fb30d1a1.jpg",
  ];

  int currentIndex = 0;

  Widget buildGallery3D() {
    return Gallery3D(
        itemCount: imageUrlList.length,
        width: MediaQuery.of(context).size.width,
        height: 220,
        isClip: false,

        // ellipseHeight: 80,
        itemConfig: const GalleryItemConfig(
          width: 220,
          height: 300,
          radius: 10,
          isShowTransformMask: false,
          // shadows: [
          //   BoxShadow(
          //       color: Color(0x90000000), offset: Offset(2, 0), blurRadius: 5)
          // ]
        ),
        currentIndex: currentIndex,
        onItemChanged: (index) {
          setState(() {
            this.currentIndex = index;
          });
        },
        onClickItem: (index) {
          if(index == 0)
            Navigator.pushNamed(context, '/notice');
          print("currentIndex:$index");
        },
        itemBuilder: (context, index) {
          return Image.network(
            imageUrlList[index],
            fit: BoxFit.fill,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
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
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.add,
                semanticLabel: 'add',
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/new-add');
                // print('add button');
              },
            ),
          ],
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
        body:StreamBuilder(
          stream: _log.orderBy('timestamp').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return
                ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 30, 20),
                      child:
                      Row(
                        children: const [
                          Text(
                            'trip',
                            style: TextStyle(
                              color: Color(0xFFffcdd2),
                              fontSize: 30,
                            ),
                          ),
                          Text(
                            '로그',
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 30,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 0, 20),
                      child:
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "다른 사람들의 여행 로그들을 살펴보세요!",
                          style: TextStyle(
                              color: Colors.black26,
                              fontSize: 13,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),

                    GridView.builder(
                      physics: const ScrollPhysics(),
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
                    ),
                    const SizedBox(height: 30),
                  ],
                );

            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        )
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
            backgroundColor: const Color(0xFFffebee),
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
                      Navigator.pushNamed(context, '/album');
                      // Navigator.pushNamed(context, '/앨범사진추가하는 페이지');
                    },
                    style: TextButton.styleFrom(
                      foregroundColor:  const Color(0xFFe57373),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    child: const Text("앨범 사진 추가하기"),
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
                      Navigator.pushNamed(context, '/new-add');
                    },
                    style: TextButton.styleFrom(
                      foregroundColor:  Color(0xFFe57373),
                      textStyle: const TextStyle(fontSize: 20,),
                    ),
                    child: const Text("로그 추가하기"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class BackgrounBlurView extends StatelessWidget {
  final String imageUrl;
  BackgrounBlurView({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        height: 200,
        width: MediaQuery.of(context).size.width,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
      BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            color: Colors.black.withOpacity(0.1),
            height: 200,
            width: MediaQuery.of(context).size.width,
          ))
    ]);
  }
}
class logMessage {
  logMessage({required this.id, required this.likes, required this.name, required this.title, required this.img_url, required this.message, required this.timestamp, required this.userId});
  final String id;
  final int likes;
  final String name;
  final String title;
  final String img_url;
  final String message;
  final DateTime timestamp;
  final String userId;
}

