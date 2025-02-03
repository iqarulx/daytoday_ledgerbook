// Dart imports:
import 'dart:io';

// Package imports:
import 'package:path_provider/path_provider.dart';

class AppCache {
  static Future<String> getCacheSize(context) async {
    final Directory cacheDir = await getApplicationCacheDirectory();
    int totalSize = 0;

    try {
      final List<FileSystemEntity> files = cacheDir.listSync(recursive: true);
      for (final FileSystemEntity file in files) {
        if (file is File) {
          totalSize += await file.length();
        }
      }
    } catch (e) {
      return "Something went wrong";
    }

    return "${(totalSize / (1024 * 1024)).toStringAsFixed(2)} MB";
  }

  static Future<bool> clearCache() async {
    try {
      final Directory cacheDir = await getApplicationCacheDirectory();
      await cacheDir.delete(recursive: true);
      return true;
    } catch (error) {
      return false;
    }
  }
}
