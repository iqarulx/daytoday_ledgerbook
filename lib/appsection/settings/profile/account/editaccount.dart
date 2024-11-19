/*
  Copyright 2024 Srisoftwarez. All rights reserved.
  Use of this source code is governed by a BSD-style license that can be
  found in the LICENSE file.
*/

import 'dart:developer';
import 'package:flutter/material.dart';
import '/appsection/db/datamodel.dart';
import '/appui/alartbox.dart';
import '../../../../welcome/initiateaccount.dart';
import '../../../db/dbservice.dart';

class EditAccount extends StatefulWidget {
  final AccountDataModel accountinfo;
  const EditAccount({super.key, required this.accountinfo});

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  bool? makeDefault;

  String identification = "";
  String bankDetails = "";
  String openingBalance = "";
  Color? accountColour;
  String seletedColor = "";

  late String title;
  late String formName;
  late bool manderty;
  late TextInputType type;
  late String value;

  initfun() {
    setState(() {
      identification = widget.accountinfo.identi!;
      bankDetails = widget.accountinfo.bank!;
      openingBalance = widget.accountinfo.balance.toString();
      seletedColor = widget.accountinfo.color!;
      makeDefault = widget.accountinfo.makedefault == 1 ? true : false;
      switch (widget.accountinfo.color) {
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
    var dataBase = DateService();
    var account = AccountDataModel();
    account.aid = widget.accountinfo.aid;
    account.balance = int.parse(openingBalance);
    account.bank = bankDetails;
    account.color = seletedColor;
    account.deleteprofie = widget.accountinfo.deleteprofie;
    account.identi = identification;
    account.makedefault = makeDefault == true ? 1 : 0;
    account.uid = widget.accountinfo.uid;

    if (makeDefault == true) {
      Map<String, Object?> tmpData = {
        "makedefault": 0,
      };
      await dataBase.updateaccountDefault(tmpData, widget.accountinfo.uid!);
    }

    var updateAccountSection = await dataBase.updateAccountSet(
      widget.accountinfo.uid!,
      widget.accountinfo.aid!,
      account,
    );
    log(updateAccountSection.toString());
    Navigator.pop(context);
    if (updateAccountSection.toString() == "1") {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Successfuly Update Account Information"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Not Update Account Information"),
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
        title: const Text("Edit Account"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => submit(),
        child: const Icon(
          Icons.check,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            CheckboxListTile(
              enabled: widget.accountinfo.makedefault == 1 ? false : true,
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
