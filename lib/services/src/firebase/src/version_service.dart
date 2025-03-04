/*
  Copyright 2024 Srisoftwarez. All rights reserved.
  Use of this source code is governed by a BSD-style license that can be
  found in the LICENSE file.
*/

// Dart imports:
import 'dart:io';

// Project imports:
import '/services/services.dart';
import '/utils/utils.dart';

class Versions {
  static Config firebase = Config();

  static Future<Map<String, dynamic>> checkVersion() async {
    bool isLogged = await Db.checkLogin();

    if (isLogged) {
      var cv = await AppInfo.getVersion();

      var version = await firebase.version
          .orderBy('created', descending: true)
          .limit(1)
          .get();

      if (version.docs.isNotEmpty) {
        if (version.docs.first.exists) {
          var d = version.docs.first;
          if (Platform.isAndroid) {
            if (d["android"] == cv) {
              return {"status": true};
            } else if (int.parse(cv.split('.').last) >
                int.parse(d["android"].toString().split('.').last)) {
              return {"status": true};
            }
          } else {
            if (d["ios"] == cv) {
              return {"status": true};
            } else if (int.parse(cv.split('.').last) >
                int.parse(d["ios"].toString().split('.').last)) {
              return {"status": true};
            }
          }
          return {"status": false, "vd": version.docs.first.data()};
        }
      } else {
        return {"status": false};
      }

      return {"status": false};
    }
    return {"status": true};
  }
}
