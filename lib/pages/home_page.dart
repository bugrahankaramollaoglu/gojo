import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(28.0, 28, 28, 20),
                child: Icon(
                  Icons.menu,
                  size: 30,
                  color: Colors.white70,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28.0, 28, 28, 20),
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.transparent,
                  backgroundImage: const AssetImage(
                    'assets/crown.png',
                  ),
                ),
              ),
            ],
          ),
          Image.asset('assets/gojo_dark.png', height: 220),
          Text(
            'A simple way to remember',
            style: GoogleFonts.kreon(
              color: Colors.white70,
              fontSize: 27,
            ),
          ),
          const SizedBox(height: 30),
          searchText(_searchController),
        ],
      ),
    );
  }
}

Widget searchText(TextEditingController _searchController) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
    child: TextField(
      controller: _searchController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.transparent,
        hintText: 'Search a note or task...',
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 18,
          fontWeight: FontWeight.normal,
        ),
        suffixIcon: Icon(
          Icons.search,
          color: Colors.white70,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white70),
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    ),
  );
}
