/*
  Copyright 2024 Srisoftwarez. All rights reserved.
  Use of this source code is governed by a BSD-style license that can be
  found in the LICENSE file.
*/

import 'dart:io';
import 'package:flutter/material.dart';
import '/appsection/settings/profile/utliti/imagepick.dart';
import '../../db/datamodel.dart';
import '../../db/dbservice.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({super.key});

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  bool makeDefault = false;
  File? imageFile;
  TextEditingController profileName = TextEditingController();
  TextEditingController profilePurpose = TextEditingController();
  TextEditingController additionalInfo = TextEditingController();

  var formState = GlobalKey<FormState>();
  ImagePick imagePick = ImagePick();
  pickimage() async {
    imageFile = await imagePick.importImage();
    setState(() {});
  }

  var database = DateService();

  createNewProfile() async {
    if (formState.currentState!.validate() && imageFile != null) {
      String imageData = imageFile!.path;
      ProfileDataModel profileDataModel = ProfileDataModel();
      profileDataModel.profilepurpose = profilePurpose.text;
      profileDataModel.information = additionalInfo.text;
      profileDataModel.profilename = profileName.text;
      profileDataModel.profileimage = imageData;
      profileDataModel.makedefault = makeDefault ? 1 : 0;
      profileDataModel.deleteprofie = 1;
      var data = await database.createProfile(profileDataModel);
      if (data > 0) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Success"),
          ),
        );
      }
    } else {
      if (imageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Profile Image is Empty",
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: formState,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Center(
                child: SizedBox(
                  width: 115,
                  height: 115,
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(
                              width: 4,
                              color: Colors.white,
                            ),
                            image: imageFile != null
                                ? DecorationImage(
                                    image: FileImage(
                                      imageFile!,
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: () {
                            pickimage();
                          },
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
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                "Profile Name",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                ),
              ),
              TextFormField(
                controller: profileName,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: "Profile Name",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return " Profile Name is Must";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Profile Purpose",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                ),
              ),
              TextFormField(
                controller: profilePurpose,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: "Personal | Business | Professional",
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Additional Information",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                ),
              ),
              TextFormField(
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  hintText: "",
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                value: makeDefault,
                onChanged: (v) {
                  setState(() {
                    makeDefault = v!;
                  });
                },
                title: const Text("Make this default"),
                contentPadding: const EdgeInsets.only(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createNewProfile(),
        child: const Icon(
          Icons.check,
        ),
      ),
    );
  }
}
