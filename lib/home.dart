import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
// import 'src/authentication.dart';
import 'src/widgets.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                          Navigator.pushNamed(context, '/');
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
      body: ListView(
        children: <Widget>[
          // Image.asset('assets/codelab.png'),
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
          Consumer<ApplicationState>(
            builder: (context, appState, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // if (appState.attendees >= 2)
                //   Paragraph('${appState.attendees} people going')
                // else if (appState.attendees == 1)
                //   const Paragraph('1 person going')
                // else
                //   const Paragraph('No one going'),
                if (appState.loggedIn) ...[
                  // YesNoSelection(
                  //   state: appState.attending,
                  //   onSelection: (attending) => appState.attending = attending,
                  // ),
                  const Header('Discussion'),
                  GuestBook(
                    messages: appState.guestBookMessages,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
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
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

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

  Future<void> updateMessageToGuestBook(String newMessageId, String newMessageName,  String newMessageTitle, String newMessageImgURL, String newMessageMessage, DateTime newMessageTime, String newMessageUserId) {
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
  GuestBookMessage({required this.id, required this.name, required this.title, required this.img_url, required this.message, required this.timestamp, required this.userId});
  final String id;
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
                      child: Text(DateFormat('yy/MM/dd - HH:mm:ss.SS').format(message.timestamp)),
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
}

class Argument {
  String id;
  String name;
  String title;
  String img_url;
  String message;
  DateTime timestamp;
  String userId;

  Argument(this.id, this.name, this.title, this.img_url, this.message, this.timestamp, this.userId);
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
