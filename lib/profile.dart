import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  // const ProfilePage({required List providers, required List<SignedOutAction> actions});
  const ProfilePage();

  @override
  Widget build(BuildContext context) {
    // TODO: Return an AsymmetricView (104)
    // TODO: Pass Category variable to AsymmetricView (104)
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
        // title: const Text('Detail'),
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
      body:
      Padding(
        padding: const EdgeInsets.all(40),
        child:
        Column(
          children: const [
            SizedBox(height: 10.0),

            Center(
              child: Text(
                'Hyeeun Kim',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 10.0),
            Center(
              child: Text(
                'I promise to take the test honestly before GOD .',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
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