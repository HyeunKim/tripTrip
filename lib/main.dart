import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';                 // new
import 'app.dart';
import 'home.dart';
import 'login.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   // 옵션 설정도 중요
  //   // options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: ((context, child) => const App()),

  ));
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(App());
//   // runApp(ChangeNotifierProvider(
//   //   create: (context) => ApplicationState(),
//   //   builder: ((context, child) => const App()),
//   // ));
// }