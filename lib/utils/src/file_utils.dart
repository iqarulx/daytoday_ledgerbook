import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'open_file.dart' as helper;
import '/ui/ui.dart';

class FileUtils {
  static const int maxFileSize = 2 * 1024 * 1024;

  static openFile(context, String? uri, String name, String ext) async {
    try {
      if (uri != null) {
        futureLoading(context);
        var data = await http.get(Uri.parse(uri));
        if (data.bodyBytes.isNotEmpty) {
          Navigator.pop(context);
          await helper.launchFile(
              bt: data.bodyBytes, fn: "$name.$ext", nf: false);
        }
      }
    } catch (e) {
      Navigator.pop(context);
      throw e.toString();
    }
  }

  static openAsBytes(context, Uint8List? uri, String name, String ext) async {
    try {
      if (uri != null) {
        await helper.launchFile(bt: uri, fn: "$name.$ext", nf: false);
      }
    } catch (e) {
      Navigator.pop(context);
      throw e.toString();
    }
  }

  static deleteFile(File? file) {
    if (file != null) {
      if (file.existsSync()) {
        file.delete();
      }
    }
  }

  static bool validateFile(File? file) {
    if (file == null) return false;

    if (!file.existsSync()) {
      return false;
    }

    final fileSize = file.lengthSync();
    if (fileSize > maxFileSize) {
      file.delete();
      return false;
    }

    return true;
  }
}
