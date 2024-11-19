/*
  Copyright 2024 Srisoftwarez. All rights reserved.
  Use of this source code is governed by a BSD-style license that can be
  found in the LICENSE file.
*/

import 'package:flutter/material.dart';
import '/language/applanguage.dart';
import 'package:intl/intl.dart';
import '../../main.dart';
import '../datefun.dart';
import '../db/datamodel.dart';
import '../db/dbservice.dart';

class Monthly extends StatefulWidget {
  const Monthly({super.key});

  @override
  State<Monthly> createState() => _MonthlyState();
}

class _MonthlyState extends State<Monthly> {
  String firstdate = "";
  String lastDate = "";
  String normal = "";
  String month = "";
  DateTime crtdate = DateTime.now();
  var userSerive = DateService();
  late List<MonthlyDayOrder> trancationDataList = [];
  getinitfun() async {
    DateFun findDate = DateFun(inidate: crtdate);
    var resultDate = await findDate.getMonthlyInfo();
    if (resultDate != null) {
      setState(() {
        firstdate = resultDate["first"];
        lastDate = resultDate["last"];
        normal = resultDate["normal"].toString();
        month = resultDate["month"].toString();
      });
      gettrandata();
    }
  }

  previousDatefun() async {
    DateTime nxtday = DateTime(crtdate.year, crtdate.month - 1, crtdate.day);
    setState(() {
      crtdate = nxtday;
    });
    DateFun findDate = DateFun(inidate: nxtday);
    var resultDate = await findDate.getMonthlyInfo();
    if (resultDate != null) {
      setState(() {
        firstdate = resultDate["first"];
        lastDate = resultDate["last"];
        normal = resultDate["normal"];
        month = resultDate["month"];
      });
      gettrandata();
    }
  }

  nextdatefun() async {
    DateTime nxtday = DateTime(crtdate.year, crtdate.month + 1, crtdate.day);
    setState(() {
      crtdate = nxtday;
    });
    DateFun findDate = DateFun(inidate: nxtday);
    var resultDate = await findDate.getMonthlyInfo();
    if (resultDate != null) {
      setState(() {
        firstdate = resultDate["first"];
        lastDate = resultDate["last"];
        normal = resultDate["normal"].toString();
        month = resultDate["month"].toString();
      });
      gettrandata();
    }
  }

  gettrandata() async {
    setState(() {
      trancationDataList.clear();
    });
    // var data = await userSerive.crtMonthData(firstdate, lastDate);
    var data = await userSerive.crtMonthData(
        DateTime.parse(firstdate).toIso8601String(),
        DateTime.parse(lastDate).toIso8601String());
    if (data != null) {
      setState(() {
        for (var i = 0; i < int.parse(data.length.toString()); i++) {
          if (i >= 1 &&
              data[i - 1]["transcationdate"] == data[i]["transcationdate"]) {
            var tranmodel = TranscationModel();
            tranmodel.name = data[i]['name'].toString();
            tranmodel.transcationdate = data[i]['transcationdate'].toString();
            tranmodel.amount = double.parse(data[i]['amount'].toString());
            tranmodel.describe = data[i]['describe'].toString();
            tranmodel.isIncome = int.parse(data[i]["isincome"].toString());
            if (data[i]["isincome"].toString() == "1") {
              trancationDataList[trancationDataList.length - 1]
                  .income!
                  .add(tranmodel);
            } else {
              trancationDataList[trancationDataList.length - 1]
                  .expance!
                  .add(tranmodel);
            }
          } else {
            var tranmodel = TranscationModel();
            tranmodel.name = data[i]['name'].toString();
            tranmodel.transcationdate = data[i]['transcationdate'].toString();
            tranmodel.amount = double.parse(data[i]['amount'].toString());
            tranmodel.describe = data[i]['describe'].toString();
            tranmodel.isIncome = int.parse(data[i]["isincome"].toString());
            if (data[i]["isincome"].toString() == "1") {
              trancationDataList.add(
                MonthlyDayOrder(
                  date: data[i]['transcationdate'].toString(),
                  income: [tranmodel],
                  expance: [],
                ),
              );
            } else {
              trancationDataList.add(
                MonthlyDayOrder(
                  date: data[i]['transcationdate'].toString(),
                  income: [],
                  expance: [tranmodel],
                ),
              );
            }
          }
        }
      });
    }
  }

  calInExBalance(
      List<TranscationModel> income, List<TranscationModel> expance) {
    String result = "";
    double total = 0.00;
    double totalIncome = 0.00;
    double totalExpance = 0.00;
    for (var incomeElement in income) {
      totalIncome += incomeElement.amount!;
    }
    for (var expanceElement in expance) {
      totalExpance += expanceElement.amount!;
    }
    total = totalIncome - totalExpance;
    result = total.toStringAsFixed(2);
    return result;
  }

  totalincome() {
    String result = "";
    double total = 0.00;
    for (var element in trancationDataList) {
      for (var incomeElement in element.income!) {
        total += incomeElement.amount!;
      }
    }
    result = total.toStringAsFixed(2);
    return result;
  }

  totalexpance() {
    String result = "";
    double total = 0.00;
    for (var element in trancationDataList) {
      for (var expanceElement in element.expance!) {
        total += expanceElement.amount!;
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
                      displayMonth(month),
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${localizedValues[language]!["home"]!["total-income"]!} =",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "\u{20B9}${totalincome()}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // const Text(
                      //   "C/F : \u{20B9}0.00",
                      //   style: TextStyle(
                      //     color: Colors.black,
                      //     fontSize: 14,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${localizedValues[language]!["home"]!["total-expense"]!} =",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "\u{20B9}${totalexpance()}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "${localizedValues[language]!["home"]!["balance"]!} : \u{20B9} ${totalbalance()}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: trancationDataList.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    border: Border.all(
                      width: 1,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          DateFormat('dd-MM-yyyy')
                              .format(DateTime.parse(
                                  trancationDataList[index].date!))
                              .toString(),
                          // trancationDataList[index].date!.toString()
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
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
                              children: [
                                Center(
                                  child: Text(
                                    localizedValues[language]!["home"]![
                                        "income"]!,
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                for (var incomeDate
                                    in trancationDataList[index].income!)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            incomeDate.name!,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        Text(
                                          "\u{20B9}${incomeDate.amount}",
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Center(
                                  child: Text(
                                    localizedValues[language]!["home"]![
                                        "expense"]!,
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                for (var expanceData
                                    in trancationDataList[index].expance!)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            expanceData.name!,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        Text(
                                          "\u{20B9}${expanceData.amount}",
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        alignment: Alignment.centerRight,
                        child: Text(
                          "${localizedValues[language]!["home"]!["balance"]!} = \u{20B9}${calInExBalance(trancationDataList[index].income!, trancationDataList[index].expance!)}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
