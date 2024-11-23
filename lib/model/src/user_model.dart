// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:daytoday_ledgerbook/model/src/account_model.dart';

class UserModel {
  String uid;
  String profileImage;
  String profileName;
  String purpose;
  String additionalInfo;
  String username;
  String password;
  List<AccountModel> accountList;

  UserModel({
    required this.uid,
    required this.profileImage,
    required this.profileName,
    required this.purpose,
    required this.additionalInfo,
    required this.username,
    required this.password,
    required this.accountList,
  });

  UserModel copyWith({
    String? uid,
    String? profileImage,
    String? profileName,
    String? purpose,
    String? additionalInfo,
    String? username,
    String? password,
    List<AccountModel>? accountList,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      profileImage: profileImage ?? this.profileImage,
      profileName: profileName ?? this.profileName,
      purpose: purpose ?? this.purpose,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      username: username ?? this.username,
      password: password ?? this.password,
      accountList: accountList ?? this.accountList,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'profileImage': profileImage,
      'profileName': profileName,
      'purpose': purpose,
      'additionalInfo': additionalInfo,
      'username': username,
      'password': password,
      'accountList': accountList.map((x) => x.toMap()).toList(),
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return <String, dynamic>{
      'profileImage': profileImage,
      'profileName': profileName,
      'purpose': purpose,
      'additionalInfo': additionalInfo,
      'accountList': accountList.map((x) => x.toMap()).toList(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      profileImage: map['profileImage'] as String,
      profileName: map['profileName'] as String,
      purpose: map['purpose'] as String,
      additionalInfo: map['additionalInfo'] as String,
      username: map['username'] as String,
      password: map['password'] as String,
      accountList: List<AccountModel>.from(
        (map['accountList'] as List<int>).map<AccountModel>(
          (x) => AccountModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, profileImage: $profileImage, profileName: $profileName, purpose: $purpose, additionalInfo: $additionalInfo, username: $username, password: $password, accountList: $accountList)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.profileImage == profileImage &&
        other.profileName == profileName &&
        other.purpose == purpose &&
        other.additionalInfo == additionalInfo &&
        other.username == username &&
        other.password == password &&
        listEquals(other.accountList, accountList);
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        profileImage.hashCode ^
        profileName.hashCode ^
        purpose.hashCode ^
        additionalInfo.hashCode ^
        username.hashCode ^
        password.hashCode ^
        accountList.hashCode;
  }
}
