import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  void _saveNote() {
    final title = _titleController.text;
    final description = _descriptionController.text;

    // Save note logic here

    // Show a Snackbar as feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Note saved successfully!')),
    );

    // Clear the fields and go back
    _titleController.clear();
    _descriptionController.clear();
    Navigator.pop(context);
  }

  DateTime? _selectedDateTime;

  // Function to show the date and time picker dialog
  Future<void> _selectDateTime(BuildContext context) async {
    // Show date picker
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      // Show time picker
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        // Combine date and time
        final selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          _selectedDateTime = selectedDateTime;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Positioned(
            top: -275,
            left: -200,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withOpacity(0.4),
              ),
            ),
          ),
          GestureDetector(
            child: Positioned(
              top: 40,
              left: 10,
              child: Image.asset(
                'assets/back_trunk.png',
                width: 100,
                height: 100,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Positioned(
            bottom: -200,
            right: -250,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.pink.withOpacity(0.4),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 150),
                Text(
                  'Title of Note',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                ),
                SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  child: TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(16),
                      hintText: 'Enter the title of your note...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Deadline & Category',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                ),
                SizedBox(height: 10),
                // Fixed Row Layout
                Row(
                  children: [
                    Expanded(
                      flex: 2, // 2 parts of the width
                      child: GestureDetector(
                        onTap: () => _selectDateTime(context),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Icon(
                              Icons.calendar_month_rounded,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16), // Add spacing between cards
                    Expanded(
                      flex: 4, // 4 parts of the width
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Icon(
                            Icons.category_rounded,
                            size: 45,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Note Description',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                ),
                SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  child: TextField(
                    controller: _descriptionController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(16),
                      hintText: 'Enter the description of your note...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: _saveNote,
                    child: Text(
                      'Save Note',
                      style: GoogleFonts.kreon(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
