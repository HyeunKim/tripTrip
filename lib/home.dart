import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'login.dart';
import 'src/widgets.dart';
import 'package:intl/intl.dart';
import 'drawer.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  Future _signOut()  async{
    await FirebaseAuth.instance.signOut();
  }

  final currentUser = FirebaseAuth.instance;
  final CollectionReference _guestbook =
  FirebaseFirestore.instance.collection('guestbook');

  @override
  Widget build(BuildContext context) {
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
        stream: _guestbook.orderBy('timestamp').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              itemCount: snapshot.data!.docs.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 8 / 9,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16),
              itemBuilder: (BuildContext context, int index) {
                final DocumentSnapshot documentSnapshot =
                snapshot.data!.docs[index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 10 / 5,
                        child:
                        documentSnapshot['img_url'] == 'https://ichef.bbci.co.uk/news/640/cpsprodpb/14C73/production/_121170158_planepoogettyimages-1135673520.jpg'
                            ? Image.network('https://ichef.bbci.co.uk/news/640/cpsprodpb/14C73/production/_121170158_planepoogettyimages-1135673520.jpg')
                            :
                        Image.file(
                          File(documentSnapshot['img_url']),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                              16.0, 12.0, 16.0, 0.0),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(documentSnapshot['name']),
                                ],
                              ),
                              SizedBox(
                                height: 25,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      style: const ButtonStyle(
                                        alignment:
                                        Alignment.topRight,
                                      ),
                                      onPressed: () {
                                        print("documnet id가");
                                        print(documentSnapshot.id);
                                        print("detail 페이지로 이동");
                                        print(documentSnapshot['text']);
                                        // print(DateFormat('yy/MM/dd - HH:mm:ss.SS').parse(documentSnapshot['timestamp'].toString()));

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
                                      child: const Align(
                                          alignment:
                                          Alignment.topRight,
                                          child: Text(
                                            'more',
                                            style: TextStyle(
                                              fontSize: 10.0,
                                            ),
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
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
                        // Navigator.pushNamed(context, '/앨범사진추가하는 페이지');
                      },
                      style: TextButton.styleFrom(
                        foregroundColor:  Color(0xFFe57373),
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


class UserId {
  late final String user_id;
}

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  int _attendees = 0;
  int get attendees => _attendees;

  Attending _attending = Attending.unknown;
  StreamSubscription<DocumentSnapshot>? _attendingSubscription;
  Attending get attending => _attending;
  set attending(Attending attending) {
    final userDoc = FirebaseFirestore.instance
        .collection('attendees')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    if (attending == Attending.yes) {
      userDoc.set(<String, dynamic>{'attending': true});
    } else {
      userDoc.set(<String, dynamic>{'attending': false});
    }
  }

  StreamSubscription<QuerySnapshot>? _guestBookSubscription;
  List<GuestBookMessage> _guestBookMessages = [];
  List<GuestBookMessage> get guestBookMessages => _guestBookMessages;

  Future<void> init() async {
    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseFirestore.instance
        .collection('attendees')
        .where('attending', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      _attendees = snapshot.docs.length;
      notifyListeners();
    });

    FirebaseAuth.instance.userChanges().listen((user) {
      // print(user);
      if (user != null) {
        _loggedIn = true;
        _guestBookSubscription = FirebaseFirestore.instance
            .collection('guestbook')
            .orderBy('timestamp', descending: true)
            .snapshots()
            .listen((snapshot) {
          _guestBookMessages = [];
          for (final document in snapshot.docs) {
            _guestBookMessages.add(
              GuestBookMessage(
                id: document.id,
                likes: document.data()['likes'] as int,
                name: document.data()['name'] as String,
                title: document.data()['title'] as String,
                img_url: document.data()['img_url'] as String,
                message: document.data()['text'] as String,
                userId: document.data()['userId'] as String,
                // timestamp:
                timestamp: DateTime.fromMillisecondsSinceEpoch(document.data()['timestamp']),
              ),
            );
          }
          notifyListeners();
        });
        _attendingSubscription = FirebaseFirestore.instance
            .collection('attendees')
            .doc(user.uid)
            .snapshots()
            .listen((snapshot) {
          if (snapshot.data() != null) {
            if (snapshot.data()!['attending'] as bool) {
              _attending = Attending.yes;
            } else {
              _attending = Attending.no;
            }
          } else {
            _attending = Attending.unknown;
          }
          notifyListeners();
        });
      } else {
        _loggedIn = false;
        _guestBookMessages = [];
        _guestBookSubscription?.cancel();
      }
      notifyListeners();
    });
  }

  Future<DocumentReference> addMessageToGuestBook(String title, String message) {
    if (!_loggedIn) {
      throw Exception('Must be logged in ');
    }

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
    if (!_loggedIn) {
      throw Exception('Must be logged in ');
    }

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

  Future<void> updateMessageToGuestBook(String newMessageId, int newMessageLikes, String newMessageName,  String newMessageTitle, String newMessageImgURL, String newMessageMessage, DateTime newMessageTime, String newMessageUserId) {
    if (!_loggedIn) {
      throw Exception('Must be logged in ');
    }

    // var id = FirebaseFirestore.instance.collection('guestbook').doc(message).id;

    return FirebaseFirestore.instance
        .collection('guestbook')
        .doc(newMessageId)
        .update(<String, dynamic>{
      'text': newMessageMessage,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      // 'name': newMessage_name,
      // 'userId': newMessage_userId,
    });

    // var id = FirebaseFirestore.instance.collection('guestbook').doc(message).id;
    //
    // // print(id);
    //
    // return FirebaseFirestore.instance
    //     .collection('guestbook')
    //     .doc(id)
    //     .update(<String, dynamic>{
    //   'text': message,
    //   'timestamp': DateTime.now().millisecondsSinceEpoch,
    // });

    // CollectionReference guestbook = FirebaseFirestore.instance.collection('guestbook');
    // return guestbook
    //     .doc(update)
    //     .update({
    //   'text': message,
    // });

    // return FirebaseFirestore.instance.collection('guestbook').doc(message.id)
    //     .update({
    //   'text': message,
    // });
    //
    //   FirebaseFirestore.instance
    //     .collection('guestbook')
    //     .update({
    //   'text': message,
    //   // 'timestamp': DateTime.now().millisecondsSinceEpoch,
    //   // 'name': FirebaseAuth.instance.currentUser!.displayName ==null? 'anoy' : FirebaseAuth.instance.currentUser!.displayName,
    //   // 'userId': FirebaseAuth.instance.currentUser!.uid,
    // });
  }
}

class GuestBookMessage {
  GuestBookMessage({required this.id, required this.likes, required this.name, required this.title, required this.img_url, required this.message, required this.timestamp, required this.userId});
  final String id;
  final int likes;
  final String name;
  final String title;
  final String img_url;
  final String message;
  final DateTime timestamp;
  final String userId;
}

enum Attending { yes, no, unknown }

class GuestBook extends StatefulWidget {
  const GuestBook({super.key, required this.messages,});
  final List<GuestBookMessage> messages; // new

  @override
  _GuestBookState createState() => _GuestBookState();
}

class _GuestBookState extends State<GuestBook> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_GuestBookState');
  final _controller = TextEditingController();

  final user_id = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        for (var message in widget.messages)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Paragraph('${message.name}: ${message.message}'), // ${message.id},
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: Text('')//DateFormat('yy/MM/dd - HH:mm:ss.SS').format(message.timestamp)),
                    ),
                  ],
                ),
              ),
              if(message.userId == user_id)
                Row(
                  children: [
                    IconButton(
                        onPressed: (){
                          Navigator.pushNamed(context, '/update',
                          arguments: Argument(
                              message.id,
                              message.likes,
                              message.name,
                              message.title,
                              message.img_url,
                              message.message,
                              message.timestamp,
                              message.userId
                          )
                          );
                          // CollectionReference guestbook = FirebaseFirestore.instance.collection('guestbook');
                          //
                          // guestbook
                          //     .doc(message.id)
                          //     .update({
                          // 'text': message,
                          // });
                        },
                        icon: const Icon(Icons.edit)
                    ),
                    IconButton(
                        onPressed: (){
                          CollectionReference guestbook = FirebaseFirestore.instance.collection('guestbook');

                          guestbook
                              .doc(message.id)
                              .delete();
                        },
                        icon: const Icon(Icons.delete_outline)

                    ),
                  ],
                ),

            ],
          ),
        const SizedBox(height: 8),
      ],
    );
  }

  // void flutterDialog(BuildContext context) {
  //   showDialog(
  //       context: context,
  //       //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
  //       // barrierDismissible: false,
  //       builder: (BuildContext context) {
  //
  //
  //         return SizedBox(
  //           width: 50,
  //           child: AlertDialog(
  //
  //             // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(15.0)),
  //             //Dialog Main Title
  //             // title: Column(
  //             //   children: <Widget>[
  //             //     new Text("Dialog Title"),
  //             //   ],
  //             // ),
  //             //
  //             content: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: <Widget>[
  //                 Center(
  //                   child: TextButton(
  //                     onPressed: () {
  //                       // imgFromCamera();
  //
  //                       Navigator.pushNamed(context, '/temp-add');
  //                       // Navigator.pop(context);
  //                     },
  //                     style: TextButton.styleFrom(
  //                       foregroundColor:  Colors.black54,
  //                       textStyle: const TextStyle(fontSize: 20,),
  //                     ),
  //                     child: const Text("카메라"),
  //                   ),
  //                 ),
  //
  //                 const Divider(
  //                   height: 8,
  //                   thickness: 2,
  //                   indent: 8,
  //                   endIndent: 8,
  //                   color: Color(0xFFffcdd2),
  //                 ),
  //                 Center(
  //                   child: TextButton(
  //                     onPressed: () {
  //                       Navigator.pop(context);
  //                     },
  //                     style: TextButton.styleFrom(
  //                       foregroundColor:  Colors.black54,
  //                       textStyle: const TextStyle(fontSize: 20,),
  //                     ),
  //                     child: const Text("갤러리"),
  //                   ),
  //                 ),
  //                 // Text(
  //                 //   "Dialog Content",
  //                 // ),
  //               ],
  //             ),
  //             // actions: <Widget>[
  //             //   TextButton(
  //             //     child: new Text("확인"),
  //             //     onPressed: () {
  //             //       Navigator.pop(context);
  //             //     },
  //             //   ),
  //             // ],
  //           ),
  //         );
  //       });
  // }

}

class Argument {
  String id;
  int likes; //
  String name;//
  String title;//
  String img_url;//
  String message;//
  DateTime timestamp;//
  String userId;//

  Argument(this.id, this.likes, this.name, this.title, this.img_url, this.message, this.timestamp, this.userId);
}

class GuestBook3 extends StatefulWidget {
  const GuestBook3({super.key, required this.updateMessage});
  final FutureOr<void> Function(String message) updateMessage;

  @override
  _GuestBookState3 createState() => _GuestBookState3();
}

class _GuestBookState3 extends State<GuestBook3> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_GuestBookState3');
  final _controller = TextEditingController();

  final user_id = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Leave a message',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your message to continue';
                      }
                      return null;
                    },
                    // onChanged: (value) {
                    //   if(value.isNotEmpty) _controller.text = value;
                    // },
                  ),
                ),
                const SizedBox(width: 8),
                StyledButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await widget.updateMessage(_controller.text);
                      _controller.clear();
                    }
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.send),
                      SizedBox(width: 4),
                      Text('UPDATE'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),

      ],
    );
  }
}

class YesNoSelection extends StatelessWidget {
  const YesNoSelection(
      {super.key, required this.state, required this.onSelection});
  final Attending state;
  final void Function(Attending selection) onSelection;

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case Attending.yes:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(elevation: 0),
                onPressed: () => onSelection(Attending.yes),
                child: const Text('YES'),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () => onSelection(Attending.no),
                child: const Text('NO'),
              ),
            ],
          ),
        );
      case Attending.no:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              TextButton(
                onPressed: () => onSelection(Attending.yes),
                child: const Text('YES'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(elevation: 0),
                onPressed: () => onSelection(Attending.no),
                child: const Text('NO'),
              ),
            ],
          ),
        );
      default:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              StyledButton(
                onPressed: () => onSelection(Attending.yes),
                child: const Text('YES'),
              ),
              const SizedBox(width: 8),
              StyledButton(
                onPressed: () => onSelection(Attending.no),
                child: const Text('NO'),
              ),
            ],
          ),
        );
    }
  }
}

