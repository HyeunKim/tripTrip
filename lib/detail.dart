import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:intl/intl.dart';
import 'home.dart';
import 'drawer.dart';
import 'src/widgets.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
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
  Widget build(BuildContext context) {
    final Argument oneContents =
        ModalRoute.of(context)!.settings.arguments as Argument;
    final currentUser = FirebaseAuth.instance;
    final CollectionReference rep = FirebaseFirestore.instance
        .collection('guestbook')
        .doc(oneContents.id)
        .collection('reply');
    final CollectionReference likeCol =
        FirebaseFirestore.instance.collection(oneContents.id);
    int likes = oneContents.likes;

    final formKey = GlobalKey<FormState>(debugLabel: '_GuestBookState');
    final controller = TextEditingController();

    Future addlikes() async {
      CollectionReference newDoc =
          FirebaseFirestore.instance.collection(oneContents.id);
      final json = {'like': true};
      await newDoc.doc(currentUser.currentUser!.uid).set(json);
      await FirebaseFirestore.instance
          .collection('guestbook')
          .doc(_id)
          .update(<String, dynamic>{'likes': likes + 1});
    }

    Future addReplAnoy(String? repl) async {
      final json = {
        'reply': repl,
        'name': 'anoy',
        'timestamp': DateFormat.yMd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch).toLocal())
      };
      await rep.add(json);
    }

    Future addRepl(String? repl) async {
      final json = {
        'reply': repl,
        'name':currentUser.currentUser?.displayName,
        'timestamp': DateFormat.yMd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch).toLocal())
      };
      await rep.add(json);
    }

    Future deletelikes() async {
      CollectionReference newDoc =
          FirebaseFirestore.instance.collection(oneContents.id);
      await newDoc.doc(currentUser.currentUser!.uid).delete();
      await FirebaseFirestore.instance
          .collection('guestbook')
          .doc(_id)
          .update(<String, dynamic>{'likes': likes});
    }

    setState(() {
      _id = oneContents.id;
      _title = oneContents.title;
      _content = oneContents.message;
      _image = oneContents.img_url;
      _likes = oneContents.likes;
      _date = oneContents.timestamp;
      _userId = oneContents.userId;
      _name = oneContents.name;
      _real_date = DateFormat('yyyy년 MM월 dd일').format(
          _date!); // DateFormat('yyyy년 MM월 dd일 HH:mm:ss').format(_date!);
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
        drawer: DrawerCustom(),
        body: StreamBuilder(
            stream: likeCol.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) _likes = snapshot.data!.docs.length;
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 30, 20),
                        child: Row(
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
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      if (_userId == user_id)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/update',
                                      arguments: Argument(
                                          _id!,
                                          _likes!,
                                          _name!,
                                          _title!,
                                          _image!,
                                          _content!,
                                          _date!,
                                          _userId!));
                                },
                                child: const Text(
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: Color(0xFFffcdd2)),
                                    "편집"),
                                // icon: const Icon(Icons.edit, color: Color(0xFFef9a9a))
                              ),
                              // const SizedBox(width: 0),
                              TextButton(
                                onPressed: () {
                                  flutterDialog(context);
                                  // Navigator.pop(context);
                                },
                                child: const Text(
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: Color(0xFFffcdd2)),
                                    "삭제"),
                                // icon: const Icon(Icons.delete_outline, color: Color(0xFFef9a9a))
                              ),
                            ],
                          ),
                        ),
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
                              padding:
                                  const EdgeInsets.fromLTRB(275, 20, 10, 0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: _likes == likes ? const Icon(Icons.favorite_border) : const Icon(Icons.favorite),
                                      color: const Color(0xFFffcdd2),
                                      onPressed: () {
                                        if (_likes == likes) {
                                          addlikes();
                                        } else {
                                          deletelikes();
                                        }
                                      },
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                        style: const TextStyle(
                                            fontSize: 20.0,
                                            color: Color(0xFFffcdd2)),
                                        _likes.toString()),
                                  ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(35, 0, 30, 25),
                              child: Text(
                                  style: const TextStyle(
                                      fontSize: 30.0, color: Color(0xFFef9a9a)),
                                  _title!),
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
                              padding:
                                  const EdgeInsets.fromLTRB(220, 0, 10, 10),
                              child: Column(
                                children: [
                                  Text(
                                      style: const TextStyle(
                                          fontSize: 15.0,
                                          color: Color(0xFFffcdd2)),
                                      _real_date!),
                                  Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 10, 10, 15),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Text(
                                            style: const TextStyle(
                                                fontSize: 15.0,
                                                color: Color(0xFFffcdd2)),
                                            _name!),
                                      )),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                              child: SizedBox(
                                width: double.infinity,
                                child: Image.network(_image!),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                              child: Text(
                                  style: const TextStyle(
                                      fontSize: 23.0, color: Colors.black54),
                                  _content!),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                      StreamBuilder(
                          stream: rep.orderBy('timestamp').snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot> snapshot2) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Form(
                                    key: formKey,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller: controller,
                                            decoration: const InputDecoration(
                                              hintText: 'Leave a comment',
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Enter your comment to continue';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        StyledButton(
                                          onPressed: () async {
                                            if (formKey.currentState!
                                                .validate()) {
                                              if(currentUser.currentUser?.displayName==null)
                                                await addReplAnoy(controller.text);
                                              else
                                                await addRepl(controller.text);
                                              controller.clear();
                                            }
                                          },
                                          child: Row(
                                            children: const [
                                              Text(
                                                'SEND',
                                                style: TextStyle(
                                                    color: Color(0xFFef9a9a)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                snapshot2.hasData
                                    ? ListView.builder(
                                  shrinkWrap: true,
                                        itemCount: snapshot2.data!.docs.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final DocumentSnapshot
                                              documentSnapshot =
                                              snapshot2.data!.docs[index];
                                          return ListTile(
                                            title: Paragraph('${documentSnapshot['name']}: ${documentSnapshot['reply']}'),
                                              subtitle: Paragraph('${documentSnapshot['timestamp']}'),
                                          );
                                        })
                                    : const Center(
                                        child: CircularProgressIndicator(),
                                      )
                              ],
                            );
                          })
                    ]),
              );
            }));
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
                  CollectionReference guestbook =
                      FirebaseFirestore.instance.collection('guestbook');

                  guestbook.doc(_id).delete();
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
