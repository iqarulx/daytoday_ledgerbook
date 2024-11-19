/*
  Copyright 2024 Srisoftwarez. All rights reserved.
  Use of this source code is governed by a BSD-style license that can be
  found in the LICENSE file.
*/

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as io;

import 'initiateprofile.dart';
import 'siginin_with_mail.dart';

class SigninGoogle extends StatefulWidget {
  const SigninGoogle({super.key});

  @override
  State<SigninGoogle> createState() => _SigninGoogleState();
}

class _SigninGoogleState extends State<SigninGoogle> {
  Future signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        final User? user = userCredential.user;

        if (user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'name': user.displayName,
            'photoUrl': user.photoURL,
            'createdDateTime': FieldValue.serverTimestamp(),
          });

          File? photo;
          if (user.photoURL != null) {
            photo = await saveUserPhoto(user.photoURL!);
          }

          if (photo != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Initiateprofile(
                  profileName: user.displayName!,
                  imageFile: photo!,
                ),
              ),
            );
          }
        }
      }
    } catch (error) {
      print('Google sign-in error: $error');
    }
  }

  Future<File?> saveUserPhoto(String photoUrl) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/user_photo.jpg';

      final response = await http.get(Uri.parse(photoUrl));
      if (response.statusCode == 200) {
        final file = io.File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        return null;
      }
    } catch (e) {
      print('Error saving user photo: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    signInWithGoogle();
                  },
                  child: const Text(
                    "Sign in",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Center(child: Text("OR")),
              const SizedBox(
                height: 5,
              ),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const SigininWithMail();
                    }));
                  },
                  child: const Text(
                    "Signin With Mail",
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
