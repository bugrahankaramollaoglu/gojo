import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gojo/main_page.dart';
import 'package:gojo/riverpod_providers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:shimmer_effect/shimmer_effect.dart';

class AddPage extends ConsumerWidget {
  AddPage({super.key});

//   @override
//   State<AddPage> createState() => _AddPageState();
// }

// class _AddPageState extends State<AddPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

/*   void _saveNote() {
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
    // Navigator.pop(context);
  } */

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

        /*  setState(() {
          _selectedDateTime = selectedDateTime;
        }); */
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isRecordedChosen = ref.watch(recordedNoteChosen);

    return Container(
      child: Stack(
        children: [
          Positioned(
            top: -250,
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
          Positioned(
            top: 45,
            left: 10,
            child: GestureDetector(
              onTap: null,
              child: Image.asset(
                'assets/back_trunk.png',
                width: 100,
                height: 100,
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            right: -250,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.teal.withOpacity(0.5),
              ),
            ),
          ),
          Positioned(
              top: 80,
              right: 25,
              child: Row(
                children: [
                  ShimmerEffect(
                    baseColor: Colors.white,
                    highlightColor: Colors.white54,
                    loop: 1,
                    child: GestureDetector(
                      onTap: () {
                        if (ref.read(recordedNoteChosen.notifier).state) {
                          ref.read(recordedNoteChosen.notifier).state =
                              !ref.read(recordedNoteChosen);
                        }
                      },
                      child: Column(
                        children: [
                          Text(
                            'Write',
                            style: GoogleFonts.kreon(
                              color: isRecordedChosen
                                  ? Colors.white70
                                  : Colors.white,
                              fontSize: 25,
                              fontWeight: isRecordedChosen
                                  ? FontWeight.w100
                                  : FontWeight.bold,
                            ),
                          ),
                          Icon(
                            IconlyBold.paper,
                            color: isRecordedChosen
                                ? Colors.white70
                                : Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'or',
                      style: GoogleFonts.kreon(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (!ref.read(recordedNoteChosen)) {
                        ref.read(recordedNoteChosen.notifier).state =
                            !ref.read(recordedNoteChosen);
                      }
                    },
                    child: ShimmerEffect(
                      baseColor: Colors.white,
                      highlightColor: Colors.white54,
                      loop: 1,
                      child: Column(
                        children: [
                          Text(
                            'Record',
                            style: GoogleFonts.kreon(
                              color: isRecordedChosen
                                  ? Colors.white
                                  : Colors.white70,
                              fontSize: 25,
                              fontWeight: isRecordedChosen
                                  ? FontWeight.bold
                                  : FontWeight.w100,
                            ),
                          ),
                          Icon(
                            IconlyBold.voice_2,
                            color: isRecordedChosen
                                ? Colors.white
                                : Colors.white70,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 150),
                Text(
                  'Title of Note (*)',
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
                    onPressed: () {
                      // signOut(context);
                      // _saveNote();
                      print('isRecordedChosen: $isRecordedChosen');
                    },
                    child: ShimmerEffect(
                      baseColor: Colors.white,
                      highlightColor: Colors.blue,
                      loop: 5,
                      child: Text(
                        'Save Note',
                        style: GoogleFonts.kreon(
                          color: Colors.white,
                          fontSize: 20,
                        ),
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
