import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:gojo/login/login_page.dart';
import 'package:gojo/main.dart';
import 'package:gojo/pages/add_page.dart';
import 'package:gojo/pages/home_page.dart';
import 'package:gojo/pages/calendar_page.dart';
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
  MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  List<Widget> tabItems = [
    HomePage(),
    AddPage(),
    CalendarPage(),
  ];

  @override
  Widget build(BuildContext context) {
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
            icon: Icon(
              IconlyBold.home,
              color: Colors.white,
            ),
            title: Text(
              'Home',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          FlashyTabBarItem(
            icon: Icon(
              IconlyBold.plus,
              color: Colors.white,
            ),
            title: Text(
              'Add Note',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          FlashyTabBarItem(
            icon: Icon(
              IconlyBold.calendar,
              color: Colors.white,
            ),
            title: Text(
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
