/*
  Copyright 2024 Srisoftwarez. All rights reserved.
  Use of this source code is governed by a BSD-style license that can be
  found in the LICENSE file.
*/

import 'dart:developer' as dev;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import '/appui/alartbox.dart';
import '/auth/downloadbackupfile.dart';
import 'package:intl/intl.dart';

import '../appsection/db/googledrive/http_client.dart';

class ChooseGoogleAccountPage extends StatefulWidget {
  const ChooseGoogleAccountPage({super.key});

  @override
  State<ChooseGoogleAccountPage> createState() =>
      _ChooseGoogleAccountPageState();
}

class _ChooseGoogleAccountPageState extends State<ChooseGoogleAccountPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/drive.file',
    ],
  );
  GoogleSignInAccount? account;
  drive.DriveApi? api;

  getFileSize(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}'
        .toString();
  }

  Future getBackupFile() async {
    loading(context);
    try {
      account = await _googleSignIn.signIn();
      if (account != null) {
        final client = GoogleHttpClient(
          await _googleSignIn.currentUser!.authHeaders,
        );
        api = drive.DriveApi(client);
        var fileName = 'sri_software';
        var query =
            "mimeType!='application/vnd.google-apps.folder' and name='$fileName' and trashed=false";
        var fileList = await api!.files.list(q: query, spaces: 'drive');

        if (fileList.files!.isNotEmpty) {
          var fileId = fileList.files!.first.id;

          drive.File file = await api!.files
              .get(fileId!, $fields: 'id,name,size,modifiedTime') as drive.File;

          var fileSize = getFileSize(int.parse(file.size!), 1);
          var fileModifiedDate = DateFormat('dd MMMM yyyy, HH:mm a')
              .format(file.modifiedTime!.toLocal());
          dev.log(file.toJson().toString());
          dev.log("File ID   - $fileId");
          dev.log("File Size - $fileSize");
          dev.log("File Date - $fileModifiedDate");

          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DownloadBackupFile(
                fileID: fileId,
                fileSize: fileSize,
                fileDate: fileModifiedDate,
                api: api!,
              ),
            ),
          );
        } else {
          Navigator.pop(context);
          erroralertshowSnackBar(context, "Backup File Not Found");
        }
      } else {
        Navigator.pop(context);
        erroralertshowSnackBar(context, "Account Information Not Found");
      }
    } catch (e) {
      Navigator.pop(context);
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 45,
              ),
              Center(
                child: Text(
                  "Choose your Google Account",
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
                  Icons.account_circle,
                  color: Theme.of(context).primaryColor,
                  size: 80,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  "Sign in to find a backup file in your Google Drive.",
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
                    getBackupFile();
                  },
                  child: const Text(
                    "SIGNIN",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Center(
                child: Text(
                  "BY CLICKING ON SIGNIN, YOU AGREE THAT DAY-TO-DAY EXPENSES DOES NOT GUARANTEE, REPRESENT, OR WARRANT THAT YOUR USE OF THE GOOGLE DRIVE BACKUP OPTION WILL BE UNINTERRUPTED OR ERROR-FREE, AND YOU EXPRESSLY AGREE THAT YOUR USE OF, OR INABILITY TO USE, THE GOOGLE DRIVE BACKUP OPTION IS AT YOUR SOLE RISK",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
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
