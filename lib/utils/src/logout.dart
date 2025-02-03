// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import '/services/services.dart';
import '/ui/ui.dart';
import '/view/view.dart';

void logout(context) async {
  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => const CDialog(
      title: "Logout",
      content: "Are you sure want to logout?",
    ),
  ).then((value) {
    if (value != null && value) {
      Navigator.pop(context);
      Db.clearDb();
      if (Navigator.of(context).mounted) {
        Navigator.pushReplacement(
            context, CupertinoPageRoute(builder: (context) => const Signin()));
        Snackbar.showSnackBar(
          context,
          content: "Logout Successfully",
          isSuccess: true,
        );
      }
    }
  });
}
