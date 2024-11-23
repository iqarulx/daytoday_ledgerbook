// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class NotesModel {
  String? uid;
  String userId;
  DateTime date;
  String notes;
  DateTime created;
  NotesModel({
    this.uid,
    required this.userId,
    required this.date,
    required this.notes,
    required this.created,
  });

  NotesModel copyWith({
    String? uid,
    String? userId,
    DateTime? date,
    String? notes,
    DateTime? created,
  }) {
    return NotesModel(
      uid: uid ?? this.uid,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      created: created ?? this.created,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'userId': userId,
      'date': date.millisecondsSinceEpoch,
      'notes': notes,
      'created': created.millisecondsSinceEpoch,
    };
  }

  factory NotesModel.fromMap(Map<String, dynamic> map) {
    return NotesModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      userId: map['userId'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      notes: map['notes'] as String,
      created: DateTime.fromMillisecondsSinceEpoch(map['created'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory NotesModel.fromJson(String source) =>
      NotesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NotesModel(uid: $uid, userId: $userId, date: $date, notes: $notes, created: $created)';
  }

  @override
  bool operator ==(covariant NotesModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.userId == userId &&
        other.date == date &&
        other.notes == notes &&
        other.created == created;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        userId.hashCode ^
        date.hashCode ^
        notes.hashCode ^
        created.hashCode;
  }
}
