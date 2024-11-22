import 'dart:io';

import 'package:daytoday_ledgerbook/functions/image/image_funcions.dart';
import 'package:daytoday_ledgerbook/ui/src/form_fields.dart';
import 'package:daytoday_ledgerbook/ui/src/sheets/src/gallery_option.dart';
import 'package:daytoday_ledgerbook/ui/src/snackbar.dart';
import 'package:daytoday_ledgerbook/utils/src/assets.dart';
import 'package:daytoday_ledgerbook/view/src/auth/account_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../services/src/color/app_colors.dart';
import '../../../utils/src/pick_image.dart';
import '../../../utils/utils.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _profileName = TextEditingController();
  final TextEditingController _purpose = TextEditingController();
  final TextEditingController _additionalInfo = TextEditingController();
  final passwordFocus = FocusNode();

  File? _profileImageFile;
  String? _profileImageUrl;
  var formKey = GlobalKey<FormState>();
  bool passwordVisible = true;

  @override
  void initState() {
    _purpose.text = "General";
    _additionalInfo.text = "General Description";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register a new account"),
        leading: IconButton(
          tooltip: "Back",
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            Center(
              child: Stack(
                children: [
                  ClipOval(
                    child: _profileImageFile != null
                        ? Image.file(
                            _profileImageFile!,
                            width: 150,
                            height: 150,
                          )
                        : Image.asset(
                            ImageAssets.avatar,
                            width: 150,
                            height: 150,
                          ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        tooltip: "Edit",
                        icon: const Icon(Icons.edit_rounded),
                        onPressed: () async {
                          var v = await Sheet.showSheet(context,
                              size: 0.2, widget: const GalleryOption());
                          if (v != null) {
                            var pr = await PickImage.pickImage(v);
                            if (pr != null) {
                              var v = await ImageFuncions.uploadImage(context,
                                  file: pr);
                              if (v.isNotEmpty) {
                                _profileImageFile = pr;
                                _profileImageUrl = v;
                              }
                              setState(() {});
                            }
                          }
                        },
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            FormFields(
              controller: _profileName,
              label: "Profile Name",
              valid: (input) {
                if (input != null) {
                  if (input.isNotEmpty) {
                    return null;
                  }
                  return "Profile name is required";
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            FormFields(
              controller: _userName,
              label: "Username",
              valid: (input) {
                if (input != null) {
                  if (input.isNotEmpty) {
                    return null;
                  }
                  return "Username is required";
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            Text(
              "Password",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.black, fontWeight: FontWeight.w300),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            TextFormField(
              focusNode: passwordFocus,
              onEditingComplete: () {
                setState(() {
                  FocusManager.instance.primaryFocus?.unfocus();
                });
              },
              onTapOutside: (event) {
                setState(() {
                  FocusManager.instance.primaryFocus?.unfocus();
                });
              },
              textInputAction: TextInputAction.go,
              controller: _password,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.pureWhiteColor,
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
                  tooltip: passwordVisible ? "Show Password" : "Hide Password",
                  onPressed: () {
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                  icon: Icon(passwordVisible ? Iconsax.eye_slash : Iconsax.eye),
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
            const SizedBox(height: 10),
            FormFields(
              controller: _purpose,
              label: "Purpose",
              valid: (input) {
                if (input != null) {
                  if (input.isNotEmpty) {
                    return null;
                  }
                  return "Purpose is required";
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            FormFields(
              controller: _additionalInfo,
              label: "Additional Information",
              maxLines: 3,
            ),
          ],
        ),
      ),
      bottomNavigationBar: bottomAppbar(context),
    );
  }

  BottomAppBar bottomAppbar(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(Theme.of(context).primaryColor),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: MaterialStateProperty.all(const Size(80, 30)),
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.tick_circle, color: AppColors.pureWhiteColor),
            const SizedBox(width: 10),
            Text(
              "Next",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: AppColors.pureWhiteColor),
            ),
          ],
        ),
        onPressed: () async {
          _saveProfile();
        },
      ),
    );
  }

  _saveProfile() async {
    if (formKey.currentState!.validate()) {
      if (_profileImageUrl != null) {
        Navigator.push(context, CupertinoPageRoute(builder: (context) {
          return AccountInfo(
            username: _userName.text,
            password: _password.text,
            purpose: _purpose.text,
            profileName: _profileName.text,
            profileImageUrl: _profileImageUrl ?? '',
            additionalInfo: _additionalInfo.text,
          );
        }));
      } else {
        Snackbar.showSnackBar(context,
            content: "Please select profile image to countinue",
            isSuccess: false);
      }
    }
  }
}
