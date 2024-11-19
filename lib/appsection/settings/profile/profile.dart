/*
  Copyright 2024 Srisoftwarez. All rights reserved.
  Use of this source code is governed by a BSD-style license that can be
  found in the LICENSE file.
*/

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import '/language/applanguage.dart';
import '../../../main.dart';
import '../../db/datamodel.dart';
import '../../db/dbservice.dart';
import 'createprofile.dart';
import 'editprofile.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<ProfileDataModel> profileList = [];
  var userSerive = DateService();
  getdata() async {
    profileList.clear();
    var data = await userSerive.readAllDataProfile();
    setState(() {
      for (var element in data) {
        ProfileDataModel profileDataModel = ProfileDataModel();

        profileDataModel.uid = element["uid"];
        profileDataModel.profilepurpose = element["profilepurpose"];
        profileDataModel.profilename = element["profilename"];
        profileDataModel.profileimage = element["profileimage"];
        profileDataModel.makedefault = element["makedefault"];
        profileDataModel.information = element["information"];
        profileDataModel.deleteprofie = element["deleteprofie"];

        profileList.add(profileDataModel);
      }
    });
    log(data.toString());
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(localizedValues[language]!["profile"]!["title"]!),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateProfile(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      body: ListView.builder(
        itemCount: profileList.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfile(
                    profileData: profileList[index],
                  ),
                ),
              ).then((value) {
                getdata();
              });
            },
            leading: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: FileImage(
                    File(profileList[index].profileimage!),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text(profileList[index].profilename!),
            subtitle: Text(profileList[index].profilepurpose!),
            trailing: Text(
              profileList[index].makedefault == 1 ? "DEFAULT" : "",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }
}
