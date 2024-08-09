import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(28.0, 28, 28, 20),
                child: Icon(
                  Icons.menu,
                  size: 30,
                  color: Colors.white70,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(28.0, 28, 28, 20),
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage(
                    'assets/crown.png',
                  ),
                ),
              ),
            ],
          ),
          Image.asset('assets/gojo_dark.png', height: 200),
          searchText(_searchController),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Your Notes',
                style: GoogleFonts.kreon(
                  color: Colors.white70,
                  fontSize: 25,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'All',
                  style: GoogleFonts.kreon(
                    fontSize: 25,
                    color: Color.fromARGB(255, 218, 214, 214),
                  ),
                ),
              ),
              categoryCard('Red', const Color.fromARGB(255, 206, 105, 98)),
              categoryCard('Green', Color.fromARGB(255, 85, 146, 87)),
              categoryCard('Blue', Color.fromARGB(255, 87, 128, 161)),
              Icon(
                (Icons.sort_rounded),
                color: Colors.white,
                size: 35,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget categoryCard(String name, Color color) {
  return Card(
    elevation: 5, // Adjust elevation for shadow effect
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15), // Rounded corners
    ),
    // Spacing around the card
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 5), // Padding inside the card
      decoration: BoxDecoration(
        color: color,
        borderRadius:
            BorderRadius.circular(10), // Match the card's rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Text(
          name,
          style: GoogleFonts.kreon(
            fontSize: 22,
            color: Colors.black87, // Text color to stand out
          ),
        ),
      ),
    ),
  );
}

Widget searchText(TextEditingController searchController) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
    child: TextField(
      controller: searchController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.transparent,
        hintText: 'Search a note...',
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 18,
          fontWeight: FontWeight.normal,
        ),
        suffixIcon: const Icon(
          Icons.search,
          color: Colors.white70,
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white70),
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    ),
  );
}
