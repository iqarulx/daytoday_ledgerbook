import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:uuid/uuid.dart';

class Storage {
  static final storage = FirebaseStorage.instance.ref();

  static Future<String> uploadImage({required File file}) async {
    var uid = const Uuid().v1();

    String downloadLink;
    final uploadDir = storage.child("profile_images/$uid.webp");

    try {
      final originalImageBytes = await file.readAsBytes();

      final compressedImageBytes = await FlutterImageCompress.compressWithList(
        originalImageBytes,
        format: CompressFormat.webp,
        quality: 75,
      );

      final compressedFile = File('${file.path}.webp')
        ..writeAsBytesSync(compressedImageBytes);

      if (!await compressedFile.exists()) {
        return "";
      }

      await uploadDir.putFile(compressedFile);
      downloadLink = await uploadDir.getDownloadURL();

      await compressedFile.delete();
    } catch (e) {
      throw e.toString();
    }
    return downloadLink;
  }
}
