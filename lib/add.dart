import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home.dart';
import 'guestBook2.dart';
import 'package:flutter/services.dart';

class AddPage extends StatelessWidget {
  // const ProfilePage({required List providers, required List<SignedOutAction> actions});
  const AddPage({super.key});


  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
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
      ),
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
                          style: TextStyle(fontSize: 50,color: Colors.white,fontWeight: FontWeight.w100))
                  ),
                  const Padding(padding: EdgeInsets.only(left: 40),
                      child:ListTile(
                        minLeadingWidth: 20,
                        leading: Text('/',style: TextStyle(fontSize: 50,color: Colors.white,fontWeight: FontWeight.w100)),
                        title: Text("MY",style: TextStyle(fontSize: 35,color: Color(0xffff8484),fontWeight: FontWeight.w300 ),),
                      )
                  ),
                  Padding(padding: const EdgeInsets.only(left: 40),
                      child:ListTile(
                        minLeadingWidth: 20,
                        leading: const Text('/',style: TextStyle(fontSize: 50,color: Colors.white,fontWeight: FontWeight.w100)),
                        title: RichText(text: const TextSpan(text: "trip",
                            style: TextStyle(fontSize: 35,color: Color(0xffff8484),fontWeight: FontWeight.w300),
                            children: <TextSpan>[TextSpan(text: '앨범', style: TextStyle(fontSize: 35,color: Colors.white,fontWeight: FontWeight.w300))])
                        ),
                      )
                  ),
                  Padding(padding: const EdgeInsets.only(left: 40),
                      child:ListTile(
                        minLeadingWidth: 20,
                        leading: const Text('/',style: TextStyle(fontSize: 50,color: Colors.white,fontWeight: FontWeight.w100)),
                        title: RichText(text: const TextSpan(text: "trip",
                            style: TextStyle(fontSize: 35,color: Color(0xffff8484),fontWeight: FontWeight.w300),
                            children: <TextSpan>[TextSpan(text: '로그', style: TextStyle(fontSize: 35,color: Colors.white,fontWeight: FontWeight.w300))])
                        ),

                      )
                  ),
                  Padding(padding: const EdgeInsets.only(left: 40),
                      child:ListTile(
                        minLeadingWidth: 20,
                        leading: const Text('/',style: TextStyle(fontSize: 50,color: Colors.white,fontWeight: FontWeight.w100)),
                        title: RichText(text: const TextSpan(text: "trip",
                            style: TextStyle(fontSize: 35,color: Color(0xffff8484),fontWeight: FontWeight.w300),
                            children: <TextSpan>[TextSpan(text: '코인', style: TextStyle(fontSize: 35,color: Colors.white,fontWeight: FontWeight.w300))])
                        ),
                      )
                  ),
                ],
              ),
            ),
            // This container holds the align
            Align(
                alignment: FractionalOffset.bottomCenter,
                // This container holds all the children that will be aligned
                // on the bottom and should not scroll with the above ListView
                child: Column(
                  children: const <Widget>[
                    ListTile(
                        title: Text('정보수정',style: TextStyle(fontSize: 35,color: Color(0xffff8484),fontWeight: FontWeight.w300))),
                  ],
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
                          // const Text(
                          //   'trip로그',
                          //   style: TextStyle(
                          //     // fontFamily: 'Quicksand',
                          //     color: Color(0xFFf8bbd0),
                          //     fontSize: 30,
                          //   ),
                          //
                          // ),
                          GuestBook2(
                            addMessage: (title, message) =>
                                appState.addMessageToGuestBook(title, message),
                            // addTitle: (title) =>
                            //     appState.addMessageToGuestBook(title),
                          ),
                        ],
                      ],
                    ),
                  ),

                ],
              ),
            ),

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
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor:  Colors.black54,
                          textStyle: const TextStyle(fontSize: 20,),
                        ),
                        child: const Text("이미지 수정"),
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
                        child: const Text("이미지 삭제"),
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