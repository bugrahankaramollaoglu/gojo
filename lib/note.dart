import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String title;
  DateTime? date;
  String? category;
  String? description;

  Note({
    required this.title,
    this.date,
    this.category,
    this.description,
  });

  // Convert a Note object to a Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': date?.toIso8601String(),
      'category': category,
      'description': description,
    };
  }

  // Convert a Map to a Note object
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      title: map['title'],
      date: map['date'] != null ? DateTime.parse(map['date']) : null,
      category: map['category'],
      description: map['description'],
    );
  }
}

