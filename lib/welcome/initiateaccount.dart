/*
  Copyright 2024 Srisoftwarez. All rights reserved.
  Use of this source code is governed by a BSD-style license that can be
  found in the LICENSE file.
*/

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import '../appsection/homepage.dart';
import '/appui/alartbox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../appsection/db/datamodel.dart';
import '../appsection/db/dbservice.dart';

class InitiateAccount extends StatefulWidget {
  final String profileName;
  final String profilePurpose;
  final String information;
  final File image;
  const InitiateAccount({
    super.key,
    required this.profileName,
    required this.profilePurpose,
    required this.information,
    required this.image,
  });

  @override
  State<InitiateAccount> createState() => _InitiateAccountState();
}

class _InitiateAccountState extends State<InitiateAccount> {
  String identification = "Primary Account";
  String bankDetails = "Primary Bank";
  String openingBalance = "500";
  Color accountColour = Colors.green;
  String seletedColor = "green";
  late String title;
  late String formName;
  late bool manderty;
  late TextInputType type;
  late String value;
  editAccount(int method) async {
    setState(() {
      switch (method) {
        case 1:
          title = "Account Identification";
          formName = "Account Identification";
          manderty = true;
          type = TextInputType.text;
          value = identification;
          break;
        case 2:
          title = "Bank Details";
          formName = "Bank Details";
          manderty = true;
          type = TextInputType.text;
          value = bankDetails;
          break;
        case 3:
          title = "Opening Balance";
          formName = "Opening balance";
          manderty = true;
          type = TextInputType.number;
          value = openingBalance;
          break;

        default:
      }
    });

    var account = await showModalBottomSheet(
      context: context,
      builder: (context) {
        return EditAccountBox(
          title: title,
          formName: formName,
          manderty: manderty,
          type: type,
          value: value,
        );
      },
    );

    if (account != null) {
      setState(() {
        switch (method) {
          case 1:
            identification = account;
            break;
          case 2:
            bankDetails = account;
            break;
          case 3:
            openingBalance = account;
            break;
          default:
        }
      });
    }
  }

  chooseColour() async {
    var selectedColor = await showDialog(
      context: context,
      builder: (context) {
        return ColorDialog(
          selectedColor: seletedColor,
        );
      },
    );
    if (selectedColor != null) {
      setState(() {
        seletedColor = selectedColor;
        switch (selectedColor) {
          case "red":
            accountColour = Colors.red.shade900;
            break;
          case "purple":
            accountColour = Colors.purple;
            break;
          case "deepPurple":
            accountColour = Colors.deepPurple;
            break;
          case "indigo":
            accountColour = Colors.indigo;
            break;
          case "blue":
            accountColour = Colors.blue;
            break;
          case "greenAccent":
            accountColour = Colors.greenAccent;
            break;
          case "green":
            accountColour = Colors.green;
            break;
          case "lightGreen":
            accountColour = Colors.lightGreen;
            break;
          case "lightGreenAccent":
            accountColour = Colors.lightGreenAccent;
            break;
          case "yellow":
            accountColour = Colors.yellow.shade800;
            break;
          case "orange":
            accountColour = Colors.orange.shade900;
            break;
          case "brown":
            accountColour = Colors.brown.shade800;
            break;
          default:
        }
      });
    }
  }

  submit() async {
    loading(context);
    DateService dateService = DateService();
    var profileDataModel = ProfileDataModel();

    profileDataModel.profilename = widget.profileName;
    profileDataModel.profileimage = widget.image.path;
    profileDataModel.information = widget.information;
    profileDataModel.profilepurpose = widget.profilePurpose;
    profileDataModel.deleteprofie = 0;
    profileDataModel.makedefault = 1;

    try {
      var result = await dateService.createProfile(profileDataModel);
      if (result > 0) {
        var profileAccountModel = AccountDataModel();
        profileAccountModel.uid = result;
        profileAccountModel.identi = identification;
        profileAccountModel.color = seletedColor;
        profileAccountModel.bank = bankDetails;
        profileAccountModel.balance = int.parse(openingBalance);
        profileAccountModel.deleteprofie = 0;
        profileAccountModel.makedefault = 1;
        var accountResult =
            await dateService.createProfileAccount(profileAccountModel);
        if (accountResult > 0) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          setState(() {
            preferences.setBool('login', true);
            preferences.setInt('crtuser', 1);
            preferences.setInt('crtaccount', 1);
          });

          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        }
      }
    } catch (e) {
      Navigator.pop(context);
      log(e.toString());
      erroralertshowSnackBar(context, e.toString());
    }
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
        onPressed: () {
          submit();
        },
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
                "Edit the default account!",
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
                "Each profile can have multiple accounts.\nThis is the default account for the default profile.\nCustomize this account as per your needs.",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
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
                          "You can create an account for each of your bank accounts, credit cards, e-wallets, meal coupon cards, cash and so on.",
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
                height: 10,
              ),
              const Text.rich(
                TextSpan(
                  text: "Note:",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(
                      text:
                          "In case if you want to identify an account using sensitive information like account number, partially hide them (For example: xxx123).",
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
              ListTile(
                title: const Text("Account Identification"),
                subtitle: Text(identification),
                trailing: IconButton(
                  onPressed: () => editAccount(1),
                  icon: const Icon(
                    Icons.edit,
                  ),
                ),
              ),
              ListTile(
                title: const Text("Bank Details"),
                subtitle: Text(bankDetails),
                trailing: IconButton(
                  onPressed: () => editAccount(2),
                  icon: const Icon(
                    Icons.edit,
                  ),
                ),
              ),
              ListTile(
                title: const Text("Opening Balance"),
                subtitle: Text("\u{20B9}$openingBalance"),
                trailing: IconButton(
                  onPressed: () => editAccount(3),
                  icon: const Icon(
                    Icons.edit,
                  ),
                ),
              ),
              ListTile(
                title: const Text("Account Colour"),
                subtitle: Container(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accountColour,
                    ),
                  ),
                ),
                trailing: IconButton(
                  onPressed: () => chooseColour(),
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

class EditAccountBox extends StatefulWidget {
  final String title;
  final String formName;
  final bool manderty;
  final TextInputType type;
  final String value;
  const EditAccountBox({
    super.key,
    required this.title,
    required this.formName,
    required this.manderty,
    required this.type,
    required this.value,
  });

  @override
  State<EditAccountBox> createState() => _EditAccountBoxState();
}

class _EditAccountBoxState extends State<EditAccountBox> {
  TextEditingController account = TextEditingController();

  final accountkey = GlobalKey<FormState>();

  submit() async {
    if (accountkey.currentState!.validate()) {
      Navigator.pop(context, account.text);
    }
  }

  @override
  void initState() {
    super.initState();
    account.text = widget.value;
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
        key: accountkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              autofocus: true,
              controller: account,
              keyboardType: widget.type,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                hintText: widget.formName,
              ),
              validator: (value) {
                if (widget.manderty) {
                  if (value!.isEmpty) {
                    return "${widget.formName} is Must";
                  } else {
                    return null;
                  }
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
                  onPressed: () => submit(),
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

class ColorDialog extends StatefulWidget {
  final String selectedColor; // Fixed typo in the property name
  const ColorDialog({super.key, required this.selectedColor});

  @override
  State<ColorDialog> createState() => _ColorDialogState();
}

class _ColorDialogState extends State<ColorDialog> {
  int selectedColor = 1;

  void checkColor() {
    setState(() {
      switch (widget.selectedColor) {
        // Fixed typo in method name
        case "red":
          selectedColor = 1;
          break;
        case "purple":
          selectedColor = 2;
          break;
        case "deepPurple":
          selectedColor = 3;
          break;
        case "indigo":
          selectedColor = 4;
          break;
        case "blue":
          selectedColor = 5;
          break;
        case "greenAccent":
          selectedColor = 6;
          break;
        case "green":
          selectedColor = 7;
          break;
        case "lightGreen":
          selectedColor = 8;
          break;
        case "lightGreenAccent":
          selectedColor = 9;
          break;
        case "yellow":
          selectedColor = 10;
          break;
        case "orange":
          selectedColor = 11;
          break;
        case "brown":
          selectedColor = 12;
          break;
        default:
          selectedColor = 1; // Default selection or handle other cases
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkColor();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(5),
      actionsPadding: const EdgeInsets.all(5),
      title: const Text("Account Colour"),
      content: SizedBox(
        width: double.maxFinite, // Ensures the GridView takes up full width
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _colorOption(Colors.red.shade900, 1, "red"),
            _colorOption(Colors.purple, 2, "purple"),
            _colorOption(Colors.deepPurple, 3, "deepPurple"),
            _colorOption(Colors.indigo, 4, "indigo"),
            _colorOption(Colors.blue, 5, "blue"),
            _colorOption(Colors.greenAccent, 6, "greenAccent"),
            _colorOption(Colors.green, 7, "green"),
            _colorOption(Colors.lightGreen, 8, "lightGreen"),
            _colorOption(Colors.lightGreenAccent, 9, "lightGreenAccent"),
            _colorOption(Colors.yellow.shade800, 10, "yellow"),
            _colorOption(Colors.orange.shade900, 11, "orange"),
            _colorOption(Colors.brown.shade800, 12, "brown"),
          ],
        ),
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
  }

  // Helper method to create color options
  Widget _colorOption(Color color, int colorValue, String colorName) {
    return GestureDetector(
      onTap: () => Navigator.pop(context, colorName),
      child: Container(
        decoration: BoxDecoration(
          color: color,
        ),
        child: selectedColor == colorValue
            ? const Center(
                child: Icon(
                  Icons.check_circle,
                  color: Colors.white,
                ),
              )
            : const SizedBox(),
      ),
    );
  }
}
