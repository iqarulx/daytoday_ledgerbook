// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:intl/intl.dart';

class DateFormatList extends StatefulWidget {
  const DateFormatList({super.key});

  @override
  State<DateFormatList> createState() => _DateFormatListState();
}

class _DateFormatListState extends State<DateFormatList> {
  final List<String> dateFormats = [
    'dd-MM-yyyy',
    'MM-dd-yyyy',
    'yyyy-MM-dd',
    'dd/MM/yyyy',
    'MM/dd/yyyy',
    'EEEE, MMMM d, yyyy',
    'EEE, MMM d, yyyy',
    'HH:mm',
    'hh:mm a',
    'yyyy-MM-dd HH:mm',
    'MMMM d, yyyy hh:mm:ss a',
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: ListView.separated(
          separatorBuilder: (context, index) {
            return Divider(
              color: Colors.grey.shade300,
            );
          },
          itemCount: dateFormats.length,
          itemBuilder: (context, index) {
            String format = dateFormats[index];
            String example = DateFormat(format).format(DateTime.now());

            return ListTile(
              onTap: () {
                Navigator.pop(context, format);
              },
              title: Text(
                format,
                style: const TextStyle(color: Colors.black),
              ),
              subtitle: Text(
                example,
                style: const TextStyle(color: Colors.grey),
              ),
              leading: Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    (index + 1).toString(),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
