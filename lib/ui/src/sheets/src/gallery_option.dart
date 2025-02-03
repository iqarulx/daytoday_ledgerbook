// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:iconsax/iconsax.dart';

class GalleryOption extends StatefulWidget {
  const GalleryOption({super.key});

  @override
  State<GalleryOption> createState() => _GalleryOptionState();
}

class _GalleryOptionState extends State<GalleryOption> {
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
            if (Platform.isWindows)
              ListTile(
                onTap: () {
                  Navigator.pop(context, 1);
                },
                title: const Text(
                  "Camera",
                  style: TextStyle(color: Colors.black),
                ),
                leading: const Icon(Iconsax.camera),
              ),
            ListTile(
              onTap: () {
                Navigator.pop(context, 2);
              },
              title: const Text(
                "Gallery",
                style: TextStyle(color: Colors.black),
              ),
              leading: const Icon(Iconsax.gallery),
            )
          ],
        ),
      ),
    );
  }
}
