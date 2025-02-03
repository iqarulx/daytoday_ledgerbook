// ignore_for_file: public_member_api_docs, sort_constructors_first

// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Project imports:
import '/model/model.dart';

class DailyNotesModel {
  String date;
  List<NotesModel> notesList;
  DailyNotesModel({
    required this.date,
    required this.notesList,
  });

  DailyNotesModel copyWith({
    String? date,
    List<NotesModel>? notesList,
  }) {
    return DailyNotesModel(
      date: date ?? this.date,
      notesList: notesList ?? this.notesList,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date,
      'notesList': notesList.map((x) => x.toMap()).toList(),
    };
  }

  factory DailyNotesModel.fromMap(Map<String, dynamic> map) {
    return DailyNotesModel(
      date: map['date'] as String,
      notesList: List<NotesModel>.from(
        (map['notesList'] as List<int>).map<NotesModel>(
          (x) => NotesModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory DailyNotesModel.fromJson(String source) =>
      DailyNotesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'DailyNotesModel(date: $date, notesList: $notesList)';

  @override
  bool operator ==(covariant DailyNotesModel other) {
    if (identical(this, other)) return true;

    return other.date == date && listEquals(other.notesList, notesList);
  }

  @override
  int get hashCode => date.hashCode ^ notesList.hashCode;
}
