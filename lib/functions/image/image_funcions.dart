import 'dart:io';

import 'package:daytoday_ledgerbook/services/firebase/storage.dart';
import 'package:daytoday_ledgerbook/ui/src/snackbar.dart';
import 'package:daytoday_ledgerbook/ui/ui.dart';
import 'package:flutter/cupertino.dart';

class ImageFuncions {
  static Future<String> uploadImage(context, {required File file}) async {
    try {
      futureLoading(context);
      var v = await Storage.uploadImage(file: file);
      Navigator.pop(context);
      return v;
    } catch (e) {
      Navigator.pop(context);
      Snackbar.showSnackBar(context, content: e.toString(), isSuccess: false);
      throw e.toString();
    }
  }
}
