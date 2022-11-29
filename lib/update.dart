import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home.dart';

class UpdatePage extends StatelessWidget {
  // const ProfilePage({required List providers, required List<SignedOutAction> actions});
  const UpdatePage();

  @override
  Widget build(BuildContext context) {

    final Argument mess = ModalRoute.of(context)!.settings.arguments as Argument;

    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: const Icon(
        //     Icons.person,
        //     semanticLabel: 'person',
        //   ),
        //   onPressed: () {
        //     print('person button');
        //   },
        // ),
        title: const Text('update!!'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.exit_to_app,
              semanticLabel: 'logout',
            ),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (FirebaseAuth.instance.currentUser == null) {
                Navigator.pushNamed(context, '/sign-in');
              }
              // Navigator.pushNamed(context, '/sign-in');
              // print('logout button');
            },
          ),
        ],
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
                  GuestBook3(
                    updateMessage: (message) =>
                        appState.updateMessageToGuestBook(mess.id, mess.likes, mess.name, mess.title, mess.img_url, message, mess.timestamp, mess.userId),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
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