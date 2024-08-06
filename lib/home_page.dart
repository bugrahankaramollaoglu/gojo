import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gojo/login_page.dart';

Future<void> signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
    print('User signed out successfully');
  } catch (e) {
    print('Error signing out: $e');
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink,
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await signOut();
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          },
          child: const Text('Sign out'),
        ),
      ),
    );
  }
}
