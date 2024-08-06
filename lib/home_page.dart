import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gojo/deneme.dart';
import 'package:gojo/login_page.dart';

Future<void> signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
    print('User signed out successfully');
  } catch (e) {
    print('Error signing out: $e');
  }
}

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Track the selected index
  Widget currentBody = Container(
    child: Center(
      child: Text(
        'Home Page',
        style: TextStyle(
          color: Colors.white,
          fontSize: 30,
        ),
      ),
    ),
  );

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        currentBody = Container(
          child: Center(
            child: Text(
              'Home Page',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          ),
        );
      } else if (index == 1) {
        setState(() {
          currentBody = Page1();
        });
      } else if (index == 2) {
        setState(() {
          currentBody = Page2();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 25, 25, 25),
      body: currentBody,
      bottomNavigationBar: BottomNav(
        selectedIndex: _selectedIndex, // Pass the selected index
        onItemTapped: _onItemTapped, // Pass the function to handle taps
      ),
    );
  }
}
