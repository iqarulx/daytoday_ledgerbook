/*
  Copyright 2024 Srisoftwarez. All rights reserved.
  Use of this source code is governed by a BSD-style license that can be
  found in the LICENSE file.
*/

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/appsection/db/datamodel.dart';
import '/appsection/db/dbservice.dart';
import 'package:intl/intl.dart';

class AddTranscation extends StatefulWidget {
  const AddTranscation({super.key});

  @override
  State<AddTranscation> createState() => _AddTranscationState();
}

class _AddTranscationState extends State<AddTranscation> {
  final _incomeformKey = GlobalKey<FormState>();
  final _expanceformKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController descr = TextEditingController();
  TextEditingController incomedate = TextEditingController();

  TextEditingController expancename = TextEditingController();
  TextEditingController expanceamount = TextEditingController();
  TextEditingController expancedescr = TextEditingController();
  TextEditingController expancedate = TextEditingController();

  var userSerive = DateService();
  late List<TranscationModel> trancationDataList = [];

  // getinifun() async {
  //   var data = await userSerive.readAllData();
  //   log(data.toString());
  //   data.forEach((user) {
  //     setState(() {
  //       var tranmodel = TranscationModel();
  //       tranmodel.name = user['name'].toString();
  //       tranmodel.transcationdate = user['transcationdate'].toString();
  //       tranmodel.amount = double.parse(user['amount'].toString());
  //       tranmodel.describe = user['describe'].toString();
  //       tranmodel.isIncome = user['isincome'];
  //       trancationDataList.add(tranmodel);
  //     });
  //   });
  // }

  addtranscationfun(String data) async {
    var transcationData = TranscationModel();

    if (data == "income") {
      transcationData.name = name.text;
      transcationData.amount = double.parse(amount.text.toString());
      transcationData.transcationdate =
          DateTime.parse(incomedate.text).toIso8601String();
      transcationData.describe = descr.text;
      transcationData.isIncome = 1;
      var result = await userSerive.saveData(transcationData);
      log("Result : ${result.toString()}");
      if (result > 0 && result != null) {
        Navigator.pop(context);
      }
    } else {
      transcationData.name = expancename.text;
      transcationData.amount = double.parse(expanceamount.text.toString());
      transcationData.transcationdate =
          DateTime.parse(expancedate.text).toIso8601String();
      transcationData.describe = expancedescr.text;
      transcationData.isIncome = 2;
      var result = await userSerive.saveData(transcationData);
      log("Result : ${result.toString()}");
      if (result > 0 && result != null) {
        Navigator.pop(context);
      }
    }
  }

  @override
  void initState() {
    // getinifun();

    incomedate.text =
        DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    expancedate.text =
        DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
          backgroundColor: const Color(0xff6666ff),
          titleSpacing: 0,
          title: const Text(
            "Add New Transcation",
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          elevation: 0,
          bottom: TabBar(
            onTap: (value) {
              setState(() {});
            },
            isScrollable: false,
            indicatorColor: Colors.white,
            tabs: const [
              Tab(
                text: "Income (Credit)",
              ),
              Tab(
                text: "Expance (Debit)",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: _incomeformKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      readOnly: true,
                      controller: incomedate,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        label: Text("Income Date"),
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                        focusColor: Color(0xff6666ff),
                        hintText: "Date",
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff6666ff),
                          ),
                        ),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            incomedate.text = DateFormat('yyyy-MM-dd')
                                .format(pickedDate)
                                .toString();
                          });
                        }
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Choose Income Date";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: name,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        label: Text("Transcation Name"),
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                        focusColor: Color(0xff6666ff),
                        hintText: "Enter Detail",
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff6666ff),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Transcation Name is Must";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: amount,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label: Text("Amount"),
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                        focusColor: Color(0xff6666ff),
                        hintText: "Amount",
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff6666ff),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Amount is Must";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: descr,
                      maxLines: 5,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        focusColor: Color(0xff6666ff),
                        hintText: "Describe here",
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff6666ff),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff000000),
                        ),
                        onPressed: () async {
                          addtranscationfun("income");
                        },
                        child: const Text("Save"),
                      ),
                    ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // ListView.builder(
                    //   shrinkWrap: true,
                    //   physics: const NeverScrollableScrollPhysics(),
                    //   itemCount: trancationDataList.length,
                    //   itemBuilder: (context, index) {
                    //     return ListTile(
                    //       title: Text(
                    //         trancationDataList[index].name.toString(),
                    //       ),
                    //       subtitle: Text(
                    //         "${trancationDataList[index].isIncome == 1 ? "Income : ${trancationDataList[index].amount} " : "Expance : ${trancationDataList[index].amount} "}\n${DateTime.parse(trancationDataList[index].transcationdate!)}\n",
                    //       ),
                    //     );
                    //   },
                    // )
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: _expanceformKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      readOnly: true,
                      controller: expancedate,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        label: Text("Expance Date"),
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                        focusColor: Color(0xff6666ff),
                        hintText: "Date",
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff6666ff),
                          ),
                        ),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            expancedate.text = DateFormat('yyyy-MM-dd')
                                .format(pickedDate)
                                .toString();
                          });
                        }
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Choose Expance Date";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: expancename,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        label: Text("Transcation Name"),
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                        focusColor: Color(0xff6666ff),
                        hintText: "Enter Detail",
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff6666ff),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Transcation Name is Must";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: expanceamount,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label: Text("Amount"),
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                        focusColor: Color(0xff6666ff),
                        hintText: "Amount",
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff6666ff),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Amount is Must";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: expancedescr,
                      maxLines: 5,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        focusColor: Color(0xff6666ff),
                        hintText: "Describe here",
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff6666ff),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff000000),
                        ),
                        onPressed: () {
                          addtranscationfun("expance");
                        },
                        child: const Text("Save"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
