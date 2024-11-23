import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_app_settings/open_app_settings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '/app/app.dart';
import '/services/services.dart';
import '/ui/ui.dart';
import '/utils/utils.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _notEnabled = false;
  String appVersion = "";
  String _theme = "";

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future _init() async {
    if (await Permission.notification.status.isDenied) {
      _notEnabled = false;
    } else {
      _notEnabled = true;
    }
    if (Platform.isAndroid) {
      var v = await AppInfo.getVersion();
      var vc = await AppInfo.getVersionCode();

      appVersion = "$v ($vc)";
    } else {
      var v = await AppInfo.getVersion();
      appVersion = v;
    }
    _theme = await Db.getTheme() ?? 'light';

    setState(() {});
  }

  Future _changeNotSetting(bool value) async {
    if (value) {
      var status = await Permission.notification.request();
      _notEnabled = status.isGranted;
    } else {
      await OpenAppSettings.openAppSettings();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        leading: IconButton(
          tooltip: "Back",
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(5),
        children: [
          ListTile(
            onTap: () {},
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: SvgPicture.asset(
                SvgAssets.bellRing,
                height: 20,
                width: 20,
              ),
            ),
            title: const Text(
              "Notification",
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              "Push notifications while downloading file",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: Transform.scale(
              scale: 0.8,
              child: CupertinoSwitch(
                activeColor: Theme.of(context).primaryColor,
                onChanged: (value) {
                  _changeNotSetting(value);
                },
                value: _notEnabled,
              ),
            ),
          ),
          Divider(color: Colors.grey.shade300),
          ListTile(
            onTap: () async {
              var r = await AppCache.clearCache();
              if (r) {
                Navigator.pop(context);
                Snackbar.showSnackBar(context,
                    isSuccess: true, content: "Cache cleared");
              } else {
                Navigator.pop(context);
                Snackbar.showSnackBar(context,
                    isSuccess: false, content: "Failed to clear cache");
              }
            },
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: SvgPicture.asset(
                SvgAssets.erase,
                height: 20,
                width: 20,
              ),
            ),
            title: const Text(
              "Cache",
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              "Clear app cache",
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: IconButton(
              tooltip: "Clear temp files",
              icon: SvgPicture.asset(
                SvgAssets.info,
                height: 30,
                width: 30,
              ),
              onPressed: () async {
                await showDialog(
                        context: context,
                        builder: (context) => const CacheDialog())
                    .then((value) async {
                  if (value != null) {
                    if (value) {
                      var r = await AppCache.clearCache();
                      if (r) {
                        Navigator.pop(context);
                        Snackbar.showSnackBar(context,
                            isSuccess: true, content: "Cache cleared");
                      } else {
                        Navigator.pop(context);
                        Snackbar.showSnackBar(context,
                            isSuccess: false, content: "Failed to clear cache");
                      }
                    }
                  }
                });
              },
            ),
          ),
          Divider(color: Colors.grey.shade300),
          ListTile(
            onTap: () {
              final themeProvider =
                  Provider.of<ThemeProvider>(context, listen: false);
              final currentTheme = themeProvider.appTheme == AppTheme.appTheme
                  ? "dark"
                  : "light";
              themeProvider.changeTheme(currentTheme);
              _init();
              setState(() {});
            },
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: SvgPicture.asset(
                SvgAssets.palette,
                height: 20,
                width: 20,
              ),
            ),
            title: const Text(
              "Theme",
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              _theme,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: IconButton(
              tooltip: "Change theme",
              icon: SvgPicture.asset(
                SvgAssets.paletteDark,
                height: 30,
                width: 30,
              ),
              onPressed: () async {
                var v = await Sheet.showSheet(context,
                    size: 0.35, widget: const ThemeOption());
                if (v != null) {
                  String theme;
                  if (v == 1) {
                    theme = "light";
                  } else if (v == 2) {
                    theme = "teal";
                  } else if (v == 3) {
                    theme = "lavendar";
                  } else if (v == 4) {
                    theme = "dark";
                  } else {
                    theme = "light";
                  }
                  final themeProvider =
                      Provider.of<ThemeProvider>(context, listen: false);

                  themeProvider.changeTheme(theme);
                  _init();
                  setState(() {});
                }
              },
            ),
          ),
          Divider(color: Colors.grey.shade300),
          ListTile(
            onTap: () {},
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: SvgPicture.asset(
                SvgAssets.device,
                height: 20,
                width: 20,
              ),
            ),
            title: const Text(
              "App Version",
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              appVersion,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: IconButton(
              tooltip: "Open file",
              icon: Platform.isAndroid
                  ? SvgPicture.asset(
                      SvgAssets.playStore,
                      height: 25,
                      width: 25,
                    )
                  : SvgPicture.asset(
                      SvgAssets.appStore,
                      height: 25,
                      width: 25,
                    ),
              onPressed: () async {
                if (Platform.isAndroid) {
                  var url = "";
                  await launchUrl(Uri.parse(url));
                } else if (Platform.isIOS) {}
              },
            ),
          ),
        ],
      ),
    );
  }
}
