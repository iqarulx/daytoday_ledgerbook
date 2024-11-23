import '/services/services.dart';
import 'package:flutter/material.dart';

class ThemeOption extends StatefulWidget {
  const ThemeOption({super.key});

  @override
  State<ThemeOption> createState() => _ThemeOptionState();
}

class _ThemeOptionState extends State<ThemeOption> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15, bottom: 15, right: 15),
        child: ListView(
          primary: false,
          shrinkWrap: true,
          children: [
            ListTile(
              onTap: () {
                Navigator.pop(context, 1);
              },
              title: const Text(
                "Primary",
                style: TextStyle(color: Colors.black),
              ),
              leading: Icon(Icons.circle, color: AppColors.primaryColor),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context, 2);
              },
              title: const Text(
                "Teal",
                style: TextStyle(color: Colors.black),
              ),
              leading: Icon(Icons.circle, color: AppColors.tealPrimaryColor),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context, 3);
              },
              title: const Text(
                "Lavendar",
                style: TextStyle(color: Colors.black),
              ),
              leading:
                  Icon(Icons.circle, color: AppColors.lavendarPrimaryColor),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context, 4);
              },
              title: const Text(
                "Dark",
                style: TextStyle(color: Colors.black),
              ),
              leading: Icon(Icons.circle, color: AppColors.blackPrimaryColor),
            )
          ],
        ),
      ),
    );
  }
}
