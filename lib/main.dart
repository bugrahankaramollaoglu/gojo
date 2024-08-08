import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gojo/main_page.dart';
import 'package:gojo/login/login_page.dart';

class MyColors {
  Color color1 = const Color(0xFF191919);
  Color color2 = const Color(0xFF1c1c1e);
  Color color3 = const Color.fromARGB(255, 30, 30, 31);
  Color color4 = const Color.fromARGB(255, 84, 89, 106);
  Color color5 = const Color(0xFF0a0d16);
  // backgroundColor: const Color.fromARGB(255, 25, 25, 25),
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;

  runApp(
    ProviderScope(
      child: GojoApp(
        initialPage: user == null ? LoginPage() : const MainPage(),
      ),
    ),
  );
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
