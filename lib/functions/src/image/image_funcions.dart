// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Project imports:
import '/constants/constants.dart';
import '/services/services.dart';
import '/ui/ui.dart';

class ImageFuncions {
  static Future<String> uploadImage(context, {required File file}) async {
    try {
      futureLoading(context);
      var v = await Storage.uploadImage(file: file);
      Navigator.pop(context);
      Snackbar.showSnackBar(context, content: "Image updated", isSuccess: true);
      return v;
    } catch (e) {
      Navigator.pop(context);
      Snackbar.showSnackBar(context, content: e.toString(), isSuccess: false);
      throw e.toString();
    }
  }

  static Future<String> deleteUploadImage(context,
      {required String url, required File file}) async {
    try {
      futureLoading(context);
      var v = await Storage.deleteUploadImage(url: url, file: file);
      await Db.updateData(type: UserData.profileImage, value: v);
      Navigator.pop(context);
      Snackbar.showSnackBar(context, content: "Image updated", isSuccess: true);
      return v;
    } catch (e) {
      Navigator.pop(context);
      Snackbar.showSnackBar(context, content: e.toString(), isSuccess: false);
      throw e.toString();
    }
  }
}
