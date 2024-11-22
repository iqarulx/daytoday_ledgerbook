import 'dart:io';
import '/ui/ui.dart';
import '/services/services.dart';
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
