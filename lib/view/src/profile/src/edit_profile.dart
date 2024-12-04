import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:iconsax/iconsax.dart';
import 'package:uuid/uuid.dart';

import '/functions/functions.dart';
import '/services/services.dart';
import '/ui/ui.dart';
import '/utils/utils.dart';
import '/constants/constants.dart';
import '/model/model.dart';

class EditProfile extends StatefulWidget {
  final Map<String, dynamic> data;
  const EditProfile({super.key, required this.data});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var formKey = GlobalKey<FormState>();

  final TextEditingController _profileName = TextEditingController();
  final TextEditingController _purpose = TextEditingController();
  final TextEditingController _additionalInfo = TextEditingController();
  final TextEditingController currency = TextEditingController();
  final TextEditingController dateFormat = TextEditingController();

  final List<AccountEditModel> _accList = [];
  late Future _editHanlder;
  changeColor(Color color, ValueChanged<Color> updateColor) {
    updateColor(color);
  }

  final List<Color> _colors = [];
  String? _selectedProfileImage;

  @override
  void initState() {
    currency.addListener(() {
      setState(() {});
    });
    dateFormat.addListener(() {
      setState(() {});
    });
    _editHanlder = _init();
    super.initState();
  }

  @override
  void dispose() {
    currency.dispose();
    dateFormat.dispose();
    super.dispose();
  }

  _init() async {
    _profileName.text = widget.data["profileName"];
    _purpose.text = widget.data["purpose"];
    _additionalInfo.text = widget.data["additionalInfo"];
    _selectedProfileImage = widget.data["profileImage"];
    currency.text = widget.data["currency"];
    dateFormat.text = widget.data["dateFormat"];
    for (var i in widget.data["accountList"]) {
      _colors.add(Color(int.parse(i["accountColor"].toString())));

      _accList.add(
        AccountEditModel(
          id: i["accountId"],
          accountIdentification:
              TextEditingController(text: i["accountIdentification"]),
          bankDetails: TextEditingController(text: i["bankDetails"]),
          selectedColor: i["accountColor"].toString(),
          openingBalance: TextEditingController(text: i["openingBalance"]),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: "Back",
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Edit Profile"),
      ),
      floatingActionButton: _floatingButton(),
      bottomNavigationBar: bottomAppbar(context),
      body: FutureBuilder(
        future: _editHanlder,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return futureWaitingLoading(context);
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return Form(
              key: formKey,
              child: ListView(
                padding: const EdgeInsets.all(10),
                children: [
                  const SizedBox(height: 10),
                  Center(
                    child: Stack(
                      children: [
                        ClipOval(
                          child: _selectedProfileImage != null
                              ? Image.network(
                                  _selectedProfileImage!,
                                  width: 100,
                                  height: 100,
                                )
                              : Image.network(
                                  emptyProfilePhoto,
                                  width: 100,
                                  height: 100,
                                ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: IconButton(
                              tooltip: "Edit",
                              icon: const Icon(
                                Icons.edit_rounded,
                                size: 20,
                              ),
                              onPressed: () async {
                                var v = await Sheet.showSheet(context,
                                    size: 0.2, widget: const GalleryOption());
                                if (v != null) {
                                  var pr = await PickImage.pickImage(v);
                                  if (pr != null) {
                                    var v =
                                        await ImageFuncions.deleteUploadImage(
                                            context,
                                            url: _selectedProfileImage!,
                                            file: pr);
                                    if (v.isNotEmpty) {
                                      _selectedProfileImage = v;
                                    }
                                    setState(() {});
                                  }
                                }
                              },
                              color: Colors.white,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  FormFields(
                    controller: _profileName,
                    label: "Profile Name",
                    hintText: "Profile Name",
                    valid: (input) {
                      if (input != null) {
                        if (input.isEmpty) {
                          return 'Enter name';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  FormFields(
                    controller: _purpose,
                    label: "Purpose",
                    hintText: "Purpose",
                    valid: (input) {
                      if (input != null) {
                        if (input.isEmpty) {
                          return 'Enter purpose';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  FormFields(
                    controller: _additionalInfo,
                    label: "Additional Info",
                    hintText: "Additional Info",
                    maxLines: 3,
                  ),
                  const SizedBox(height: 10),
                  FormFields(
                    suffixIcon: currency.text.isEmpty
                        ? const Icon(Icons.arrow_drop_down_rounded)
                        : IconButton(
                            tooltip: "Clear",
                            onPressed: () {
                              currency.clear();
                              setState(() {});
                            },
                            icon: Icon(
                              Iconsax.close_circle,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                    controller: currency,
                    label: "Currency",
                    hintText: "Select",
                    onTap: () async {
                      var value = await Sheet.showSheet(context,
                          size: 0.9, widget: const CurrencyList());
                      if (value != null) {
                        currency.text = value;
                        setState(() {});
                      }
                    },
                    readOnly: true,
                    // valid: (input) {
                    //   if (input != null) {
                    //     if (input.isEmpty) {
                    //       return 'Select site';
                    //     }
                    //   }
                    //   return null;
                    // },
                  ),
                  const SizedBox(height: 10),
                  FormFields(
                    suffixIcon: dateFormat.text.isEmpty
                        ? const Icon(Icons.arrow_drop_down_rounded)
                        : IconButton(
                            tooltip: "Clear",
                            onPressed: () {
                              dateFormat.clear();
                              setState(() {});
                            },
                            icon: Icon(
                              Iconsax.close_circle,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                    controller: dateFormat,
                    label: "Date Format",
                    hintText: "Select",
                    onTap: () async {
                      var value = await Sheet.showSheet(context,
                          size: 0.9, widget: const DateFormatList());
                      if (value != null) {
                        dateFormat.text = value;
                        setState(() {});
                      }
                    },
                    readOnly: true,
                    // valid: (input) {
                    //   if (input != null) {
                    //     if (input.isEmpty) {
                    //       return 'Select site';
                    //     }
                    //   }
                    //   return null;
                    // },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Accounts",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  for (var i = 0; i < _accList.length; i++)
                    Column(
                      children: [
                        const Divider(),
                        FormFields(
                          controller: _accList[i].accountIdentification,
                          label: "Account Identification",
                          hintText: "Account Identification",
                          valid: (input) {
                            if (input != null) {
                              if (input.isEmpty) {
                                return 'Enter identification';
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        FormFields(
                          controller: _accList[i].bankDetails,
                          label: "Bank Details",
                          hintText: "Bank Details",
                        ),
                        const SizedBox(height: 10),
                        FormFields(
                          controller: _accList[i].openingBalance,
                          label: "Opening Balance",
                          hintText: "Opening Balance",
                          keyType: TextInputType.number,
                        ),
                        const SizedBox(height: 10),
                        FormFields(
                          controller: TextEditingController(),
                          fillColor: _colors[i],
                          label: "Account Color",
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Pick a color'),
                                  content: SingleChildScrollView(
                                    child: ColorPicker(
                                      pickerColor: _colors[i],
                                      onColorChanged: (color) {
                                        changeColor(color, (newColor) {
                                          setState(() {
                                            _colors[i] = newColor;
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
                        ),
                      ],
                    )
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _floatingButton() {
    return FloatingActionButton(
      heroTag: null,
      foregroundColor: AppColors.whiteColor,
      backgroundColor: Theme.of(context).primaryColor,
      shape: const CircleBorder(),
      onPressed: () async {
        _accList.add(AccountEditModel(
            id: const Uuid().v1(),
            accountIdentification: TextEditingController(),
            bankDetails: TextEditingController(),
            openingBalance: TextEditingController(),
            selectedColor: "0xff000000"));
        _colors.add(const Color(0xff000000));
        setState(() {});
      },
      child: const Icon(Icons.add_rounded),
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
          if (formKey.currentState!.validate()) {
            _updateProfile();
          }
        },
      ),
    );
  }

  _updateProfile() async {
    try {
      futureLoading(context);
      List<AccountModel> alist = [];

      for (var i = 0; i < _accList.length; i++) {
        alist.add(
          AccountModel(
            accountId: _accList[i].id ?? '',
            accountIdentification: _accList[i].accountIdentification.text,
            bankDetails: _accList[i].bankDetails.text,
            openingBalance: _accList[i].openingBalance.text,
            accountColor: _colors[i].value.toString(),
          ),
        );
      }

      await Db.updateData(type: UserData.currency, value: currency.text);
      await Db.updateData(type: UserData.dateFormat, value: dateFormat.text);

      var userModel = UserModel(
        uid: "",
        username: "",
        password: "",
        currency: currency.text,
        dateFormat: dateFormat.text,
        additionalInfo: _additionalInfo.text,
        profileName: _profileName.text,
        purpose: _purpose.text,
        profileImage: _selectedProfileImage ?? '',
        accountList: alist,
      );
      await ScreensFunctions.updateProfile(userModel);
      Navigator.pop(context);
      Snackbar.showSnackBar(context,
          content: "Profile Updated", isSuccess: true);
      Navigator.pop(context, true);
    } catch (e) {
      Snackbar.showSnackBar(context, content: e.toString(), isSuccess: false);
    }
  }
}
