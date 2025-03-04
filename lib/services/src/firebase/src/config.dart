// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

class Config {
  final CollectionReference<Map<String, dynamic>> users =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference<Map<String, dynamic>> currency =
      FirebaseFirestore.instance.collection('currency');
  final CollectionReference<Map<String, dynamic>> expenses =
      FirebaseFirestore.instance.collection('expenses');
  final CollectionReference<Map<String, dynamic>> notes =
      FirebaseFirestore.instance.collection('notes');
  final CollectionReference<Map<String, dynamic>> version =
      FirebaseFirestore.instance.collection('version');
}
