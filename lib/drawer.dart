import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DrawerCustom extends StatefulWidget {

  @override
  _DrawerCustomState createState() => _DrawerCustomState();
}

class _DrawerCustomState extends State<DrawerCustom> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
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
                        Navigator.pushNamed(context, '/album');
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
                        Navigator.pushNamed(context, '/coin');
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
    );
  }

}