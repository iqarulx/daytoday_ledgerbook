import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:iconsax/iconsax.dart';
import 'package:uuid/uuid.dart';

import '/functions/functions.dart';
import '/model/model.dart';
import '/services/services.dart';
import '/ui/ui.dart';
import '/view/view.dart';

class AccountInfo extends StatefulWidget {
  final String profileName;
  final String purpose;
  final String additionalInfo;
  final String profileImageUrl;
  final String username;
  final String password;
  const AccountInfo(
      {super.key,
      required this.profileName,
      required this.purpose,
      required this.username,
      required this.password,
      required this.additionalInfo,
      required this.profileImageUrl});

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  final TextEditingController accountIdentification = TextEditingController();
  final TextEditingController bankDetails = TextEditingController();
  final TextEditingController openingBalance = TextEditingController();
  final TextEditingController accountColor = TextEditingController();
  Color _color = const Color(0xff008000);
  var formKey = GlobalKey<FormState>();
  changeColor(Color color, ValueChanged<Color> updateColor) {
    updateColor(color);
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
            FormFields(
              controller: accountIdentification,
              label: "Account Identification",
              valid: (input) {
                if (input != null) {
                  if (input.isNotEmpty) {
                    return null;
                  }
                  return "Account Identification is required";
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            FormFields(
              controller: bankDetails,
              label: "Bank Details",
              valid: (input) {
                if (input != null) {
                  if (input.isNotEmpty) {
                    return null;
                  }
                  return "Bank Details is required";
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            FormFields(
              controller: openingBalance,
              label: "Opening Balance",
              keyType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            FormFields(
              fillColor: _color,
              controller: accountColor,
              label: "Account color",
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Pick a color'),
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          pickerColor: _color,
                          onColorChanged: (color) {
                            changeColor(color, (newColor) {
                              setState(() {
                                _color = newColor;
                              });
                            });
                          },
                          showLabel: true,
                          pickerAreaHeightPercent: 0.8,
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              readOnly: true,
            )
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
              "Submit",
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
      try {
        futureLoading(context);
        UserModel model = UserModel(
          uid: "",
          username: widget.username,
          password: widget.password,
          profileImage: widget.profileImageUrl,
          profileName: widget.profileName,
          purpose: widget.purpose,
          additionalInfo: widget.additionalInfo,
          accountList: [
            AccountModel(
              accountId: const Uuid().v1(),
              accountColor: _color.value.toString(),
              accountIdentification: accountIdentification.text,
              bankDetails: bankDetails.text,
              openingBalance: openingBalance.text,
            )
          ],
        );

        var r = await AuthFunctions.registerAccount(model);
        await Db.setLogin(
            model: UserModel(
          uid: r,
          username: widget.username,
          password: widget.password,
          profileImage: widget.profileImageUrl,
          profileName: widget.profileName,
          purpose: widget.purpose,
          additionalInfo: widget.additionalInfo,
          accountList: [
            AccountModel(
              accountId: const Uuid().v1(),
              accountColor: _color.value.toString(),
              accountIdentification: accountIdentification.text,
              bankDetails: bankDetails.text,
              openingBalance: openingBalance.text,
            )
          ],
        ));
        Navigator.pop(context);
        Snackbar.showSnackBar(context,
            content: "Account created successfully", isSuccess: true);
        Navigator.pushReplacement(context,
            CupertinoPageRoute(builder: (context) {
          return const Signin();
        }));
      } catch (e) {
        Navigator.pop(context);

        Snackbar.showSnackBar(context, content: e.toString(), isSuccess: false);
      }
    }
  }
}
