/*
  Copyright 2024 Srisoftwarez. All rights reserved.
  Use of this source code is governed by a BSD-style license that can be
  found in the LICENSE file.
*/

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/appui/alartbox.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:path/path.dart' as pathv;
import '../appsection/homepage.dart';

class DownloadBackupFile extends StatefulWidget {
  final String? fileID;
  final String? fileSize;
  final String? fileDate;
  final drive.DriveApi api;
  const DownloadBackupFile({
    super.key,
    required this.fileID,
    required this.fileSize,
    required this.fileDate,
    required this.api,
  });

  @override
  State<DownloadBackupFile> createState() => _DownloadBackupFileState();
}

class _DownloadBackupFileState extends State<DownloadBackupFile> {
  backupDownload() async {
    try {
      loading(context);
      var directory = await getApplicationDocumentsDirectory();
      var path = pathv.join(directory.path, 'sri_software');
      // Directory directory = Directory('/storage/emulated/0/Download');
      // var path = pathv.join(directory.path, 'sri_software');
      Object file = await widget.api.files.get(widget.fileID!,
          downloadOptions: drive.DownloadOptions.fullMedia);
      drive.Media? fileMedia = file as drive.Media?;
      // Save the file content to a local file

      var fileStream = File(path).openWrite();
      await fileStream.addStream(fileMedia!.stream);
      await fileStream.close();
      log('File downloaded to $path');
      log(fileMedia.length.toString());
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setBool('login', true);
      preferences.setString('lastbackup', widget.fileDate!);
      preferences.setString('size', widget.fileSize!);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } catch (e) {
      erroralertshowSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 45,
              ),
              Center(
                child: Text(
                  "Import backup from your Google Drive",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 25,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Icon(
                  Icons.cloud_download,
                  color: Theme.of(context).primaryColor,
                  size: 80,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  "Backup found!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor.withOpacity(0.7),
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    backupDownload();
                  },
                  child: const Text(
                    "RESTORE",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  "A BACKUP FILE (${widget.fileSize}) LAST MODIFIED ON ${widget.fileDate} IS FOUND.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(10),
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_forward,
                    color: Theme.of(context).primaryColor,
                  ),
                  label: Text(
                    "SKIP",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
