/*
  Copyright 2024 Srisoftwarez. All rights reserved.
  Use of this source code is governed by a BSD-style license that can be
  found in the LICENSE file.
*/

import 'dart:io';
import 'package:flutter/material.dart';
import '../appsection/settings/profile/utliti/imagepick.dart';
import 'initiateaccount.dart';

class Initiateprofile extends StatefulWidget {
  final String profileName;
  final File? imageFile;
  const Initiateprofile({super.key, required this.profileName, this.imageFile});

  @override
  State<Initiateprofile> createState() => _InitiateprofileState();
}

class _InitiateprofileState extends State<Initiateprofile> {
  File? imageFile;
  pickimage() async {
    ImagePick imagePick = ImagePick();
    imageFile = await imagePick.importImage();
    setState(() {});
  }

  String profileName = '';
  String profilePurpose = "Personal";
  String information = "This profile is used to manage my personal expenses";

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
    }
  }

  submitEvent() async {
    if (imageFile != null) {
      if (profileName.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InitiateAccount(
              profileName: profileName,
              profilePurpose: profilePurpose,
              information: information,
              image: imageFile!,
            ),
          ),
        );
      } else {
        if (profileName.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text("Profile Name Is Must"),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text("Profile Image Is Must"),
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Please select profile image to countinue"),
        ),
      );
    }
  }

  @override
  void initState() {
    imageFile = widget.imageFile;
    profileName = widget.profileName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
        ),
        onPressed: () => submitEvent(),
        icon: const Icon(Icons.arrow_forward_outlined),
        label: const Text("NEXT"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Edit the default profile!",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Profile lets you manage your money inflows and outflows among multiple accounts. This is a default profile created to track your personal expenses. Customize this profile as per your needs.",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text.rich(
                TextSpan(
                  text: "Tip:",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(
                      text:
                          "You can create more profiles later for managing professional or non-personal finance Check 'Profiles and Accounts' under settings.",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
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
                        child: Tooltip(
                          message: "Edit Profile Image",
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
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
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
                isThreeLine: true,
                title: const Text("Additional Information"),
                subtitle: Text(information),
                trailing: IconButton(
                  onPressed: () => editProfileInformation(),
                  icon: const Icon(
                    Icons.edit,
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

class EditProfileNameDialog extends StatefulWidget {
  final String profilename;
  const EditProfileNameDialog({super.key, required this.profilename});

  @override
  State<EditProfileNameDialog> createState() => _EditProfileNameDialogState();
}

class _EditProfileNameDialogState extends State<EditProfileNameDialog> {
  TextEditingController profileName = TextEditingController();

  final profileKey = GlobalKey<FormState>();

  saveName() async {
    if (profileKey.currentState!.validate()) {
      Navigator.pop(context, profileName.text);
    }
  }

  @override
  void initState() {
    super.initState();
    profileName.text = widget.profilename;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: MediaQuery.of(context).viewPadding,
      padding: EdgeInsets.only(
        top: 20,
        right: 20,
        left: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom == 0
            ? 20
            : MediaQuery.of(context).viewInsets.bottom + 10.0,
      ),
      child: Form(
        key: profileKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Profile Name",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              autofocus: true,
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
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "CANCEL",
                  ),
                ),
                TextButton(
                  onPressed: () => saveName(),
                  child: const Text(
                    "SAVE",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EditProfilePurposeDialog extends StatefulWidget {
  final String profilePurpose;
  const EditProfilePurposeDialog({super.key, required this.profilePurpose});

  @override
  State<EditProfilePurposeDialog> createState() =>
      _EditProfilePurposeDialogState();
}

class _EditProfilePurposeDialogState extends State<EditProfilePurposeDialog> {
  TextEditingController profilePurpose = TextEditingController();

  final profileKey = GlobalKey<FormState>();

  saveName() async {
    if (profileKey.currentState!.validate()) {
      Navigator.pop(context, profilePurpose.text);
    }
  }

  @override
  void initState() {
    super.initState();
    profilePurpose.text = widget.profilePurpose;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: MediaQuery.of(context).viewPadding,
      padding: EdgeInsets.only(
        top: 20,
        right: 20,
        left: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom == 0
            ? 20
            : MediaQuery.of(context).viewInsets.bottom + 10.0,
      ),
      child: Form(
        key: profileKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Profile Purpose",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              autofocus: true,
              controller: profilePurpose,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                hintText: "Profile Purpose",
              ),
              validator: (value) {
                return null;
              },
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "CANCEL",
                  ),
                ),
                TextButton(
                  onPressed: () => saveName(),
                  child: const Text(
                    "SAVE",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EditProfileinformationDialog extends StatefulWidget {
  final String information;
  const EditProfileinformationDialog({super.key, required this.information});

  @override
  State<EditProfileinformationDialog> createState() =>
      _EditProfileinformationDialogState();
}

class _EditProfileinformationDialogState
    extends State<EditProfileinformationDialog> {
  TextEditingController profileInformation = TextEditingController();

  final profileKey = GlobalKey<FormState>();

  saveName() async {
    if (profileKey.currentState!.validate()) {
      Navigator.pop(context, profileInformation.text);
    }
  }

  @override
  void initState() {
    super.initState();
    profileInformation.text = widget.information;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: MediaQuery.of(context).viewPadding,
      padding: EdgeInsets.only(
        top: 20,
        right: 20,
        left: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom == 0
            ? 20
            : MediaQuery.of(context).viewInsets.bottom + 10.0,
      ),
      child: Form(
        key: profileKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Additional Information",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              autofocus: true,
              controller: profileInformation,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                hintText: "Additional Information",
              ),
              validator: (value) {
                return null;
              },
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "CANCEL",
                  ),
                ),
                TextButton(
                  onPressed: () => saveName(),
                  child: const Text(
                    "SAVE",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
