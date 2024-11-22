/*
  Copyright 2024 Srisoftwarez. All rights reserved.
  Use of this source code is governed by a BSD-style license that can be
  found in the LICENSE file.
*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';

import '/functions/functions.dart';
import '/services/services.dart';
import '/ui/ui.dart';
import '/utils/utils.dart';
import '/view/view.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  GlobalKey memberIdKey = GlobalKey();
  GlobalKey passwordKey = GlobalKey();
  final passwordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: AppColors.whiteColor),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.pureWhiteColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Theme.of(context).primaryColor),
                          ),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 10),
                                Image.asset(
                                  ImageAssets.logoTrans,
                                  height: 70,
                                  width: 70,
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  key: memberIdKey,
                                  controller: memberId,
                                  keyboardType: TextInputType.emailAddress,
                                  onEditingComplete: () {
                                    setState(() {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    });
                                  },
                                  onTapOutside: (event) {
                                    setState(() {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    });
                                  },
                                  onFieldSubmitted: (v) {
                                    FocusScope.of(context)
                                        .requestFocus(passwordFocus);
                                  },
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    hintText: "Username",
                                    filled: true,
                                    fillColor: AppColors.pureWhiteColor,
                                    prefixIcon: const Icon(Iconsax.user),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value != null) {
                                      if (value.isEmpty) {
                                        return "Enter username";
                                      }
                                      return null;
                                    }
                                    return null;
                                  },
                                  autocorrect: false,
                                  // enableSuggestions: false,
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  focusNode: passwordFocus,
                                  key: passwordKey,
                                  onEditingComplete: () {
                                    setState(() {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    });
                                  },
                                  onTapOutside: (event) {
                                    setState(() {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    });
                                  },
                                  textInputAction: TextInputAction.go,
                                  controller: password,
                                  decoration: InputDecoration(
                                    hintText: "Password",
                                    filled: true,
                                    fillColor: AppColors.pureWhiteColor,
                                    prefixIcon: const Icon(Iconsax.key),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    suffixIcon: IconButton(
                                      tooltip: passwordVisible
                                          ? "Show Password"
                                          : "Hide Password",
                                      onPressed: () {
                                        setState(() {
                                          passwordVisible = !passwordVisible;
                                        });
                                      },
                                      icon: Icon(passwordVisible
                                          ? Iconsax.eye_slash
                                          : Iconsax.eye),
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  obscureText: passwordVisible,
                                  keyboardType: TextInputType.visiblePassword,
                                  validator: (value) {
                                    if (value != null) {
                                      if (value.isEmpty) {
                                        return "Enter password";
                                      }
                                      return null;
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                GestureDetector(
                                  onTap: () {
                                    login();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    height: 50,
                                    width: double.infinity,
                                    child: Center(
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                          color: AppColors.pureWhiteColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextButton.icon(
                                  icon: SvgPicture.asset(SvgAssets.info),
                                  onPressed: () {
                                    Navigator.push(context,
                                        CupertinoPageRoute(builder: (context) {
                                      return const Signup();
                                    }));
                                  },
                                  label: const Text(
                                    "Need account?",
                                    style: TextStyle(color: Color(0xff818589)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  login() async {
    if (formKey.currentState!.validate()) {
      try {
        futureLoading(context);
        var result = await AuthFunctions.checkLogin(
            memberId.text.trim(), password.text.trim());
        Navigator.pop(context);
        Snackbar.showSnackBar(context,
            isSuccess: true, content: "Login Successfully");
        Db.setLogin(model: result);
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (context) => const Home(),
            ),
          );
        });
      } catch (e) {
        Navigator.pop(context);
        Snackbar.showSnackBar(context, isSuccess: false, content: e.toString());
      }
    }
  }

  @override
  void dispose() {
    entity.clear();
    memberId.clear();
    password.clear();
    super.dispose();
  }

  bool passwordVisible = true;
  TextEditingController entity = TextEditingController();
  TextEditingController memberId = TextEditingController();
  TextEditingController password = TextEditingController();
  var formKey = GlobalKey<FormState>();
  String? entityId;
}
