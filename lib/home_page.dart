import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gojo/main.dart';
import 'package:iconly/iconly.dart';

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
  int _selectedIndex = 0;

  Widget _getBody(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return Container(
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
      case 1:
        return Container(
          child: Center(
            child: Text(
              'Search Page',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          ),
        );
      case 2:
        return Container(
          child: Center(
            child: Text(
              'Add Page',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          ),
        );
      case 3:
        return Container(
          child: Center(
            child: Text(
              'Profile Page',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          ),
        );
      default:
        return Container();
    }
  }

  void _handleIndexChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 25, 25, 25),
      body: _getBody(_selectedIndex),
      bottomNavigationBar: CrystalNavigationBar(
        duration: const Duration(milliseconds: 500),
        currentIndex: _selectedIndex,
        height: 50,
        borderRadius: 15,
        splashBorderRadius: 15,
        indicatorColor: Colors.blue,
        backgroundColor: Colors.transparent,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _handleIndexChanged,
        enablePaddingAnimation: false,
        items: [
          CrystalNavigationBarItem(
            icon: IconlyBold.home,
            unselectedIcon: IconlyLight.home,
          ),
          CrystalNavigationBarItem(
            icon: IconlyBold.search,
            unselectedIcon: IconlyLight.search,
          ),
          CrystalNavigationBarItem(
            icon: IconlyBold.plus,
            unselectedIcon: IconlyLight.plus,
          ),
          CrystalNavigationBarItem(
            icon: IconlyBold.profile,
            unselectedIcon: IconlyLight.profile,
          ),
        ],
      ),
    );
  }
}
