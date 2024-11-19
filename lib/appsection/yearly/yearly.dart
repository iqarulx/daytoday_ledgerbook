/*
  Copyright 2024 Srisoftwarez. All rights reserved.
  Use of this source code is governed by a BSD-style license that can be
  found in the LICENSE file.
*/

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../language/applanguage.dart';
import '../../main.dart';
import '../datefun.dart';
import '../db/datamodel.dart';
import '../db/dbservice.dart';

class Yearly extends StatefulWidget {
  const Yearly({super.key});

  @override
  State<Yearly> createState() => _YearlyState();
}

class _YearlyState extends State<Yearly> {
  String firstdate = "";
  String lastDate = "";
  String year = "";
  EdgeInsets headerPadding = const EdgeInsets.all(2);
  EdgeInsets contentPadding = const EdgeInsets.all(2);
  var userSerive = DateService();
  List<TranscationModel> tempList = [];
  List<YearOrder> trancationDataList = [];
  DateTime crtdate = DateTime.now();

  getinitfun() async {
    DateFun findDate = DateFun(inidate: crtdate);
    var resultDate = await findDate.getYearlyInfo();
    if (resultDate != null) {
      log(resultDate.toString());
      setState(() {
        firstdate = resultDate["first"];
        lastDate = resultDate["last"];
        year = resultDate["year"].toString();
      });
      gettrandata();
    }
  }

  previousDatefun() async {
    DateTime nxtday = DateTime(crtdate.year - 1, crtdate.month, crtdate.day);
    setState(() {
      crtdate = nxtday;
    });
    DateFun findDate = DateFun(inidate: nxtday);
    var resultDate = await findDate.getYearlyInfo();
    if (resultDate != null) {
      log(resultDate.toString());
      setState(() {
        firstdate = resultDate["first"];
        lastDate = resultDate["last"];
        year = resultDate["year"].toString();
      });
      gettrandata();
    }
  }

  nextdatefun() async {
    DateTime nxtday = DateTime(crtdate.year + 1, crtdate.month, crtdate.day);
    setState(() {
      crtdate = nxtday;
    });
    DateFun findDate = DateFun(inidate: nxtday);
    var resultDate = await findDate.getYearlyInfo();
    if (resultDate != null) {
      log(resultDate.toString());
      setState(() {
        firstdate = resultDate["first"];
        lastDate = resultDate["last"];
        year = resultDate["year"].toString();
      });
      gettrandata();
    }
  }

  gettrandata() async {
    setState(() {
      trancationDataList.clear();
      tempList.clear();
    });
    var data = await userSerive.crtYearData(
      DateTime.parse(firstdate).toIso8601String(),
      DateTime.parse(lastDate).toIso8601String(),
    );
    if (data != null) {
      log(data.toString());
      data.forEach((dataElement) {
        setState(() {
          var tranmodel = TranscationModel();
          tranmodel.name = dataElement['name'];
          tranmodel.transcationdate = dataElement['transcationdate'];
          tranmodel.amount = double.parse(dataElement['amount'].toString());
          tranmodel.describe = dataElement['describe'];
          tranmodel.isIncome = dataElement['isincome'];
          tempList.add(tranmodel);
        });
      });
      for (int i = 0; i < tempList.length; i++) {
        log("${tempList[i].name.toString()} - ${DateFormat('MM').format(DateTime.parse(tempList[i].transcationdate.toString()))} - ${tempList[i].amount.toString()}");
        if (i == 0) {
          if (tempList[i].isIncome == 1) {
            trancationDataList.add(
              YearOrder(
                month: DateFormat('MMM').format(
                    DateTime.parse(tempList[i].transcationdate.toString())),
                income: tempList[i].amount!,
                expance: 0.00,
                balance: tempList[i].amount!,
              ),
            );
          } else {
            trancationDataList.add(
              YearOrder(
                month: DateFormat('MMM').format(
                    DateTime.parse(tempList[i].transcationdate.toString())),
                income: 0.00,
                expance: tempList[i].amount!,
                balance: -tempList[i].amount!,
              ),
            );
          }
        } else {
          if (DateFormat('MM').format(
                  DateTime.parse(tempList[i].transcationdate.toString())) ==
              DateFormat('MM').format(
                  DateTime.parse(tempList[i - 1].transcationdate.toString()))) {
            if (tempList[i].isIncome == 1) {
              trancationDataList.last.income =
                  trancationDataList.last.income + tempList[i].amount!;
              trancationDataList.last.balance =
                  trancationDataList.last.balance + tempList[i].amount!;
            } else {
              trancationDataList.last.expance =
                  trancationDataList.last.expance + tempList[i].amount!;
              trancationDataList.last.balance =
                  trancationDataList.last.balance - tempList[i].amount!;
            }
          } else {
            trancationDataList.add(
              YearOrder(
                month: DateFormat('MMM').format(
                    DateTime.parse(tempList[i].transcationdate.toString())),
                income: tempList[i].amount!,
                expance: 0.00,
                balance: tempList[i].amount!,
              ),
            );
          }
        }
      }
      for (int i = 0; i < trancationDataList.length; i++) {
        log("${trancationDataList[i].month.toString()} - ${trancationDataList[i].income.toString()}");
      }
      // setState(() {
      //   for (var i = 0; i < int.parse(data.length.toString()); i++) {
      //     if (i>0 && ) {

      //     }
      //     else{
      //       trancationDataList.add(YearOrder(month: 'month', income: income, expance: expance, balance: balance))
      //     }
      //   }
      // });
      // setState(() {
      //   for (var i = 0; i < int.parse(data.length.toString()); i++) {
      //     if (i >= 1 &&
      //         data[i - 1]["transcationdate"] == data[i]["transcationdate"]) {
      //       var tranmodel = TranscationModel();
      //       tranmodel.name = data[i]['name'].toString();
      //       tranmodel.transcationdate = data[i]['transcationdate'].toString();
      //       tranmodel.amount = double.parse(data[i]['amount'].toString());
      //       tranmodel.describe = data[i]['describe'].toString();
      //       tranmodel.isIncome = int.parse(data[i]["isincome"].toString());
      //       if (data[i]["isincome"].toString() == "1") {
      //         trancationDataList[trancationDataList.length - 1]
      //             .income!
      //             .add(tranmodel);
      //       } else {
      //         trancationDataList[trancationDataList.length - 1]
      //             .expance!
      //             .add(tranmodel);
      //       }
      //     } else {
      //       var tranmodel = TranscationModel();
      //       tranmodel.name = data[i]['name'].toString();
      //       tranmodel.transcationdate = data[i]['transcationdate'].toString();
      //       tranmodel.amount = double.parse(data[i]['amount'].toString());
      //       tranmodel.describe = data[i]['describe'].toString();
      //       tranmodel.isIncome = int.parse(data[i]["isincome"].toString());
      //       if (data[i]["isincome"].toString() == "1") {
      //         trancationDataList.add(
      //           MonthlyDayOrder(
      //             date: data[i]['transcationdate'].toString(),
      //             income: [tranmodel],
      //             expance: [],
      //           ),
      //         );
      //       } else {
      //         trancationDataList.add(
      //           MonthlyDayOrder(
      //             date: data[i]['transcationdate'].toString(),
      //             income: [],
      //             expance: [tranmodel],
      //           ),
      //         );
      //       }
      //     }
      //   }
      // });
    }
  }

  @override
  void initState() {
    super.initState();
    languageRef.addListener(themeListener);
    getinitfun();
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
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
                  child: Center(
                    child: Text(
                      year.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
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
          const SizedBox(
            height: 10,
          ),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(1.6),
              1: FlexColumnWidth(4),
              2: FlexColumnWidth(4),
              3: FlexColumnWidth(3.5),
            },
            children: [
              TableRow(
                children: [
                  Container(
                    padding: headerPadding,
                    alignment: Alignment.centerLeft,
                    child: const Text(""),
                  ),
                  Container(
                    padding: headerPadding,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      localizedValues[language]!["home"]!["income"]!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: headerPadding,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      localizedValues[language]!["home"]!["expense"]!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: headerPadding,
                    alignment: Alignment.centerRight,
                    child: Text(
                      localizedValues[language]!["home"]!["balance"]!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              // TableRow(
              //   children: [
              //     Container(
              //       padding: contentPadding,
              //       alignment: Alignment.centerLeft,
              //       child: const Text("C/F"),
              //     ),
              //     Container(
              //       padding: contentPadding,
              //       alignment: Alignment.centerLeft,
              //       child: const Text(""),
              //     ),
              //     Container(
              //       padding: contentPadding,
              //       alignment: Alignment.centerLeft,
              //       child: const Text(""),
              //     ),
              //     Container(
              //       padding: contentPadding,
              //       alignment: Alignment.centerRight,
              //       child: const Text("\u{20B9}0.00"),
              //     ),
              //   ],
              // ),
              for (var yearElement in trancationDataList)
                TableRow(
                  children: [
                    Container(
                      padding: contentPadding,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        displayMonth(yearElement.month),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: contentPadding,
                      alignment: Alignment.centerLeft,
                      child: Text(
                          "\u{20B9}${yearElement.income.toStringAsFixed(2)}"),
                    ),
                    Container(
                      padding: contentPadding,
                      alignment: Alignment.centerLeft,
                      child: Text(
                          "\u{20B9}${yearElement.expance.toStringAsFixed(2)}"),
                    ),
                    Container(
                      padding: contentPadding,
                      alignment: Alignment.centerRight,
                      child: Text(
                          "\u{20B9}${yearElement.balance.toStringAsFixed(2)}"),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
