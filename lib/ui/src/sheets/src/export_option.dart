import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import '/utils/utils.dart';

class ExportOption extends StatefulWidget {
  const ExportOption({super.key});

  @override
  State<ExportOption> createState() => _ExportOptionState();
}

class _ExportOptionState extends State<ExportOption> {
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
                "Pdf",
                style: TextStyle(color: Colors.black),
              ),
              leading: const Icon(Iconsax.document),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context, 2);
              },
              title: const Text(
                "Excel",
                style: TextStyle(color: Colors.black),
              ),
              leading: SvgPicture.asset(
                SvgAssets.excel,
                height: 25,
                width: 25,
              ),
            )
          ],
        ),
      ),
    );
  }
}
