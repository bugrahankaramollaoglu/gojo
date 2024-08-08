import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gojo/riverpod_providers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:shimmer_effect/shimmer_effect.dart';

final selectedDateTimeProvider = StateProvider<DateTime?>((ref) => null);

void saveNote(BuildContext context, TextEditingController titleController,
    TextEditingController descriptionController,
    {DateTime? selectedDateTime}) {
  final title = titleController.text;
  final description = descriptionController.text;

  if (title.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Title cannot be empty!')),
    );
    return;
  } else {}

  titleController.clear();
  descriptionController.clear();
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
    // final selectedDateTime = ref.watch(selectedDateTimeProvider.notifier).state;
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
  return Container();
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
                            FontAwesomeIcons.calendar,
                            size: 45,
                          )
                        : const Icon(
                            FontAwesomeIcons.calendarCheck,
                            size: 45,
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 4,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Icon(
                    Icons.category_rounded,
                    size: 45,
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
              saveNote(context, titleController, descriptionController);
              print('date: $selectedDateTime');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              textStyle: const TextStyle(fontSize: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
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
          ),
        ),
      ],
    ),
  );
}
