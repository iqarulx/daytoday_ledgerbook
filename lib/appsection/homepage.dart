/*
  Copyright 2024 Srisoftwarez. All rights reserved.
  Use of this source code is governed by a BSD-style license that can be
  found in the LICENSE file.
*/

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import '/appsection/daily/daily.dart';
import '/appsection/monthly/monthly.dart';
import '/appsection/note/note.dart';
import '/appsection/settings/profile/profile.dart';
import '/appsection/settings/settings.dart';
import '/appsection/yearly/yearly.dart';
import '/appsection/pdfpage.dart';
import '/appui/alartbox.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../backup/drivebackup.dart';
import '../language/applanguage.dart';
import '../main.dart';
import 'db/datamodel.dart';
import 'db/dbservice.dart';
import 'settings/category.dart';

bool showCategory = false;
bool showBottomSheet = false;
int uid = 1;
int aid = 1;
String? profileImage;

List<ProfileAccount> profileList = [];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  var userSerive = DateService();

  noteValidation() async {
    if (todotext.text.isEmpty) {
      setState(() {
        editNoteState.toggletab(false);
      });
    } else {
      var noteDataModel = NoteModel();

      if (editNoteState.isUpdate) {
        log("Note has been Updated");
        noteDataModel.notetodo = todotext.text;
        noteDataModel.transcationdate = editdate;
        var result = await userSerive.updateNote(noteDataModel, editdate);
        log("Result : ${result.toString()}");
        if (result > 0 && result != null) {
          setState(() {
            todotext.clear();
            editNoteState.toggletab(false);
          });
        }
      } else {
        log("Note has been Saved");
        noteDataModel.notetodo = todotext.text;
        noteDataModel.transcationdate =
            DateTime.parse(notenormal).toIso8601String();
        var result = await userSerive.saveNote(noteDataModel);
        log("Result : ${result.toString()}");
        if (result > 0 && result != null) {
          setState(() {
            todotext.clear();
            editNoteState.toggletab(false);
          });
        }
      }
    }
  }

  getnoteDatafun() async {
    var data = await userSerive.getNoteDate(
      DateTime.parse(notenormal).toIso8601String(),
    );
    if (data != null) {
      if (data.isNotEmpty) {
        setState(() {
          editNoteState.toggleUpdate(true);
          todotext.text = data.first["notetodo"];
          editdate = data.first["transcationdate"];
        });
      } else {
        setState(() {
          editNoteState.toggleUpdate(false);
        });
      }
    }
  }

  uploadFile() async {
    loading(context);
    var result = await driveBackupFile(context);
    Navigator.pop(context);
    if (result == 200) {
      successalertshowSnackBar(context, "Successfully Upload Backup File");
    } else {
      erroralertshowSnackBar(context, "Someting Went Worng File not Upload");
    }
  }

  cheklogin() async {
    bool applock = false;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      if (preferences.getBool('applock') == null) {
        preferences.setBool('applock', false);
      }
      applock = preferences.getBool('applock')!;
    });
    if (applock == true) {
      appLock();
    }
  }

  appLock() async {
    final LocalAuthentication auth = LocalAuthentication();

    try {
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Fingerprint to open App',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      if (didAuthenticate == false) {
        SystemNavigator.pop();
      }
    } on PlatformException catch (e) {
      erroralertshowSnackBar(context, e.toString());
    }
  }

  void getuser() async {
    // var database = DateService();
    var data = await userSerive.readAllDataProfile();
    for (var profile in data) {
      ProfileDataModel profileDataModel = ProfileDataModel();

      profileDataModel.uid = profile["uid"];
      profileDataModel.profilepurpose = profile["profilepurpose"];
      profileDataModel.profilename = profile["profilename"];
      profileDataModel.profileimage = profile["profileimage"];
      profileDataModel.makedefault = profile["makedefault"];
      profileDataModel.information = profile["information"];
      profileDataModel.deleteprofie = profile["deleteprofie"];
      var accountData = await userSerive.readAllDataaccount(
        profile["uid"].toString(),
      );
      List<AccountDataModel>? accountlist = [];
      for (var account in accountData) {
        setState(() {
          AccountDataModel accountDataModel = AccountDataModel();
          accountDataModel.aid = account["aid"];
          accountDataModel.balance = account["balance"];
          accountDataModel.bank = account["bank"];
          accountDataModel.color = account["color"];
          accountDataModel.identi = account["identi"];
          accountDataModel.uid = account["uid"];
          accountDataModel.makedefault = account["makedefault"];
          accountDataModel.deleteprofie = account["deleteprofie"];
          if (account["makedefault"] == 1) {
            aid = account["uid"];
          }
          accountlist.add(accountDataModel);
        });
      }
      setState(() {
        if (profile["makedefault"] == 1) {
          uid = profile["uid"];
        }
        profileList.add(
          ProfileAccount(
            profileList: profileDataModel,
            accountlist: accountlist,
          ),
        );
      });
    }

    setState(() {
      uid = profileList
          .indexWhere((element) => element.profileList!.makedefault == 1);
      aid = profileList[uid]
          .accountlist!
          .indexWhere((element) => element.makedefault == 1);
      profileImage = profileList[uid].profileList!.profileimage!;
    });
  }

  chanageUser() async {
    var data = await showDialog(
      context: context,
      builder: (context) {
        return const ChanageUserAlertBox();
      },
    );
    if (data != null && data == true) {
      setState(() {
        profileImage = profileList[uid].profileList!.profileimage!;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    cheklogin();
    tabController = TabController(length: 4, initialIndex: 1, vsync: this);
    tabController.addListener(() {
      setState(() {
        if (tabController.index != 1) {
          showCategory = false;
          showBottomSheet = false;
        }
      });
    });
    getuser();
    languageRef.addListener(themeListener);
    FlutterNativeSplash.remove();
  }

  @override
  void dispose() {
    languageRef.addListener(themeListener);
    super.dispose();
  }

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    double tabsize = MediaQuery.of(context).size.width / 5.2;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  chanageUser();
                },
                child: Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    image: profileList.isNotEmpty && profileImage != null
                        ? DecorationImage(
                            image: FileImage(
                              File(profileImage!),
                            ),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Text(
                "My Daybook",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                uploadFile();
              },
              icon: const Icon(
                Icons.backup,
              ),
            ),
            // IconButton(
            //   onPressed: () {},
            //   icon: const Icon(
            //     Icons.search,
            //   ),
            // ),
            PopupMenuButton(
              onSelected: (value) {
                if (value == "3") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Settings(),
                    ),
                  );
                }
              },
              itemBuilder: (context) => [
                // PopupMenuItem(
                //   value: '1',
                //   child: Text(localizedValues[language]!["home"]!["charts"]!),
                // ),
                // PopupMenuItem(
                //   value: '2',
                //   child: Text(localizedValues[language]!["home"]!["help"]!),
                // ),
                PopupMenuItem(
                  value: '3',
                  child: Text(localizedValues[language]!["home"]!["Settings"]!),
                ),
              ],
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.more_vert,
                ),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 50),
            child: Container(
              alignment: Alignment.centerLeft,
              child: TabBar(
                onTap: (value) {
                  if (value != 1) {
                    setState(() {
                      showCategory = false;
                      showBottomSheet = false;
                    });
                  }
                },
                indicatorSize: TabBarIndicatorSize.tab,
                enableFeedback: true,
                controller: tabController,
                isScrollable: true,
                tabs: [
                  Tab(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 15,
                      child: const Icon(Icons.edit),
                    ),
                  ),
                  Tab(
                    child: SizedBox(
                      width: tabsize,
                      child: Center(
                        child: Text(
                          localizedValues[language]!["home"]!["bar2"]!
                              .toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: SizedBox(
                      width: tabsize,
                      child: Center(
                        child: Text(
                          localizedValues[language]!["home"]!["bar3"]!
                              .toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: SizedBox(
                      width: tabsize,
                      child: Center(
                        child: Text(
                          localizedValues[language]!["home"]!["bar4"]!
                              .toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: tabController.index == 0
            ? editNoteState.stateRefrece
                ? FloatingActionButton(
                    onPressed: () {
                      noteValidation();
                    },
                    child: const Icon(
                      Icons.check,
                    ),
                  )
                : FloatingActionButton(
                    onPressed: () {
                      getnoteDatafun();
                      setState(() {
                        editNoteState.toggletab(true);
                      });
                    },
                    child: const Icon(
                      Icons.edit,
                    ),
                  )
            : tabController.index == 1
                ? showBottomSheet == false
                    ? FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            showBottomSheet = true;
                          });
                          // showModalBottomSheet(
                          //   barrierColor: Colors.transparent,
                          //   context: context,
                          //   builder: (context) {
                          //     return const ShowBottomModelSheet();
                          //   },
                          // );
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const AddTranscation(),
                          //   ),
                          // ).then((value) {
                          //   setState(() {
                          //     statePageRefrace.toggletab(true);
                          //   });
                          // });
                        },
                        child: const Icon(
                          Icons.add,
                        ),
                      )
                    : const SizedBox()
                : tabController.index == 2
                    ? FloatingActionButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PdfPage(
                                firstFilter: 1,
                              ),
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.picture_as_pdf,
                        ),
                      )
                    : FloatingActionButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PdfPage(
                                firstFilter: 2,
                              ),
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.picture_as_pdf,
                        ),
                      ),
        body: Stack(
          children: [
            GestureDetector(
              onTap: () {
                if (showBottomSheet) {
                  setState(() {
                    showBottomSheet = false;
                  });
                }
              },
              child: TabBarView(
                controller: tabController,
                children: const [
                  Note(),
                  Daily(),
                  Monthly(),
                  Yearly(),
                ],
              ),
            ),
            showBottomSheet
                ? const Align(
                    alignment: Alignment.bottomCenter,
                    child: ShowBottomModelSheet(),
                  )
                : const SizedBox(),
            showCategory
                ? const Align(
                    alignment: Alignment.bottomCenter,
                    child: ChooseCategory(),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

class ShowBottomModelSheet extends StatefulWidget {
  const ShowBottomModelSheet({super.key});

  @override
  State<ShowBottomModelSheet> createState() => _ShowBottomModelSheetState();
}

class _ShowBottomModelSheetState extends State<ShowBottomModelSheet> {
  int crttab = 0;
  TextEditingController name = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController description = TextEditingController();
  var userSerive = DateService();
  String accountTitle = "";
  String accountBank = "";

  int userid = profileList[uid].profileList!.uid!;
  int accountid = profileList[uid].accountlist![aid].aid!;

  chooseBank(String title) async {
    var data = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(title),
        content: SingleChildScrollView(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: profileList[uid].accountlist!.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  Navigator.pop(
                    context,
                    {
                      "aid": profileList[uid].accountlist![index].aid,
                      "title": profileList[uid].accountlist![index].identi,
                      "subtitle": profileList[uid].accountlist![index].bank,
                    },
                  );
                },
                title: Text(
                  profileList[uid].accountlist![index].identi.toString(),
                ),
                subtitle: Text(
                  profileList[uid].accountlist![index].bank.toString(),
                ),
              );
            },
          ),
        ),
      ),
    );
    if (data != null) {
      setState(() {
        accountid = data["aid"];
        accountTitle = data["title"].toString();
        accountBank = data["subtitle"].toString();
      });
    }
  }

  accTitle() {
    setState(() {
      accountTitle = profileList[uid].accountlist![aid].identi!;
      accountBank = profileList[uid].accountlist![aid].bank!;
    });
  }

  addtranction() async {
    var transcationData = TranscationModel();
    transcationData.name = name.text;
    transcationData.amount = double.parse(amount.text.toString());
    transcationData.transcationdate = DateTime.parse(normal).toIso8601String();
    transcationData.describe = description.text;
    transcationData.isIncome = crttab == 0 ? 1 : 2;
    transcationData.category = categoryName;
    transcationData.uid = userid;
    transcationData.aid = accountid;
    var result = await userSerive.saveData(transcationData);
    log("Result : ${result.toString()}");
    if (result > 0 && result != null) {
      setState(() {
        name.clear();
        amount.clear();
        description.clear();
        categoryIcon = Icons.category;
        categoryName = "";
        FocusManager.instance.primaryFocus!.unfocus();
        statePageRefrace.toggletab(true);
      });
    }
  }

  String categoryName = "";
  IconData? categoryIcon = Icons.category;

  geticonfun<IconsData>(String icon) {
    switch (icon.toLowerCase()) {
      case "bonus":
        return Icons.new_releases;
      case "interest income":
        return Icons.account_balance;
      case "inverstment":
        return Icons.paid;
      case "reimbursement":
        return Icons.article_outlined;
      case "rental income":
        return Icons.maps_home_work;
      case "returned purchase":
        return Icons.shopping_cart_checkout;
      case "salary":
        return Icons.payments;
      case "atm":
        return Icons.atm;
      case "air tickets":
        return Icons.flight;
      case "auto and transport":
        return Icons.commute;
      case "beauty":
        return Icons.face;
      case "Bike":
        return Icons.two_wheeler;
      case "bills and utilities":
        return Icons.two_wheeler;
      case "books":
        return Icons.library_books;
      case "Bus Fare":
        return Icons.directions_bus;
      case "cc bill payment":
        return Icons.credit_card;
      case "cable":
        return Icons.tv;
      case "cake":
        return Icons.cake;
      case "car":
        return Icons.drive_eta;
      case "car loan":
        return Icons.drive_eta;
      case "cigarette":
        return Icons.smoking_rooms;
      case "clothing":
        return Icons.local_mall;
      case "coffee":
        return Icons.local_cafe;
      case "dining":
        return Icons.lunch_dining;
      case "drinks":
        return Icons.wine_bar;
      case "emi":
        return Icons.account_balance;
      case "education":
        return Icons.school;
      case "education loan":
        return Icons.school;
      case "electricity":
        return Icons.tungsten;
      case "electronics":
        return Icons.devices;
      case "entertainment":
        return Icons.theaters;
      case "festivals":
        return Icons.theaters;
      case "finance":
        return Icons.assignment;
      case "fitness":
        return Icons.fitness_center;
      case "flowers":
        return Icons.filter_vintage;
      case "food and dining":
        return Icons.restaurant_menu;
      case "fruits":
        return Icons.dining;
      case "games":
        return Icons.sports_basketball;
      case "gas":
        return Icons.propane_tank;
      case "gifts and donations":
        return Icons.redeem;
      case "groceries":
        return Icons.shopping_cart;
      case "health":
        return Icons.local_hospital;
      case "home loan":
        return Icons.cottage;
      case "hotel":
        return Icons.local_hotel;
      case "Household":
        return Icons.home;
      case "ice cream":
        return Icons.home;
      case "internet":
        return Icons.language;
      case "kids":
        return Icons.child_care;
      case "laundry":
        return Icons.local_laundry_service;
      case "maid/driver":
        return Icons.local_laundry_service;
      case "maintenance":
        return Icons.build;
      case "medicines":
        return Icons.monitor_heart;
      case "milk":
        return Icons.local_drink;
      case "misc":
        return Icons.new_releases;
      case "mobile":
        return Icons.smartphone;
      case "movie":
        return Icons.chair;
      case "personal care":
        return Icons.spa;
      case "personal loan":
        return Icons.account_balance;
      case "petrol/gas":
        return Icons.local_gas_station;
      case "pizza":
        return Icons.local_pizza;
      case "printing and scanning":
        return Icons.local_pizza;
      case "rent":
        return Icons.house;
      case "salon":
        return Icons.content_cut;
      case "savings":
        return Icons.account_balance_wallet;
      case "shopping":
        return Icons.shopping_basket;
      case "stationery":
        return Icons.description;
      case "taxes":
        return Icons.local_offer;
      case "taxi":
        return Icons.local_taxi;
      case "toll":
        return Icons.toll;
      case "toys":
        return Icons.smart_toy;
      case "train":
        return Icons.train;
      case "travel":
        return Icons.business_center_outlined;
      case "vacation":
        return Icons.soup_kitchen;
      case "water":
        return Icons.water_drop;
      case "work":
        return Icons.work;
      default:
        return Icons.home;
    }
  }

  openCategory() {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text("Choose Category"),
              content: GridView(
                padding: const EdgeInsets.all(0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                ),
                children: [
                  for (var element in categoryList.where(
                      (element) => element.iSincome == (crttab == 0 ? 1 : 2)))
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          categoryName = element.name!;
                          categoryIcon = element.custom == 0
                              ? geticonfun(element.name!)
                              : null;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            Expanded(
                              child: Center(
                                child: element.custom == 0
                                    ? Icon(
                                        geticonfun(element.name!),
                                      )
                                    : Container(
                                        height: 45,
                                        width: 45,
                                        decoration: const BoxDecoration(
                                          color: Colors.pink,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            element.name!
                                                .toUpperCase()
                                                .substring(0, 2),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              element.name!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    accTitle();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: AnimatedContainer(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xffe6e6ff),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          crttab = 0;
                          categoryIcon = Icons.category;
                          categoryName = "";
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: crttab == 0
                              ? const Color(0xff6666ff)
                              : const Color(0xffe6e6ff),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: Text(
                            "Income (Credit)",
                            style: TextStyle(
                              color: crttab == 0 ? Colors.white : Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          crttab = 1;
                          categoryIcon = Icons.category;
                          categoryName = "";
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: crttab == 1
                              ? const Color(0xff6666ff)
                              : const Color(0xffe6e6ff),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: Text(
                            "Expense (Debit)",
                            style: TextStyle(
                              color: crttab == 1 ? Colors.white : Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await openCategory();
                              setState(() {});
                            },
                            child: Container(
                              color: Colors.transparent,
                              width: 30,
                              height: 30,
                              child: Center(
                                child: categoryIcon == null &&
                                        categoryName.isNotEmpty
                                    ? Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        child: Center(
                                          child: Text(
                                            categoryName
                                                .substring(0, 1)
                                                .toUpperCase(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                    : categoryName.isNotEmpty
                                        ? Icon(
                                            categoryIcon,
                                            color: const Color(0xff6666ff),
                                          )
                                        : const Icon(
                                            Icons.category,
                                            color: Color(0xff6666ff),
                                          ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: name,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                hintText: "Enter text",
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: amount,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: "Amount",
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ListTile(
                          onTap: () => chooseBank(
                            crttab == 0 ? "Credit To" : "Debit From",
                          ),
                          title: Text(accountTitle),
                          subtitle: Text(accountBank),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        maxLines: 3,
                        controller: description,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          hintText: "Describe here",
                          border: UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff6666ff),
                  ),
                  child: IconButton(
                    style: IconButton.styleFrom(),
                    onPressed: () {
                      addtranction();
                    },
                    icon: const Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
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

class ChooseCategory extends StatefulWidget {
  const ChooseCategory({super.key});

  @override
  State<ChooseCategory> createState() => _ChooseCategoryState();
}

class _ChooseCategoryState extends State<ChooseCategory> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: AnimatedContainer(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        height: 300,
      ),
    );
  }
}

class ChanageUserAlertBox extends StatefulWidget {
  const ChanageUserAlertBox({super.key});

  @override
  State<ChanageUserAlertBox> createState() => _ChanageUserAlertBoxState();
}

class _ChanageUserAlertBoxState extends State<ChanageUserAlertBox> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      titlePadding: const EdgeInsets.only(
        left: 15,
        top: 15,
        bottom: 15,
      ),
      title: Text(
        "Change Profile",
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 15,
        ),
      ),
      contentPadding: const EdgeInsets.all(0),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < profileList.length; i++)
              ListTile(
                onTap: () {
                  setState(() {
                    uid = profileList.indexWhere(
                        (element) => element.profileList!.makedefault == 1);
                    aid = profileList[uid]
                        .accountlist!
                        .indexWhere((element) => element.makedefault == 1);
                    uid = i;
                    aid = 0;
                  });
                  Navigator.pop(context, true);
                },
                leading: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: FileImage(
                        File(profileList[i].profileList!.profileimage!),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title:
                    Text(profileList[i].profileList!.profilename!.toString()),
                subtitle: Text(
                    profileList[i].profileList!.profilepurpose!.toString()),
                trailing: Text(
                  profileList[i].profileList!.makedefault == 1 ? "DEFAULT" : "",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.all(0),
      actions: [
        Center(
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Profile(),
                ),
              );
            },
            child: const Text("Manage Profile"),
          ),
        )
      ],
    );
  }
}
