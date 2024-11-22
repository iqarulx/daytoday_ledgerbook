import 'package:daytoday_ledgerbook/view/src/auth/signin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../services/db/db.dart';
import '../../ui/src/c_dialog.dart';
import '../../ui/src/snackbar.dart';

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
