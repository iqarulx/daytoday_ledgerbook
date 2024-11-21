/*
  Copyright 2024 Srisoftwarez. All rights reserved.
  Use of this source code is governed by a BSD-style license that can be
  found in the LICENSE file.
*/

import 'dart:io' as io;
import '/auth/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import '/appsection/settings/saveexcel/excelpage.dart';
import '/language/applanguage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../appui/alartbox.dart';
import '../../backup/drivebackup.dart';
import '../../main.dart';
import '../db/datamodel.dart';
import '../db/dbservice.dart';
import '../homepage.dart';
import 'category.dart';
import 'profile/profile.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/drive.file',
  ],
);

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  GoogleSignInAccount? account;

  drive.DriveApi? api;
  final GlobalKey<ScaffoldState> _scaffold = GlobalKey();

  bool carry = true;
  bool applock = false;
  int currentDateFormate = 0;
  String currentDateFormateText = "dd-MM-yyyy";
  String changethemename = "";
  changeDateformat(String changeDateformate) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString('dateformat', changeDateformate);
    });
  }

  showDateFromate() async {
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            contentPadding: const EdgeInsets.only(
              top: 10,
            ),
            title: const Text("Date Format"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RadioListTile<int>(
                  title: const Text('dd-MM-yyyy'),
                  value: 0,
                  groupValue: currentDateFormate,
                  onChanged: (value) {
                    setState(() {
                      currentDateFormate = value!;
                      currentDateFormateText = "dd-MM-yyyy";
                      changeDateformat(currentDateFormateText);
                    });
                    Navigator.pop(context);
                  },
                ),
                RadioListTile<int>(
                  title: const Text('dd/MM/yyyy'),
                  value: 1,
                  groupValue: currentDateFormate,
                  onChanged: (value) {
                    setState(() {
                      currentDateFormate = value!;
                      currentDateFormateText = "dd/MM/yyyy";
                      changeDateformat(currentDateFormateText);
                    });
                    Navigator.pop(context);
                  },
                ),
                RadioListTile<int>(
                  title: const Text('MM/dd/yyyy'),
                  value: 2,
                  groupValue: currentDateFormate,
                  onChanged: (value) {
                    setState(() {
                      currentDateFormate = value!;
                      currentDateFormateText = "MM/dd/yyyy";
                      changeDateformat(currentDateFormateText);
                    });
                    Navigator.pop(context);
                  },
                ),
                RadioListTile<int>(
                  title: const Text('MM-dd-yyyy'),
                  value: 3,
                  groupValue: currentDateFormate,
                  onChanged: (value) {
                    setState(() {
                      currentDateFormate = value!;
                      currentDateFormateText = "MM-dd-yyyy";
                      changeDateformat(currentDateFormateText);
                    });
                    Navigator.pop(context);
                  },
                ),
                RadioListTile<int>(
                  title: const Text('dd.MM.yyyy'),
                  value: 4,
                  groupValue: currentDateFormate,
                  onChanged: (value) {
                    setState(() {
                      currentDateFormate = value!;
                      currentDateFormateText = "dd.MM.yyyy";
                      changeDateformat(currentDateFormateText);
                    });
                    Navigator.pop(context);
                  },
                ),
                RadioListTile<int>(
                  title: const Text('yyyy-MM-dd'),
                  value: 5,
                  groupValue: currentDateFormate,
                  onChanged: (value) {
                    setState(() {
                      currentDateFormate = value!;
                      currentDateFormateText = "yyyy-MM-dd";
                      changeDateformat(currentDateFormateText);
                    });
                    Navigator.pop(context);
                  },
                ),
                RadioListTile<int>(
                  title: const Text('yyyy/MM/dd'),
                  value: 6,
                  groupValue: currentDateFormate,
                  onChanged: (value) {
                    setState(() {
                      currentDateFormate = value!;
                      currentDateFormateText = "yyyy/MM/dd";
                      changeDateformat(currentDateFormateText);
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("CANCEL"),
              ),
            ],
          );
        });
      },
    );

    setState(() {});
  }

  void toDrive() async {
    final filename = 'file-${DateTime.now().millisecondsSinceEpoch}.txt';

    final gFile = drive.File();
    gFile.name = filename;

    final dir = await getApplicationDocumentsDirectory();
    final localFile = io.File('${dir.path}/$filename');
    await localFile.create();
    await localFile.writeAsString(filename);

    final createdFile =
        await api!.files.create(gFile, uploadMedia: drive.Media(localFile.openRead(), localFile.lengthSync()));

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('File saved => id : ${createdFile.id}'),
    ));

    // rebuild to refresh file list
    setState(() {});
  }

  changeLanguageCode(String code) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setString('lang', code);

    Navigator.pop(context);
    setState(() {
      language = code;
      languageRef.toggletab(true);
    });
  }

  chooseLanguage() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("Language"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  changeLanguageCode('en');
                },
                title: const Text("English"),
              ),
              ListTile(
                onTap: () {
                  changeLanguageCode('ta');
                },
                title: const Text("Tamil"),
              ),
              ListTile(
                onTap: () {
                  changeLanguageCode('hi');
                },
                title: const Text("Hindi"),
              ),
            ],
          ),
        );
      },
    );
  }

  String fileSize = "";
  String fileDate = "";

  checkFingerprint() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      if (preferences.getBool('applock') == null) {
        preferences.setBool('applock', false);
      }
      applock = preferences.getBool('applock')!;
    });
  }

  uploadGoogleDriveTime() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      fileSize = preferences.getString('size') == null ? "" : preferences.getString('size')!;
      fileDate = preferences.getString('lastbackup') == null ? "" : preferences.getString('lastbackup')!;
    });
  }

  Future inifun() async {
    try {
      _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? googleAccount) {
        setState(() {
          account = googleAccount;
        });
      });

      await _googleSignIn.signInSilently();
    } catch (e) {
      throw e.toString();
    }
  }

  uploadFile() async {
    loading(context);
    try {
      var result = await driveBackupFile(context);
      Navigator.pop(context);
      if (result == 200) {
        uploadGoogleDriveTime();
        successalertshowSnackBar(context, "Successfully Upload Backup File");
      } else {
        erroralertshowSnackBar(context, "Someting Went Worng File not Upload");
      }
    } catch (e) {
      Navigator.pop(context);
      erroralertshowSnackBar(context, e.toString());
    }
  }

  applockfun(bool value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setBool('applock', value);
      applock = value;
    });
  }

  appLock(bool value) async {
    if (value == false) {
      applockfun(false);
    } else {
      final LocalAuthentication auth = LocalAuthentication();

      final List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();

      if (availableBiometrics.isNotEmpty) {
        if (availableBiometrics.contains(BiometricType.fingerprint) ||
            availableBiometrics.contains(BiometricType.strong)) {
          try {
            final bool didAuthenticate = await auth.authenticate(
              localizedReason: 'App Lock',
              options: const AuthenticationOptions(biometricOnly: true),
            );
            if (didAuthenticate) {
              applockfun(true);
              successalertshowSnackBar(context, "Successfully Finger Print App Lock Set");
            } else {
              applockfun(false);
              erroralertshowSnackBar(context, "Can't Add Finger Added Print");
            }
          } on PlatformException catch (e) {
            erroralertshowSnackBar(context, e.toString());
          }
        } else {
          erroralertshowSnackBar(
              context, "Finger Print Not Support this Device ${availableBiometrics.toList().toString()} ");
        }
      } else {
        erroralertshowSnackBar(context, "Finger Print Not Support this Devices");
      }
    }
  }

  changeAppTheme() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text(
                "Theme",
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    title: const Text('Orginal'),
                    value: "orginal",
                    groupValue: changeThemeApp.theme.toString(),
                    onChanged: (value) {
                      setState(() {
                        changeThemeApp.toggletab(value!);
                        changethemename = value;
                        preferences.setString("theme", value.toUpperCase());
                      });
                      Navigator.pop(context);
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Sea'),
                    value: "sea",
                    groupValue: changeThemeApp.theme.toString(),
                    onChanged: (value) {
                      setState(() {
                        changeThemeApp.toggletab(value!);
                        changethemename = value;
                        preferences.setString("theme", value.toUpperCase());
                      });
                      Navigator.pop(context);
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Teal'),
                    value: "teal",
                    groupValue: changeThemeApp.theme.toString(),
                    onChanged: (value) {
                      setState(() {
                        changeThemeApp.toggletab(value!);
                        changethemename = value;
                        preferences.setString("theme", value.toUpperCase());
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    DateService dbservice = DateService();
    return confirmationAlertbox(context, "Logout", "Are you sure want to logout?").then((value) async {
      if (value != null) {
        if (value) {
          preferences.clear();
          dbservice.clearProfile();
          await _googleSignIn.signOut();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Welcome(),
            ),
          );
        }
      }
    });
  }

  getdateformat() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      currentDateFormateText = preferences.getString('dateformat')!;
    });
  }

  void getuser() async {
    var userSerive = DateService();
    var data = await userSerive.readAllDataProfile();
    setState(() {
      profileList.clear();
    });
    for (var profile in data) {
      ProfileDataModel profileDataModel = ProfileDataModel();

      profileDataModel.uid = profile["uid"];
      profileDataModel.profilepurpose = profile["profilepurpose"];
      profileDataModel.profilename = profile["profilename"];
      profileDataModel.profileimage = profile["profileimage"];
      profileDataModel.makedefault = profile["makedefault"];
      profileDataModel.information = profile["information"];
      profileDataModel.deleteprofie = profile["deleteprofie"];
      var accountData = await userSerive.readAllDataaccount(
        profile["uid"].toString(),
      );
      List<AccountDataModel>? accountlist = [];
      for (var account in accountData) {
        setState(() {
          AccountDataModel accountDataModel = AccountDataModel();
          accountDataModel.aid = account["aid"];
          accountDataModel.balance = account["balance"];
          accountDataModel.bank = account["bank"];
          accountDataModel.color = account["color"];
          accountDataModel.identi = account["identi"];
          accountDataModel.uid = account["uid"];
          accountDataModel.makedefault = account["makedefault"];
          accountDataModel.deleteprofie = account["deleteprofie"];
          if (account["makedefault"] == 1) {
            aid = account["uid"];
          }
          accountlist.add(accountDataModel);
        });
      }
      setState(() {
        if (profile["makedefault"] == 1) {
          uid = profile["uid"];
        }
        profileList.add(
          ProfileAccount(
            profileList: profileDataModel,
            accountlist: accountlist,
          ),
        );
      });
    }

    setState(() {
      uid = profileList.indexWhere((element) => element.profileList!.makedefault == 1);
      aid = profileList[uid].accountlist!.indexWhere((element) => element.makedefault == 1);
      profileImage = profileList[uid].profileList!.profileimage!;
    });
  }

  @override
  void dispose() {
    languageRef.addListener(themeListener);
    super.dispose();
  }

  @override
  void initState() {
    changethemename = changeThemeApp.theme.toString();
    languageRef.addListener(themeListener);
    inifun();
    uploadGoogleDriveTime();
    checkFingerprint();
    getdateformat();
    super.initState();
  }

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      backgroundColor: const Color(0xffEEEEEE),
      appBar: AppBar(
        title: Text(localizedValues[language]!["settings"]!["title"]!),
      ),
      body: ListView(
        children: [
          ListTile(
            onTap: () async {
              chooseLanguage();
            },
            leading: SizedBox(
              height: 40,
              width: 40,
              child: Center(
                child: Icon(
                  Icons.language,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            title: Text(localizedValues[language]!["settings"]!["language"]!),
            subtitle: Text(language == 'en'
                ? "English"
                : language == 'hi'
                    ? "Hindi"
                    : "Tamil"),
          ),
          ListTile(
            enabled: false,
            leading: SizedBox(
              height: 40,
              width: 40,
              child: Center(
                child: Icon(
                  Icons.money_outlined,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            title: Text(localizedValues[language]!["settings"]!["currency"]!),
            subtitle: const Text("INR - Indian Rupee"),
          ),
          // ListTile(
          //   leading: SizedBox(
          //     height: 40,
          //     width: 40,
          //     child: Center(
          //       child: Icon(
          //         Icons.forward,
          //         color: Theme.of(context).primaryColor,
          //       ),
          //     ),
          //   ),
          //   title:
          //       Text(localizedValues[language]!["settings"]!["carry-forward"]!),
          //   subtitle: Text(
          //     localizedValues[language]!["settings"]![
          //         "carry-forward-subtitle"]!,
          //   ),
          //   trailing: Checkbox(
          //     value: carry,
          //     onChanged: (value) {
          //       setState(() {
          //         carry = value!;
          //       });
          //     },
          //   ),
          // ),
          ListTile(
            onTap: () {
              showDateFromate();
            },
            leading: SizedBox(
              height: 40,
              width: 40,
              child: Center(
                child: Icon(
                  Icons.date_range,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            title: Text(localizedValues[language]!["settings"]!["date"]!),
            subtitle: Text(currentDateFormateText),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Profile(),
                ),
              ).then((value) {
                getuser();
              });
            },
            leading: SizedBox(
              height: 40,
              width: 40,
              child: Center(
                child: Icon(
                  Icons.supervisor_account,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            title: Text(localizedValues[language]!["settings"]!["account"]!),
            subtitle: const Text("Manage your profils and accounts"),
          ),
          const Divider(),
          if (io.Platform.isAndroid)
            ListTile(
              leading: const SizedBox(
                height: 40,
                width: 40,
              ),
              title: Text(
                localizedValues[language]!["settings"]!["google-drive-settings"]!,
              ),
            ),
          if (io.Platform.isAndroid)
            ListTile(
              onTap: () {
                uploadFile();
              },
              leading: SizedBox(
                height: 40,
                width: 40,
                child: Center(
                  child: Icon(
                    Icons.account_circle,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              title: Text(localizedValues[language]!["settings"]!["google-account"]!),
              subtitle: account == null ? const Text("Choose an account") : Text(account!.email.toString()),
            ),
          if (io.Platform.isAndroid) const Divider(),
          if (io.Platform.isAndroid)
            ListTile(
              leading: SizedBox(
                height: 40,
                width: 40,
                child: Center(
                  child: Icon(
                    Icons.cloud_upload_rounded,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              title: Text(localizedValues[language]!["settings"]!["Last-Backup"]!),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Google Drive: ${fileDate.isNotEmpty ? fileDate : "--:--"}  Size: ${fileSize.isNotEmpty ? fileSize : "-- --"}\n${localizedValues[language]!["settings"]!["Last-Backup-subtitle"]!}",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      uploadFile();
                    },
                    child: Text(
                      localizedValues[language]!["settings"]!["backup"]!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ExcelPage(),
                ),
              );
            },
            leading: SizedBox(
              height: 40,
              width: 40,
              child: Center(
                child: Icon(
                  Icons.download,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            title: Text(localizedValues[language]!["settings"]!["save-excel"]!),
            subtitle: const Text("Save the data as excel sheet"),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Category(),
                ),
              );
            },
            leading: SizedBox(
              height: 40,
              width: 40,
              child: Center(
                child: Icon(
                  Icons.category,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            title: Text(localizedValues[language]!["settings"]!["category"]!),
            subtitle: Text(localizedValues[language]!["settings"]!["category-subtitle"]!),
          ),
          ListTile(
            onTap: () {
              changeAppTheme();
            },
            leading: SizedBox(
              height: 40,
              width: 40,
              child: Center(
                child: Icon(
                  Icons.palette,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            title: Text(localizedValues[language]!["settings"]!["theme-title"]!),
            subtitle: Text(
              changethemename,
            ),
          ),
          ListTile(
            leading: SizedBox(
              height: 40,
              width: 40,
              child: Center(
                child: Icon(
                  Icons.fingerprint,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            title: Text(localizedValues[language]!["settings"]!["app-lock"]!),
            subtitle: Text(localizedValues[language]!["settings"]!["app-lock-subtitle"]!),
            trailing: Checkbox(
              value: applock,
              onChanged: (value) {
                appLock(value!);
              },
            ),
          ),
          ListTile(
            onTap: () {
              logout();
            },
            leading: SizedBox(
              height: 40,
              width: 40,
              child: Center(
                child: Icon(
                  Icons.logout_rounded,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            title: Text(localizedValues[language]!["settings"]!["logout"]!),
            subtitle: const Text(
              "Exit App",
            ),
          ),
          ListTile(
            onTap: () {
              String appPackageName = "com.srisoftwarez.daytoday";
              try {
                launchUrl(
                  Uri.parse(
                    "market://details?id=$appPackageName",
                  ),
                );
              } on PlatformException {
                launchUrl(
                  Uri.parse(
                    "https://play.google.com/store/apps/details?id=$appPackageName",
                  ),
                );
              }

              // launchUrl(url);
            },
            leading: SizedBox(
              height: 40,
              width: 40,
              child: Center(
                child: Icon(
                  Icons.format_list_numbered,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            title: Text(localizedValues[language]!["settings"]!["app-version"]!),
            subtitle: io.Platform.isAndroid
                ? Text(
                    "1.0.2\n${localizedValues[language]!["settings"]!["app-version-subtitle"]!}",
                  )
                : const Text(
                    "1.0.2",
                  ),
          ),
          if (io.Platform.isAndroid)
            ListTile(
              onTap: () {},
              leading: SizedBox(
                height: 40,
                width: 40,
                child: Center(
                  child: Icon(
                    Icons.stars_rounded,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              title: Text(localizedValues[language]!["settings"]!["premium"]!),
              subtitle: const Text(
                "Explore Premium Benifits",
              ),
            ),
        ],
      ),
    );
  }
}
