// ignore_for_file: public_member_api_docs, sort_constructors_first

// Dart imports:
import 'dart:convert';

class EntryModel {
  String uid;
  String userId;
  int type;
  int entry;
  String description;
  String title;
  String accountId;
  String accountIdentification;
  DateTime created;
  EntryModel({
    required this.uid,
    required this.userId,
    required this.type,
    required this.entry,
    required this.description,
    required this.title,
    required this.accountId,
    required this.accountIdentification,
    required this.created,
  });

  EntryModel copyWith({
    String? uid,
    String? userId,
    int? type,
    int? entry,
    String? description,
    String? title,
    String? accountId,
    String? accountIdentification,
    DateTime? created,
  }) {
    return EntryModel(
      uid: uid ?? this.uid,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      entry: entry ?? this.entry,
      description: description ?? this.description,
      title: title ?? this.title,
      accountId: accountId ?? this.accountId,
      accountIdentification:
          accountIdentification ?? this.accountIdentification,
      created: created ?? this.created,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'userId': userId,
      'type': type,
      'entry': entry,
      'description': description,
      'title': title,
      'accountId': accountId,
      'accountIdentification': accountIdentification,
      'created': created.millisecondsSinceEpoch,
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return <String, dynamic>{
      'type': type,
      'entry': entry,
      'description': description,
      'title': title,
      'accountId': accountId,
      'accountIdentification': accountIdentification,
      'created': created.millisecondsSinceEpoch,
    };
  }

  factory EntryModel.fromMap(Map<String, dynamic> map) {
    return EntryModel(
      uid: map['uid'] as String,
      userId: map['userId'] as String,
      type: map['type'] as int,
      entry: map['entry'] as int,
      description: map['description'] as String,
      title: map['title'] as String,
      accountId: map['accountId'] as String,
      accountIdentification: map['accountIdentification'] as String,
      created: DateTime.fromMillisecondsSinceEpoch(map['created'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory EntryModel.fromJson(String source) =>
      EntryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EntryModel(uid: $uid, userId: $userId, type: $type, entry: $entry, description: $description, title: $title, accountId: $accountId, accountIdentification: $accountIdentification, created: $created)';
  }

  @override
  bool operator ==(covariant EntryModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.userId == userId &&
        other.type == type &&
        other.entry == entry &&
        other.description == description &&
        other.title == title &&
        other.accountId == accountId &&
        other.accountIdentification == accountIdentification &&
        other.created == created;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        userId.hashCode ^
        type.hashCode ^
        entry.hashCode ^
        description.hashCode ^
        title.hashCode ^
        accountId.hashCode ^
        accountIdentification.hashCode ^
        created.hashCode;
  }
}
