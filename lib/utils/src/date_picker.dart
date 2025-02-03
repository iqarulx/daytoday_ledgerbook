// Flutter imports:
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

Future<DateTime?> dateTimePicker(BuildContext context) async {
  // Step 1: Show Date Picker
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1900, 01, 01),
    lastDate: DateTime(2100, 12, 31),
  );

  if (pickedDate == null) {
    // If the user cancels the date picker
    return null;
  }

  // Step 2: Show Time Picker
  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );

  if (pickedTime == null) {
    // If the user cancels the time picker
    return null;
  }

  // Combine Date and Time into a single DateTime object
  return DateTime(
    pickedDate.year,
    pickedDate.month,
    pickedDate.day,
    pickedTime.hour,
    pickedTime.minute,
  );
}
