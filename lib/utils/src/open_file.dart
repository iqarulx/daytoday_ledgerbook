/*
  Copyright 2024 Srisoftwarez. All rights reserved.
  Use of this source code is governed by a BSD-style license that can be
  found in the LICENSE file.
*/

import 'dart:io';
import 'package:open_file/open_file.dart' as open_file;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart'
    as path_provider_interface;
import 'package:url_launcher/url_launcher.dart';
import '/services/services.dart';

Future launchFile(
    {required List<int> bt,
    required String fn,
    required bool nf,
    String? name}) async {
  try {
    String? path;
    if (Platform.isAndroid ||
        Platform.isIOS ||
        Platform.isLinux ||
        Platform.isWindows) {
      if (Platform.isAndroid) {
        final Directory? directory =
            await path_provider.getExternalStorageDirectory();
        if (directory != null) {
          path = directory.path;
        }
      } else if (Platform.isIOS) {
        final Directory directory =
            await path_provider.getApplicationSupportDirectory();
        path = directory.path;
      } else {
        final Directory directory =
            await path_provider.getDownloadsDirectory() ??
                await path_provider.getApplicationCacheDirectory();
        path = directory.path;
      }
    } else {
      path = await path_provider_interface.PathProviderPlatform.instance
          .getApplicationSupportPath();
    }

    final String fileLocation = Platform.isWindows ? '$path\\$fn' : '$path/$fn';
    final File file = File(fileLocation);
    await file.writeAsBytes(bt, flush: true);

    if (nf) {
      await NotificationService.download(
          title: name ?? '', payload: fileLocation);
    }

    if (Platform.isAndroid || Platform.isIOS) {
      await DownloadService.setDownload(data: {
        "file_name": fn,
        "location": fileLocation,
        "file_type": fn.split('.').last,
        "created": DateTime.now().toString()
      });
      await open_file.OpenFile.open(fileLocation);
    } else if (Platform.isWindows) {
      if (!file.existsSync()) {
        throw Exception('${file.uri} does not exist!');
      }
      if (!await launchUrl(file.uri)) {
        throw Exception('Could not launch ${file.uri}');
      }
    } else if (Platform.isMacOS) {
      await Process.run('open', <String>[fileLocation], runInShell: true);
    } else if (Platform.isLinux) {
      await Process.run('xdg-open', <String>[fileLocation], runInShell: true);
    }
  } catch (e) {
    throw e.toString();
  }
}
