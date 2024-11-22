import 'dart:io';

import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:image_picker/image_picker.dart';

class PickImage {
  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickImage(int option) async {
    try {
      if (option == 1) {
        XFile? tmpImage = await _picker.pickImage(source: ImageSource.camera);
        if (tmpImage != null) {
          File rotatedImage =
              await FlutterExifRotation.rotateImage(path: tmpImage.path);
          File image = File(rotatedImage.path);
          return image;
        }
      } else {
        XFile? tmpImage = await _picker.pickImage(source: ImageSource.gallery);

        if (tmpImage != null) {
          File image = File(tmpImage.path);
          return image;
        }
      }
      return null;
    } catch (e) {
      throw e.toString();
    }
  }
}
