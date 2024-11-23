import 'package:flutter/material.dart';

Future<DateTime?> datePicker(context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900, 01, 01),
    lastDate: DateTime(2100, 12, 31),
  );
  return picked;
}
