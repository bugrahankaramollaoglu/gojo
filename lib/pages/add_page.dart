import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gojo/riverpod_providers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:shimmer_effect/shimmer_effect.dart';

final selectedDateTimeProvider = StateProvider<DateTime?>((ref) => null);
final selectedColorProvider = StateProvider<Color?>((ref) => null);

Widget colorPicker(BuildContext context, WidgetRef ref) {
  final selectedColor = ref.watch(selectedColorProvider);

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Choose a Color',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _colorOption(Colors.red, ref, selectedColor, context),
            const SizedBox(width: 10),
            _colorOption(Colors.blue, ref, selectedColor, context),
            const SizedBox(width: 10),
            _colorOption(Colors.green, ref, selectedColor, context),
          ],
        ),
        const SizedBox(height: 20),
        if (selectedColor != null)
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: selectedColor,
              shape: BoxShape.circle,
              border:
                  Border.all(color: Colors.black.withOpacity(0.5), width: 2),
            ),
            child: Center(
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 60,
              ),
            ),
          ),
      ],
    ),
  );
}

Widget _colorOption(
    Color color, WidgetRef ref, Color? selectedColor, BuildContext context) {
  final isSelected = color == selectedColor;

  return GestureDetector(
    onTap: () {
      ref.read(selectedColorProvider.notifier).state = color;
      Navigator.of(context).pop();
    },
    child: Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: isSelected ? Border.all(color: Colors.black, width: 2) : null,
      ),
      child: Center(
        child: isSelected
            ? Icon(
                Icons.check,
                color: Colors.white,
              )
            : null,
      ),
    ),
  );
}

Future<void> saveNote(BuildContext context, titleController,
    TextEditingController descriptionController, WidgetRef ref) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;

    final title = titleController.text;
    final description = descriptionController.text;
    final selectedDateTime = ref.read(selectedDateTimeProvider);
    final selectedCategory = ref.read(selectedColorProvider);

    var categoryName = '';

    DateTime timestamp = DateTime.now();

    if (selectedCategory == Colors.red) {
      categoryName = 'Red';
    } else if (selectedCategory == Colors.blue) {
      categoryName = 'Blue';
    } else if (selectedCategory == Colors.green) {
      categoryName = 'Green';
    }

    Map<String, dynamic> noteData = {
      'title': title,
      'deadline': selectedDateTime,
      'category': categoryName,
      'description': description,
      'userEmail': user?.email,
      'savedTime': timestamp,
    };

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title cannot be empty!')),
      );
      return;
    } else {
      await FirebaseFirestore.instance.collection('notes').add(noteData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note saved!')),
      );

      titleController.clear();
      descriptionController.clear();
      ref.read(selectedDateTimeProvider.notifier).state = null;
      ref.read(selectedColorProvider.notifier).state = null;
    }
  } catch (e) {
    print('Failed to save note: $e');
  }
}

Future<void> selectDateTime(BuildContext context, WidgetRef ref) async {
  final DateTime? initialDate = ref.read(selectedDateTimeProvider);
  final DateTime? selectedDate = await showDatePicker(
    context: context,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );

  if (selectedDate != null) {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate ?? DateTime.now()),
    );

    if (selectedTime != null) {
      final DateTime selectedDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );
      ref.read(selectedDateTimeProvider.notifier).state = selectedDateTime;
    }
  }
}

class AddPage extends ConsumerWidget {
  AddPage({super.key});

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isRecordedChosen = ref.watch(recordedNoteChosen);

    final selectedDateTime = ref.watch(selectedDateTimeProvider);

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
                color: Colors.teal.withOpacity(0.6),
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
                          color:
                              isRecordedChosen ? Colors.white70 : Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 30),
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
                          color:
                              isRecordedChosen ? Colors.white : Colors.white70,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            child: isRecordedChosen
                ? recordedNoteContent()
                : writtenNoteContent(
                    context,
                    _titleController,
                    _descriptionController,
                    isRecordedChosen,
                    selectedDateTime,
                    _monthName,
                    ref,
                  ),
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    return [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ][month - 1];
  }
}

Widget recordedNoteContent() {
  return Container(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'asd',
            style: GoogleFonts.kreon(
              color: Colors.white,
              fontSize: 30,
            ),
          ),
          Text(
            'asd',
            style: GoogleFonts.kreon(
              color: Colors.white,
              fontSize: 30,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget writtenNoteContent(
  BuildContext context,
  TextEditingController titleController,
  TextEditingController descriptionController,
  bool isRecordedChosen,
  DateTime? selectedDateTime,
  String Function(int) monthName,
  WidgetRef ref,
) {
  var selectedColor = ref.watch(selectedColorProvider);

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 150),
        Text(
          'Title of Note (*)',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
        ),
        const SizedBox(height: 10),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5,
          child: TextField(
            controller: titleController,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(16),
              hintText: 'Enter the title of your note...',
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Deadline & Category',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () {
                  selectDateTime(context, ref);
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: selectedDateTime == null
                        ? const Icon(
                            FontAwesomeIcons.bell,
                            size: 45,
                          )
                        : const Icon(
                            FontAwesomeIcons.solidBell,
                            size: 45,
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Select a category color  '),
                      content: colorPicker(context, ref),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: selectedColor == null
                        ? Icon(
                            Icons.color_lens_outlined,
                            size: 45,
                          )
                        : Icon(
                            Icons.color_lens,
                            size: 45,
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'Note Description',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
        ),
        const SizedBox(height: 10),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5,
          child: TextField(
            controller: descriptionController,
            maxLines: 5,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(16),
              hintText: 'Enter the description of your note...',
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 30),
        Center(
          child: ElevatedButton(
            onPressed: () {
              saveNote(context, titleController, descriptionController, ref);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 15, 85, 142),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              textStyle: const TextStyle(fontSize: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 10,
              side: BorderSide(color: Colors.white70, width: 0.6),
            ),
            child: Text(
              'Save Note',
              style: GoogleFonts.kreon(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
        SizedBox(height: 15),
        Center(
          child: GestureDetector(
            onTap: () {
              titleController.clear();
              descriptionController.clear();
              ref.read(selectedDateTimeProvider.notifier).state = null;
              ref.read(selectedColorProvider.notifier).state = null;
            },
            child: ShimmerEffect(
              baseColor: Colors.white,
              highlightColor: Colors.white70,
              loop: 1,
              child: Text(
                'Clear fields',
                style: GoogleFonts.kreon(
                  fontSize: 20,
                  color: Colors.white70,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
