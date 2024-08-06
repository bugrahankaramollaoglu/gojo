import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gojo/home_page.dart';
import 'package:gojo/login_page.dart';

class MyColors {
  Color color1 = const Color(0xFF0a0d16);
  Color color2 = const Color(0xFFABD98B);
  Color color3 = const Color(0xFF84BF5A);
  Color color4 = const Color(0xFF55A603);
  Color color5 = const Color(0xFF18181A);
  Color color6 = const Color(0xF2F2F2F2);
  Color color7 = const Color(0xF25CCC60);
  Color color8 = const Color(0xF23D3F3D);
  Color color9 = const Color(0xF255A603);
  Color color10 = const Color(0xF200EC6D);
  Color color11 = const Color(0xF2999494);
  Color color12 = const Color(0xF2F3EEEE);
}

/* Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MyApp(),
  );
} */

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;

  runApp(GojoApp(initialPage: user == null ? const LoginPage() : const HomePage()));
}

class GojoApp extends StatelessWidget {
  final Widget initialPage;

  const GojoApp({super.key, required this.initialPage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showSemanticsDebugger: false,
      debugShowCheckedModeBanner: false,
      title: 'Gojo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: initialPage,
    );
  }
}
