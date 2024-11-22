import 'dart:io';
import 'package:localstore/localstore.dart';
import 'package:path_provider/path_provider.dart' as path;

class DownloadService {
  static final db = Localstore.instance;
  static Future setDownload({required Map<String, dynamic> data}) async {
    var value = await checkFileNameExists(data["file_name"]);
    if (value["status"]) {
      db
          .collection('downloads')
          .doc(value["id"])
          .set(data, SetOptions(merge: true));
    } else {
      final id = db.collection('downloads').doc().id;
      db.collection('downloads').doc(id).set(data);
    }
  }

  static Future<Map<String, dynamic>?> getDownloads() async {
    final items = await db.collection('downloads').get();
    return items;
  }

  static Future clearDownloads() async {
    await db.collection('downloads').delete();
    await clearDownloadsDirectory();
  }

  static Future<Map<String, dynamic>> checkFileNameExists(String name) async {
    final items = await db.collection('downloads').get();
    if (items != null) {
      for (var i in items.entries) {
        if (i.value['file_name'] == name) {
          return {"status": true, "id": i.key.split('/').last};
        }
      }
      return {"status": false, "id": null};
    } else {
      return {"status": false, "id": null};
    }
  }

  static Future<void> clearDownloadsDirectory() async {
    String folderPath = "";

    if (Platform.isAndroid) {
      final Directory? directory = await path.getExternalStorageDirectory();
      if (directory != null) {
        folderPath = directory.path;
      }
    } else if (Platform.isIOS) {
      final Directory directory = await path.getApplicationSupportDirectory();
      folderPath = directory.path;
    } else {
      final Directory directory = await path.getDownloadsDirectory() ??
          await path.getApplicationCacheDirectory();
      folderPath = directory.path;
    }
    final directory = Directory(folderPath);
    if (await directory.exists()) {
      final List<FileSystemEntity> entities = directory.listSync();

      for (FileSystemEntity entity in entities) {
        try {
          if (entity is File) {
            await entity.delete();
          } else if (entity is Directory) {
            await entity.delete(recursive: true);
          }
        } catch (e) {
          throw e.toString();
        }
      }
    }
  }
}
