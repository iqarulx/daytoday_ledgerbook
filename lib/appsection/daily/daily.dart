/*
  Copyright 2024 Srisoftwarez. All rights reserved.
  Use of this source code is governed by a BSD-style license that can be
  found in the LICENSE file.
*/

import 'dart:developer';
import 'package:flutter/material.dart';
import '/appconfig/appconfig.dart';
import '/appsection/datefun.dart';
import '/appsection/homepage.dart';
import '../../language/applanguage.dart';
import '../../main.dart';
import '../db/datamodel.dart';
import '../db/dbservice.dart';

SetSateDaily statePageRefrace = SetSateDaily();
String normal = "";

class Daily extends StatefulWidget {
  const Daily({super.key});

  @override
  State<Daily> createState() => _DailyState();
}

class _DailyState extends State<Daily> {
  String date = "";
  String day = "";
  String month = "";
  String year = "";
  DateTime crtdate = DateTime.now();
  var userSerive = DateService();
  late List<TranscationModel> trancationDataList = [];
  getinitfun() async {
    DateFun findDate = DateFun(inidate: crtdate);
    var resultDate = await findDate.getDailyInfo();
    if (resultDate != null) {
      setState(() {
        normal = resultDate["normal"].toString();
        date = resultDate["date"].toString();
        day = resultDate["day"].toString();
        month = resultDate["month"].toString();
        year = resultDate["year"].toString();
        gettrandata();
      });
    }
  }

  void showDayPickDialog() async {
    var data = await showDatePicker(
      context: context,
      initialDate: crtdate,
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
      // builder: (context, child) {
      //   return Theme(
      //       data: Theme.of(context).copyWith(
      //         colorScheme: const ColorScheme.light(
      //           primary: Color(0xff6666ff), // <-- SEE HERE
      //           onPrimary: Colors.white, // <-- SEE HERE
      //           onSurface: Color(0xff6666ff), // <-- SEE HERE
      //         ),
      //         textButtonTheme: TextButtonThemeData(
      //           style: TextButton.styleFrom(
      //             foregroundColor: const Color(0xff6666ff), // button text color
      //           ),
      //         ),
      //       ),
      //       child: child!);
      // },
    );
    if (data != null) {
      setState(() {
        crtdate = data;
      });
      DateFun findDate = DateFun(inidate: data);
      var resultDate = await findDate.getDailyInfo();
      if (resultDate != null) {
        setState(() {
          normal = resultDate["normal"];
          date = resultDate["date"];
          day = resultDate["day"];
          month = resultDate["month"];
          year = resultDate["year"];
          gettrandata();
        });
      }
    }
  }

  previousDatefun() async {
    DateTime nxtday = crtdate.add(const Duration(days: -1));
    setState(() {
      crtdate = nxtday;
    });
    DateFun findDate = DateFun(inidate: nxtday);
    var resultDate = await findDate.getDailyInfo();
    if (resultDate != null) {
      setState(() {
        normal = resultDate["normal"];
        date = resultDate["date"];
        day = resultDate["day"];
        month = resultDate["month"];
        year = resultDate["year"];
        gettrandata();
      });
    }
  }

  nextdatefun() async {
    DateTime nxtday = crtdate.add(const Duration(days: 1));
    setState(() {
      crtdate = nxtday;
    });
    DateFun findDate = DateFun(inidate: nxtday);
    var resultDate = await findDate.getDailyInfo();
    if (resultDate != null) {
      setState(() {
        normal = resultDate["normal"].toString();
        date = resultDate["date"].toString();
        day = resultDate["day"].toString();
        month = resultDate["month"].toString();
        year = resultDate["year"].toString();
        gettrandata();
      });
    }
  }

  gettrandata() async {
    setState(() {
      trancationDataList.clear();
    });
    var data =
        await userSerive.crtdayData(DateTime.parse(normal).toIso8601String());
    log(data.toString());
    data.forEach((user) {
      setState(() {
        var tranmodel = TranscationModel();
        tranmodel.name = user['name'];
        tranmodel.transcationdate = user['transcationdate'];
        tranmodel.amount = double.parse(user['amount'].toString());
        tranmodel.describe = user['describe'];
        tranmodel.isIncome = user['isincome'];
        tranmodel.category = user['category'];
        tranmodel.uid = user['uid'];
        tranmodel.aid = user['aid'];
        trancationDataList.add(tranmodel);
      });
    });
  }

  totalexpance() {
    String result = "";
    double total = 0.00;
    for (var element in trancationDataList) {
      if (element.isIncome == 2) {
        total += element.amount!;
      }
    }
    result = total.toStringAsFixed(2);
    return result;
  }

  totalincome() {
    String result = "";
    double total = 0.00;
    for (var element in trancationDataList) {
      if (element.isIncome == 1) {
        total += element.amount!;
      }
    }
    result = total.toStringAsFixed(2);
    return result;
  }

  totalbalance() {
    String result = "";
    double total = 0.00;
    double expance = double.parse(totalexpance());
    double income = double.parse(totalincome());
    total = income - expance;
    result = total.toStringAsFixed(2);
    return result;
  }

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
        return null;
    }
  }

  getaccount(int? uid, int? aid) {
    int uindex = profileList.indexWhere(
      (element) => element.profileList!.uid == uid,
    );
    int aindex = profileList[uindex].accountlist!.indexWhere(
          (element) => element.aid == aid,
        );
    var accountTitle = profileList[uindex].accountlist![aindex].identi!;
    accountTitle = accountTitle.toString().trim().substring(0, 11);
    return accountTitle.toString();
  }

  getaccountColor(int? uid, int? aid) {
    int uindex = profileList.indexWhere(
      (element) => element.profileList!.uid == uid,
    );
    int aindex = profileList[uindex].accountlist!.indexWhere(
          (element) => element.aid == aid,
        );
    var selectedColor = profileList[uindex].accountlist![aindex].color!;
    Color? accountColour;
    setState(() {
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
    return accountColour;
  }

  @override
  void dispose() {
    languageRef.addListener(themeListener);
    statePageRefrace.addListener(themeListener);
    super.dispose();
  }

  @override
  void initState() {
    languageRef.addListener(themeListener);
    statePageRefrace.addListener(themeListener);
    getinitfun();
    super.initState();
  }

  themeListener() {
    if (mounted) {
      setState(() {
        gettrandata();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              showDayPickDialog();
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  SizedBox(
                    height: 30,
                    width: 30,
                    child: IconButton(
                      padding: const EdgeInsets.all(5),
                      onPressed: () {
                        previousDatefun();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          height: 35,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                          ),
                          // width: 40,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              day.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${displayMonth(month)}, $year",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              displayDate(date).toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        localizedValues[language]!["home"]!["balance"]!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        "\u{20B9}${totalbalance()}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                    height: 30,
                    width: 30,
                    child: IconButton(
                      padding: const EdgeInsets.all(5),
                      onPressed: () {
                        nextdatefun();
                      },
                      icon: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          // Container(
          //   padding: const EdgeInsets.symmetric(
          //     vertical: 10,
          //   ),
          //   child: Row(
          //     children: const [
          //       Text(
          //         "C/F",
          //         style: TextStyle(
          //           color: Colors.grey,
          //           fontSize: 15,
          //         ),
          //       ),
          //       Spacer(),
          //       Text(
          //         "\u{20B9}0.00",
          //         style: TextStyle(
          //           color: Colors.grey,
          //           fontSize: 15,
          //           fontWeight: FontWeight.w500,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    localizedValues[language]!["home"]!["total-income"]!,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  "\u{20B9}${totalincome()}",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 0,
            ),
            child: Column(
              children: [
                for (var element in trancationDataList.reversed)
                  if (element.isIncome == 1)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        onTap: () {
                          log("Tap");
                        },
                        child: Row(
                          children: [
                            element.category!.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                      right: 3,
                                    ),
                                    child: geticonfun(element.category!
                                                .toLowerCase()) ==
                                            null
                                        ? Container(
                                            height: 18,
                                            width: 18,
                                            decoration: const BoxDecoration(
                                              color: Colors.black,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                element.category!
                                                    .substring(0, 1)
                                                    .toString(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Icon(
                                            geticonfun(element.category!
                                                .toLowerCase()),
                                            size: 18,
                                          ),
                                  )
                                : const SizedBox(),
                            Text(
                              element.name.toString(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 2,
                              ),
                              child: Text(
                                getaccount(
                                  element.uid,
                                  element.aid,
                                ).toString(),
                                style: TextStyle(
                                  color:
                                      getaccountColor(element.uid, element.aid),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "\u{20B9}${element.amount!.toStringAsFixed(2)}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                trancationDataList
                            .indexWhere((element) => element.isIncome == 1) ==
                        -1
                    ? const Padding(
                        padding: EdgeInsets.only(
                          bottom: 10,
                        ),
                        child: Text(
                          "Tap on + to add new item and long press to edit",
                        ),
                      )
                    : const SizedBox()
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    localizedValues[language]!["home"]!["total-expense"]!,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  "\u{20B9}${totalexpance().toString()}",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 0,
            ),
            child: Column(
              children: [
                for (var element in trancationDataList.reversed)
                  if (element.isIncome == 2)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          element.category!.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                    right: 3,
                                  ),
                                  child: geticonfun(element.category!
                                              .toLowerCase()) ==
                                          null
                                      ? Container(
                                          height: 18,
                                          width: 18,
                                          decoration: const BoxDecoration(
                                            color: Colors.black,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              element.category!
                                                  .substring(0, 1)
                                                  .toString(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Icon(
                                          geticonfun(
                                              element.category!.toLowerCase()),
                                          size: 18,
                                        ),
                                )
                              : const SizedBox(),
                          Text(
                            element.name.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 2,
                            ),
                            child: Text(
                              getaccount(
                                element.uid,
                                element.aid,
                              ).toString(),
                              style: TextStyle(
                                color:
                                    getaccountColor(element.uid, element.aid),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "\u{20B9}${element.amount!.toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                trancationDataList
                            .indexWhere((element) => element.isIncome == 2) ==
                        -1
                    ? const Padding(
                        padding: EdgeInsets.only(
                          bottom: 10,
                        ),
                        child: Text(
                          "Tap on + to add new item and long press to edit",
                        ),
                      )
                    : const SizedBox()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
