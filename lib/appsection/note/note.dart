/*
  Copyright 2024 Srisoftwarez. All rights reserved.
  Use of this source code is governed by a BSD-style license that can be
  found in the LICENSE file.
*/

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../appconfig/appconfig.dart';
import '../../language/applanguage.dart';
import '../../main.dart';
import '../datefun.dart';
import '../db/datamodel.dart';
import '../db/dbservice.dart';

EditNoteState editNoteState = EditNoteState();

TextEditingController todotext = TextEditingController();
String editdate = "";
String notenormal = "";
String notedate = "";
String noteday = "";
String notemonth = "";
String noteyear = "";
DateTime notecrtdate = DateTime.now();

class Note extends StatefulWidget {
  const Note({super.key});

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
  String firstdate = "";
  String lastDate = "";
  String normal = "";
  String month = "";
  String year = "";
  DateTime crtdate = DateTime.now();
  var userSerive = DateService();
  List<NoteModel> noteDataList = [];

  getinitfun() async {
    DateFun findDate = DateFun(inidate: crtdate);
    var resultDate = await findDate.getMonthlyInfo();
    if (resultDate != null) {
      log(resultDate.toString());
      setState(() {
        firstdate = resultDate["first"];
        lastDate = resultDate["last"];
        normal = resultDate["normal"].toString();
        month = resultDate["month"].toString();
        year = resultDate["year"].toString();
      });
      gettrandata();
    }
  }

  getinitnotefun() async {
    DateFun notefindDate = DateFun(inidate: notecrtdate);
    var noteresultDate = await notefindDate.getDailyInfo();
    if (noteresultDate != null) {
      setState(() {
        notenormal = noteresultDate["normal"].toString();
        notedate = noteresultDate["date"].toString();
        noteday = noteresultDate["day"].toString();
        notemonth = noteresultDate["month"].toString();
        noteyear = noteresultDate["year"].toString();
      });
      getnoteDatafun();
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
        year = resultDate["year"].toString();
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
        year = resultDate["year"].toString();
      });
      gettrandata();
    }
  }

  gettrandata() async {
    setState(() {
      noteDataList.clear();
    });
    // var data = await userSerive.crtMonthData(firstdate, lastDate);
    var data = await userSerive.getNote(
      DateTime.parse(firstdate).toIso8601String(),
      DateTime.parse(lastDate).toIso8601String(),
    );
    if (data != null) {
      log(data.toString());
      setState(() {
        for (var element in data) {
          var noteModelData = NoteModel();
          noteModelData.notetodo = element['notetodo'].toString();
          noteModelData.transcationdate = element['transcationdate'].toString();
          noteDataList.add(noteModelData);
        }
      });
    }
  }

  previousNoteDatefun() async {
    DateTime nxtday = crtdate.add(const Duration(days: -1));
    setState(() {
      crtdate = nxtday;
    });
    DateFun findDate = DateFun(inidate: nxtday);
    var resultDate = await findDate.getDailyInfo();
    if (resultDate != null) {
      setState(() {
        notenormal = resultDate["normal"];
        notedate = resultDate["date"];
        noteday = resultDate["day"];
        notemonth = resultDate["month"];
        noteyear = resultDate["year"];
      });
      getnoteDatafun();
    }
  }

  nextNotedatefun() async {
    DateTime nxtday = crtdate.add(const Duration(days: 1));
    setState(() {
      crtdate = nxtday;
    });
    DateFun findDate = DateFun(inidate: nxtday);
    var resultDate = await findDate.getDailyInfo();
    if (resultDate != null) {
      setState(() {
        notenormal = resultDate["normal"].toString();
        notedate = resultDate["date"].toString();
        noteday = resultDate["day"].toString();
        notemonth = resultDate["month"].toString();
        noteyear = resultDate["year"].toString();
      });
      getnoteDatafun();
    }
  }

  getnoteDatafun() async {
    var data = await userSerive.getNoteDate(
      DateTime.parse(notenormal).toIso8601String(),
    );
    if (data != null) {
      if (data.isNotEmpty) {
        setState(() {
          log("is update is true");
          editNoteState.toggleUpdate(true);
          log("isupdate Data : ${editNoteState.isUpdate}");
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

  @override
  void dispose() {
    languageRef.addListener(themeListener);
    editNoteState.addListener(themeListener);
    super.dispose();
  }

  @override
  void initState() {
    getinitfun();
    getinitnotefun();
    languageRef.addListener(themeListener);
    editNoteState.addListener(themeListener);
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
    if (editNoteState.stateRefrece) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
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
                        previousNoteDatefun();
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
                              noteday.toString(),
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
                              "${displayMonth(notemonth)}, $noteyear",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              notedate.toString(),
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
                  const SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                    height: 30,
                    width: 30,
                    child: IconButton(
                      padding: const EdgeInsets.all(5),
                      onPressed: () {
                        nextNotedatefun();
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
            Expanded(
              child: TextFormField(
                controller: todotext,
                autofocus: true,
                expands: true,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: "To Do",
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      );
    } else {
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
                        "${displayMonth(month)} $year",
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
            noteDataList.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: noteDataList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${DateFormat('dd ').format(
                              DateTime.parse(
                                  noteDataList[index].transcationdate!),
                            )}${displayMonth(DateFormat('MMMM').format(
                              DateTime.parse(
                                  noteDataList[index].transcationdate!),
                            ))} ${DateFormat(' yyyy. ').format(
                              DateTime.parse(
                                  noteDataList[index].transcationdate!),
                            )}${displayDate(DateFormat('EEEE').format(
                              DateTime.parse(
                                  noteDataList[index].transcationdate!),
                            ))}",

                            // "23 January, 2023. Monday",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 15,
                            ),
                          ),
                          const Divider(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              noteDataList[index].notetodo.toString(),
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  )
                : Container(
                    padding: const EdgeInsets.all(15),
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Text(
                        localizedValues[language]!["home"]!["no-notes"]!,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
          ],
        ),
      );
    }
  }
}
