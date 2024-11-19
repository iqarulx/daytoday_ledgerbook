/*
  Copyright 2024 Srisoftwarez. All rights reserved.
  Use of this source code is governed by a BSD-style license that can be
  found in the LICENSE file.
*/

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' as io;
import '../appsection/db/googledrive/http_client.dart';

driveBackupFile(BuildContext context) async {
  try {
    drive.DriveApi? api;

    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/drive.file',
      ],
    );

    await googleSignIn.signIn();

    final client = GoogleHttpClient(
      await googleSignIn.currentUser!.authHeaders,
    );

    api = drive.DriveApi(client);
    String folderName = "Sri Softwarez backup";
    String mimeType = "application/vnd.google-apps.folder";

    var searchFolderQuery =
        "mimeType='$mimeType' and name='$folderName' and trashed=false";
    var fileList = await api.files.list(q: searchFolderQuery, spaces: 'drive');

    String folderID = "";

    if (fileList.files!.isEmpty) {
      folderID = await driveCreateFolder(api);
    } else {
      folderID = fileList.files!.first.id!;
    }

    const filename = 'sri_software';
    var searchFileQuery =
        "mimeType!='application/vnd.google-apps.folder' and name='$filename' and '$folderID' in parents and trashed=false";
    var backupFileList =
        await api.files.list(q: searchFileQuery, spaces: 'drive');

    String fileID = "";

    if (backupFileList.files!.isNotEmpty) {
      fileID = backupFileList.files!.first.id!;
    }

    String resultFileID = await uploadBackupFile(api, fileID, filename);

    if (resultFileID.isEmpty || resultFileID == "null") {
      return 400;
    } else {
      return 200;
    }
  } catch (e) {
    return 400;
  }
}

driveCreateFolder<String>(drive.DriveApi api) async {
  var folder = drive.File()
    ..name = 'Sri Softwarez backup'
    ..mimeType = 'application/vnd.google-apps.folder';
  var createdFolder = await api.files.create(folder);
  return createdFolder.id.toString();
}

Future<String> uploadBackupFile(
    drive.DriveApi api, String? fileID, String filename) async {
  try {
    final gFile = drive.File();
    gFile.name = filename;

    final dir = await getApplicationDocumentsDirectory();
    final localFile = io.File('${dir.path}/$filename');

    if (!await localFile.exists()) {
      throw Exception('File does not exist');
    }

    drive.File? createdFile;

    if (fileID == null || fileID.isEmpty) {
      createdFile = await api.files.create(
        gFile,
        uploadMedia: drive.Media(
          localFile.openRead(),
          localFile.lengthSync(),
        ),
        $fields: 'id,name,size,modifiedTime',
      );
    } else {
      createdFile = await api.files.update(
        gFile,
        fileID,
        uploadMedia: drive.Media(
          localFile.openRead(),
          localFile.lengthSync(),
        ),
        $fields: 'id,name,size,modifiedTime',
      );
    }

    var fileSize = getFileSize(int.parse(createdFile.size!), 1);

    var fileModifiedDate = DateFormat('dd MMMM yyyy, hh:mm a')
        .format(createdFile.modifiedTime!.toLocal());
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('lastbackup', fileModifiedDate);
    preferences.setString('size', fileSize);

    return createdFile.id!;
  } catch (e) {
    print('Error uploading file: $e');
    return '';
  }
}

String getFileSize(int size, int decimalPlaces) {
  if (size < 1024) {
    return '$size B';
  } else if (size < 1048576) {
    return '${(size / 1024).toStringAsFixed(decimalPlaces)} KB';
  } else if (size < 1073741824) {
    return '${(size / 1048576).toStringAsFixed(decimalPlaces)} MB';
  } else {
    return '${(size / 1073741824).toStringAsFixed(decimalPlaces)} GB';
  }
}
