/*
  Copyright 2024 Srisoftwarez. All rights reserved.
  Use of this source code is governed by a BSD-style license that can be
  found in the LICENSE file.
*/

import 'package:flutter/material.dart';

class AccountSignin extends StatefulWidget {
  const AccountSignin({super.key});

  @override
  State<AccountSignin> createState() => _AccountSigninState();
}

class _AccountSigninState extends State<AccountSignin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
        ),
        onPressed: () {},
        icon: const Icon(Icons.arrow_forward_outlined),
        label: const Text("SKIP"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 45,
              ),
              Center(
                child: Text(
                  "Choose your Google Account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 25,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Icon(
                  Icons.account_circle,
                  color: Theme.of(context).primaryColor,
                  size: 80,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  "Sign in to find a backup file in your Google Drive.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor.withOpacity(0.7),
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    // getBackupFile();
                  },
                  child: const Text(
                    "SIGNIN",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                child: Text(
                  "Sri Softwarez Day-To-Day Expenses app does not store any information outside of your device. Providing this flexibility also comes with a challenge to your data. If you either lose your mobile or the app during your usage, you may not be able to recover the data. Hence we recommend you to save the data periodically on your Google Drive through which you may be able to recover the data with minimal support from us. If you like to store the data on your Google Drive, sign in to your account to set up backup option.",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Center(
                child: Text(
                  "BY CLICKING ON SIGNIN, YOU AGREE THAT DAY-TO-DAY EXPENSES DOES NOT GUARANTEE, REPRESENT, OR WARRANT THAT YOUR USE OF THE GOOGLE DRIVE BACKUP OPTION WILL BE UNINTERRUPTED OR ERROR-FREE, AND YOU EXPRESSLY AGREE THAT YOUR USE OF, OR INABILITY TO USE, THE GOOGLE DRIVE BACKUP OPTION IS AT YOUR SOLE RISK",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
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
