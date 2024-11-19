/*
  Copyright 2024 Srisoftwarez. All rights reserved.
  Use of this source code is governed by a BSD-style license that can be
  found in the LICENSE file.
*/

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import '../../../welcome/initiateprofile.dart';
import '../../db/datamodel.dart';
import '../../db/dbservice.dart';
import 'account/accountpage.dart';
import 'account/editaccount.dart';

class EditProfile extends StatefulWidget {
  final ProfileDataModel profileData;
  const EditProfile({super.key, required this.profileData});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool? makeDefault;
  var userSerive = DateService();

  String profileName = "";
  String profilePurpose = "";
  String information = "";

  initfun() {
    setState(() {
      profileName = widget.profileData.profilename!;
      profilePurpose = widget.profileData.profilepurpose!;
      information = widget.profileData.information!;
      makeDefault = widget.profileData.makedefault == 1 ? true : false;
    });
    getdata();
  }

  List<AccountDataModel> accountList = [];

  getdata() async {
    accountList.clear();
    var data = await userSerive.readAllDataaccount(
      widget.profileData.uid.toString(),
    );
    setState(() {
      for (var element in data) {
        AccountDataModel accountDataModel = AccountDataModel();
        accountDataModel.aid = element["aid"];
        accountDataModel.balance = element["balance"];
        accountDataModel.bank = element["bank"];
        accountDataModel.color = element["color"];
        accountDataModel.identi = element["identi"];
        accountDataModel.uid = element["uid"];
        accountDataModel.makedefault = element["makedefault"];
        accountDataModel.deleteprofie = element["deleteprofie"];
        accountList.add(accountDataModel);
      }
    });
    log(data.toString());
  }

  editProfileName() async {
    var profilename = await showModalBottomSheet(
      context: context,
      builder: (context) {
        return EditProfileNameDialog(
          profilename: profileName,
        );
      },
    );
    if (profilename != null) {
      setState(() {
        profileName = profilename;
      });
      Map<String, Object?> values = {
        "profilename": profilename,
      };
      var result =
          await userSerive.updatePorfileSet(widget.profileData.uid!, values);
      if (result.toString() == "1") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Successfully Update Profile Name"),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile Name Not Update"),
          ),
        );
      }
    }
  }

  editProfilePurpose() async {
    var profilepurpose = await showModalBottomSheet(
      context: context,
      builder: (context) {
        return EditProfilePurposeDialog(
          profilePurpose: profilePurpose,
        );
      },
    );
    if (profilepurpose != null) {
      setState(() {
        profilePurpose = profilepurpose;
      });
      Map<String, Object?> values = {
        "profilepurpose": profilepurpose,
      };
      var result =
          await userSerive.updatePorfileSet(widget.profileData.uid!, values);
      if (result.toString() == "1") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Successfully Update Profile Purpose"),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile Purpose Not Update"),
          ),
        );
      }
    }
  }

  editProfileInformation() async {
    var profileinformation = await showModalBottomSheet(
      context: context,
      builder: (context) {
        return EditProfileinformationDialog(
          information: information,
        );
      },
    );
    if (profileinformation != null) {
      setState(() {
        information = profileinformation;
      });
      Map<String, Object?> values = {
        "profileinformation": profileinformation,
      };
      var result =
          await userSerive.updatePorfileSet(widget.profileData.uid!, values);
      if (result.toString() == "1") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Successfully Update Profile Information"),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile Information Not Update"),
          ),
        );
      }
    }
  }

  checkingDefault() async {
    try {
      Map<String, Object?> tmpData = {
        "makedefault": 0,
      };
      var data = await userSerive.updateProfileDefault(tmpData);
      log(data.toString());
      if (data > 0) {
        Map<String, Object?> values = {
          "makedefault": 1,
        };

        var result =
            await userSerive.updatePorfileSet(widget.profileData.uid!, values);
        if (result.toString() == "1") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Successfully Update"),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Something Went Worning"),
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    initfun();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            Center(
              child: SizedBox(
                width: 110,
                height: 110,
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          image: DecorationImage(
                            image: FileImage(
                              File(widget.profileData.profileimage!),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 19,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            CheckboxListTile(
              enabled:
                  widget.profileData.makedefault == 1 || makeDefault == true
                      ? false
                      : true,
              controlAffinity: ListTileControlAffinity.leading,
              value: makeDefault,
              onChanged: (v) {
                setState(() {
                  makeDefault = v!;
                });
                checkingDefault();
              },
              title: const Text("Make this default"),
              contentPadding: const EdgeInsets.only(),
            ),
            ListTile(
              title: const Text("Profile Name"),
              subtitle: Text(profileName),
              trailing: IconButton(
                onPressed: () => editProfileName(),
                icon: const Icon(
                  Icons.edit,
                ),
              ),
            ),
            ListTile(
              title: const Text("Profile Purpose"),
              subtitle: Text(profilePurpose),
              trailing: IconButton(
                onPressed: () => editProfilePurpose(),
                icon: const Icon(
                  Icons.edit,
                ),
              ),
            ),
            ListTile(
              title: const Text("Additional Information"),
              subtitle: Text(information),
              trailing: IconButton(
                onPressed: () => editProfileInformation(),
                icon: const Icon(
                  Icons.edit,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Text(
                "Accounts",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
            ListView.builder(
              itemCount: accountList.length,
              padding: const EdgeInsets.all(10),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditAccount(
                          accountinfo: accountList[index],
                        ),
                      ),
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          getdata();
                        });
                      }
                    });
                  },
                  title: Text(accountList[index].identi!),
                  subtitle: Text(
                    "${accountList[index].bank!} ${accountList[index].makedefault == 1 ? "(Default)" : ""}",
                  ),
                );
              },
            ),
            Center(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AccountPage(
                        uid: widget.profileData.uid!,
                      ),
                    ),
                  ).then((value) {
                    if (value != null) {
                      setState(() {
                        getdata();
                      });
                    }
                  });
                },
                label: const Text(
                  "ADD ACCOUNTS",
                ),
                icon: const Icon(
                  Icons.add,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
