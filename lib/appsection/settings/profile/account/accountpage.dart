/*
  Copyright 2024 Srisoftwarez. All rights reserved.
  Use of this source code is governed by a BSD-style license that can be
  found in the LICENSE file.
*/

import 'package:flutter/material.dart';
import '/appsection/db/dbservice.dart';
import '/appui/alartbox.dart';
import '../../../db/datamodel.dart';
import '/welcome/initiateaccount.dart';

class AccountPage extends StatefulWidget {
  final int uid;
  const AccountPage({super.key, required this.uid});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  TextEditingController openingBalance = TextEditingController();
  TextEditingController accountIdenti = TextEditingController();
  TextEditingController bankDetails = TextEditingController();
  bool makeDefault = false;
  var formKey = GlobalKey<FormState>();

  Color accountColour = Colors.green;
  String seletedColor = "green";

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

  createAccount() async {
    if (formKey.currentState!.validate()) {
      loading(context);
      openingBalance.text = openingBalance.text.trim();
      accountIdenti.text = accountIdenti.text.trim();
      bankDetails.text = bankDetails.text.trim();
      var database = DateService();
      var accountDataModel = AccountDataModel();
      accountDataModel.balance = int.parse(openingBalance.text);
      accountDataModel.bank = bankDetails.text;
      accountDataModel.color = seletedColor;
      accountDataModel.deleteprofie = 1;
      accountDataModel.identi = accountIdenti.text;
      accountDataModel.makedefault = makeDefault ? 1 : 0;
      accountDataModel.uid = widget.uid;

      if (makeDefault) {
        Map<String, Object?> tmpData = {
          "makedefault": 0,
        };
        await database.updateaccountDefault(tmpData, widget.uid);
      }
      var result = await database.createProfileAccount(accountDataModel);
      Navigator.pop(context);
      if (result > 0) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Successfully Create Account"),
          ),
        );
      } else {}
    }
  }

  @override
  void initState() {
    super.initState();
    openingBalance.text = "0";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Account"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createAccount(),
        child: const Icon(
          Icons.check,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Account Identification",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                ),
              ),
              TextFormField(
                controller: accountIdenti,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: "Bank name of your own identification",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Account Indentification is Must";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Bank Details",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                ),
              ),
              TextFormField(
                controller: bankDetails,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: "Credit card | Debit card",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "bank Details is Must";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Opening Balance",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                ),
              ),
              TextFormField(
                controller: openingBalance,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  hintText: "",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Opening Balance is Must";
                  } else if (value == "0") {
                    return "Opening Balance is Must";
                  } else {
                    return null;
                  }
                },
              ),
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                value: makeDefault,
                onChanged: (v) {
                  setState(() {
                    makeDefault = v!;
                  });
                },
                title: const Text("Default"),
                contentPadding: const EdgeInsets.only(),
              ),
              ListTile(
                contentPadding: const EdgeInsets.all(0),
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
