import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:gojo/pages/login_page.dart';
import 'package:gojo/main.dart';
import 'package:gojo/pages/bottom_pages/add_page.dart';
import 'package:gojo/pages/bottom_pages/home_page.dart';
import 'package:gojo/pages/bottom_pages/calendar_page.dart';
import 'package:iconly/iconly.dart';

void signOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  } catch (e) {
    print('Error signing out: $e');
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  List<Widget> tabItems = [
    const HomePage(),
    AddPage(),
    const CalendarPage(),
  ];

  @override
  Widget build(BuildContext context) {
    // final keyboardHeight = ;
    return Scaffold(
      body: tabItems[_selectedIndex],
      backgroundColor:
          MyColors().color2, // Ensure MyColors().color1 is correctly defined
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: _selectedIndex,
        backgroundColor: Colors.black,
        // showElevation: true,
        iconSize: 28,
        animationCurve: Curves.easeInSine,
        onItemSelected: (index) => setState(() {
          _selectedIndex = index;
        }),
        items: [
          FlashyTabBarItem(
            icon: const Icon(
              IconlyBold.home,
              color: Colors.white,
            ),
            title: const Text(
              'Home',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          FlashyTabBarItem(
            icon: const Icon(
              IconlyBold.plus,
              color: Colors.white,
            ),
            title: const Text(
              'Add Note',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          FlashyTabBarItem(
            icon: const Icon(
              IconlyBold.calendar,
              color: Colors.white,
            ),
            title: const Text(
              'Calendar',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
