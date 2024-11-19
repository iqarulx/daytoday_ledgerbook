/*
  Copyright 2024 Srisoftwarez. All rights reserved.
  Use of this source code is governed by a BSD-style license that can be
  found in the LICENSE file.
*/

import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import '/appsection/pdfcreatefun.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../appui/alartbox.dart';
import '../language/applanguage.dart';
import '../main.dart';
import 'datefun.dart';
import 'db/datamodel.dart';
import 'db/dbservice.dart';

class PdfPage extends StatefulWidget {
  final int firstFilter;
  const PdfPage({super.key, required this.firstFilter});

  @override
  State<PdfPage> createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  String firstdate = "";
  String lastDate = "";
  String normal = "";
  String month = "";
  String customFromDate = "";
  String customToDate = "";
  DateTime crtdate = DateTime.now();
  var userSerive = DateService();
  late List<TranscationModel> trancationDataList = [];
  List<NoteModel> noteDataList = [];
  List<List<List<TranscationModel>>> yearDataList = [];

  List<DropdownMenuItem> yearMenu = [];
  String yeardisplay = "";

  File? tmpFile;
  bool pdfview = false;
  int firstFilter = 0;
  int secoundFilter = 0;

  alltimePdf() async {
    setState(() {
      pdfview = false;
    });
    if (secoundFilter == 0 || secoundFilter == 1 || secoundFilter == 2) {
      await allTransc();
      if (secoundFilter == 1 || secoundFilter == 2) {
        setState(() {
          noteDataList.clear();
        });
      }
    }
    if (secoundFilter == 0 || secoundFilter == 3) {
      await allNoteData();
      if (secoundFilter == 3) {
        setState(() {
          yearDataList.clear();
        });
      }
    }
    log(noteDataList.length.toString());
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String datemodel = preferences.getString('dateformat')!;
    PdfCreation pdfCreation = PdfCreation(
      [],
      noteDataList,
      yearDataList,
      false,
      dateFormat: datemodel,
    );
    tmpFile = await pdfCreation.yearlyPdf();

    setState(() {
      pdfview = true;
    });
  }

  createPdf() async {
    setState(() {
      pdfview = false;
    });
    if (secoundFilter == 0 || secoundFilter == 1 || secoundFilter == 2) {
      await gettrandata();
      if (secoundFilter == 1 || secoundFilter == 2) {
        setState(() {
          noteDataList.clear();
        });
      }
    }
    if (secoundFilter == 0 || secoundFilter == 3) {
      if (secoundFilter == 3) {
        await getnoteData();
        if (secoundFilter == 3) {
          setState(() {
            trancationDataList.clear();
          });
        }
      }
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String datemodel = preferences.getString('dateformat')!;
    PdfCreation pdfCreation = PdfCreation(
      trancationDataList,
      noteDataList,
      [],
      false,
      dateFormat: datemodel,
    );
    tmpFile = await pdfCreation.monthlyPdfCreation();

    setState(() {
      pdfview = true;
    });
  }

  yearPdf() async {
    setState(() {
      pdfview = false;
    });
    if (secoundFilter == 0 || secoundFilter == 1 || secoundFilter == 2) {
      await yearlypdf();
      if (secoundFilter == 1 || secoundFilter == 2) {
        setState(() {
          noteDataList.clear();
        });
      }
    }
    if (secoundFilter == 0 || secoundFilter == 3) {
      await getyearlynote();
      if (secoundFilter == 3) {
        setState(() {
          yearDataList.clear();
        });
      }
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String datemodel = preferences.getString('dateformat')!;
    PdfCreation pdfCreation = PdfCreation(
      [],
      noteDataList,
      yearDataList,
      false,
      dateFormat: datemodel,
    );
    tmpFile = await pdfCreation.yearlyPdf();
    setState(() {
      pdfview = true;
    });
  }

  customPdf() async {
    setState(() {
      pdfview = false;
    });
    if (secoundFilter == 0 || secoundFilter == 1 || secoundFilter == 2) {
      await customgettrandata();
      if (secoundFilter == 1 || secoundFilter == 2) {
        setState(() {
          noteDataList.clear();
        });
      }
    }
    if (secoundFilter == 0 || secoundFilter == 3) {
      await customgetnoteData();
      if (secoundFilter == 3) {
        setState(() {
          trancationDataList.clear();
        });
      }
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String datemodel = preferences.getString('dateformat')!;
    PdfCreation pdfCreation = PdfCreation(
      trancationDataList,
      noteDataList,
      [],
      true,
      fromDate: customFromDate,
      toDate: customToDate,
      dateFormat: datemodel,
    );
    tmpFile = await pdfCreation.monthlyPdfCreation();

    setState(() {
      pdfview = true;
    });
  }

  chooseCustomDate() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Choose From Date"),
      ),
    );
    var fromDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1945),
      lastDate: DateTime.now(),
      helpText: "Choose From Date",
    );
    var dateFormat = DateFormat('yyyy-MM-dd');
    if (fromDate != null) {
      setState(() {
        customFromDate = dateFormat.format(fromDate);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Choose End Date"),
        ),
      );
      var lastDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1945),
        lastDate: DateTime.now(),
        helpText: "Choose End Date",
      );
      if (lastDate != null) {
        setState(() {
          customToDate = dateFormat.format(lastDate);
          firstFilter = 3;
        });
        customPdf();
      }
    }
  }

  getinitfun() async {
    DateFun findDate = DateFun(inidate: crtdate);
    var resultDate = await findDate.getMonthlyInfo();
    if (resultDate != null) {
      setState(() {
        firstdate = resultDate["first"].toString();
        lastDate = resultDate["last"].toString();
        normal = resultDate["normal"].toString();
        month = resultDate["month"].toString();
      });
    }
    createPdf();
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
    }
    createPdf();
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
        firstdate = resultDate["first"].toString();
        lastDate = resultDate["last"].toString();
        normal = resultDate["normal"].toString();
        month = resultDate["month"].toString();
      });
    }
    createPdf();
  }

  gettrandata() async {
    setState(() {
      trancationDataList.clear();
    });
    var data = secoundFilter == 0
        ? await userSerive.crtMonthData(
            DateTime.parse(firstdate).toIso8601String(),
            DateTime.parse(lastDate).toIso8601String(),
          )
        : await userSerive.crtIncomeMonthData(
            DateTime.parse(firstdate).toIso8601String(),
            DateTime.parse(lastDate).toIso8601String(),
            secoundFilter == 1 ? 2 : 1,
          );

    log(data.toString());
    data.forEach((user) {
      setState(() {
        var tranmodel = TranscationModel();
        tranmodel.name = user['name'];
        tranmodel.transcationdate = user['transcationdate'];
        tranmodel.amount = double.parse(user['amount'].toString());
        tranmodel.describe = user['describe'];
        tranmodel.isIncome = user['isincome'];
        trancationDataList.add(tranmodel);
      });
    });
  }

  customgettrandata() async {
    setState(() {
      trancationDataList.clear();
    });
    var data = secoundFilter == 0
        ? await userSerive.crtMonthData(
            DateTime.parse(customFromDate).toIso8601String(),
            DateTime.parse(customToDate).toIso8601String(),
          )
        : await userSerive.crtIncomeMonthData(
            DateTime.parse(customFromDate).toIso8601String(),
            DateTime.parse(customToDate).toIso8601String(),
            secoundFilter == 1 ? 2 : 1,
          );

    log(data.toString());
    data.forEach((user) {
      setState(() {
        var tranmodel = TranscationModel();
        tranmodel.name = user['name'];
        tranmodel.transcationdate = user['transcationdate'];
        tranmodel.amount = double.parse(user['amount'].toString());
        tranmodel.describe = user['describe'];
        tranmodel.isIncome = user['isincome'];
        trancationDataList.add(tranmodel);
      });
    });
  }

  customgetnoteData() async {
    setState(() {
      noteDataList.clear();
    });
    // var data = await userSerive.crtMonthData(firstdate, lastDate);

    var data = await userSerive.getNote(
      DateTime.parse(customFromDate).toIso8601String(),
      DateTime.parse(customToDate).toIso8601String(),
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
    return noteDataList;
  }

  // findyearlist() async {
  //   setState(() {
  //     yearDisplay.clear();
  //   });
  //   var data = await userSerive.readAllData();
  //   if (data != null) {
  //     for (var i = 0; i < data.length; i++) {
  //       if (i == 0) {
  //         yearDisplay.add(DropdownMenuItem(
  //           value: int.parse(
  //             DateFormat('yyyy').format(
  //               DateTime.parse(
  //                 data[i]['transcationdate']!,
  //               ),
  //             ),
  //           ),
  //           child: Text(
  //             DateFormat('yyyy').format(
  //               DateTime.parse(
  //                 data[i]['transcationdate']!,
  //               ),
  //             ),
  //           ),
  //         ));
  //       } else if (DateFormat('yyyy')
  //               .format(DateTime.parse(data[i - 1]['transcationdate']!)) !=
  //           DateFormat('yyyy')
  //               .format(DateTime.parse(data[i]['transcationdate']!))) {
  //         yearDisplay.add(DropdownMenuItem(
  //           value: int.parse(
  //             DateFormat('yyyy').format(
  //               DateTime.parse(
  //                 data[i]['transcationdate']!,
  //               ),
  //             ),
  //           ),
  //           child: Text(
  //             DateFormat('yyyy').format(
  //               DateTime.parse(
  //                 data[i]['transcationdate']!,
  //               ),
  //             ),
  //           ),
  //         ));
  //       }
  //     }
  //   }
  // }

  allTransc() async {
    setState(() {
      yearDataList.clear();
    });
    var data = secoundFilter == 0
        ? await userSerive.readAllData()
        : await userSerive.readAllIncomeData(secoundFilter == 1 ? 2 : 1);

    log(data.toString());
    if (data != null) {
      for (var i = 0; i < data.length; i++) {
        if (i >= 1 &&
            DateFormat('yyyy')
                    .format(DateTime.parse(data[i - 1]['transcationdate']!)) ==
                DateFormat('yyyy')
                    .format(DateTime.parse(data[i]['transcationdate']!))) {
          if (DateFormat('MM')
                  .format(DateTime.parse(data[i - 1]['transcationdate']!)) ==
              DateFormat('MM')
                  .format(DateTime.parse(data[i]['transcationdate']!))) {
            var tranmodel = TranscationModel();
            tranmodel.name = data[i]['name'];
            tranmodel.transcationdate = data[i]['transcationdate'];
            tranmodel.amount = double.parse(data[i]['amount'].toString());
            tranmodel.describe = data[i]['describe'];
            tranmodel.isIncome = data[i]['isincome'];
            trancationDataList.add(tranmodel);
            yearDataList.last.last.add(tranmodel);
          } else {
            var tranmodel = TranscationModel();
            tranmodel.name = data[i]['name'];
            tranmodel.transcationdate = data[i]['transcationdate'];
            tranmodel.amount = double.parse(data[i]['amount'].toString());
            tranmodel.describe = data[i]['describe'];
            tranmodel.isIncome = data[i]['isincome'];
            trancationDataList.add(tranmodel);
            yearDataList.last.add([tranmodel]);
          }
        } else {
          var tranmodel = TranscationModel();
          tranmodel.name = data[i]['name'];
          tranmodel.transcationdate = data[i]['transcationdate'];
          tranmodel.amount = double.parse(data[i]['amount'].toString());
          tranmodel.describe = data[i]['describe'];
          tranmodel.isIncome = data[i]['isincome'];

          yearDataList.add([
            [tranmodel]
          ]);
        }
      }
    }
    return yearDataList;
  }

  yearlypdf() async {
    setState(() {
      yearDataList.clear();
    });
    String fromDate = "";
    String toDate = "";
    final DateFormat normalformatter = DateFormat('yyyy-MM-dd');
    if (yeardisplay.isEmpty && yearMenu.isEmpty) {
      var time = DateTime.now();
      fromDate = normalformatter.format(DateTime(time.year, 01, 01));
      toDate = normalformatter.format(DateTime(time.year, 12, 31));
    } else {
      fromDate = normalformatter.format(
        DateTime(int.parse(yeardisplay), 01, 01),
      );
      toDate = normalformatter.format(
        DateTime(int.parse(yeardisplay), 12, 31),
      );
    }
    var data = secoundFilter == 0
        ? await userSerive.crtYearData(fromDate, toDate)
        : await userSerive.crtYearIncomeData(
            fromDate,
            toDate,
            secoundFilter == 1 ? 2 : 1,
          );
    if (data != null) {
      for (var i = 0; i < data.length; i++) {
        if (i >= 1 &&
            DateFormat('yyyy')
                    .format(DateTime.parse(data[i - 1]['transcationdate']!)) ==
                DateFormat('yyyy')
                    .format(DateTime.parse(data[i]['transcationdate']!))) {
          if (DateFormat('MM')
                  .format(DateTime.parse(data[i - 1]['transcationdate']!)) ==
              DateFormat('MM')
                  .format(DateTime.parse(data[i]['transcationdate']!))) {
            var tranmodel = TranscationModel();
            tranmodel.name = data[i]['name'];
            tranmodel.transcationdate = data[i]['transcationdate'];
            tranmodel.amount = double.parse(data[i]['amount'].toString());
            tranmodel.describe = data[i]['describe'];
            tranmodel.isIncome = data[i]['isincome'];
            trancationDataList.add(tranmodel);
            yearDataList.last.last.add(tranmodel);
          } else {
            var tranmodel = TranscationModel();
            tranmodel.name = data[i]['name'];
            tranmodel.transcationdate = data[i]['transcationdate'];
            tranmodel.amount = double.parse(data[i]['amount'].toString());
            tranmodel.describe = data[i]['describe'];
            tranmodel.isIncome = data[i]['isincome'];
            trancationDataList.add(tranmodel);
            yearDataList.last.add([tranmodel]);
          }
        } else {
          var tranmodel = TranscationModel();
          tranmodel.name = data[i]['name'];
          tranmodel.transcationdate = data[i]['transcationdate'];
          tranmodel.amount = double.parse(data[i]['amount'].toString());
          tranmodel.describe = data[i]['describe'];
          tranmodel.isIncome = data[i]['isincome'];

          yearDataList.add([
            [tranmodel]
          ]);
        }
      }
    }
    return yearDataList;
  }

  getyearlynote() async {
    setState(() {
      noteDataList.clear();
    });
    String fromDate = "";
    String toDate = "";
    final DateFormat normalformatter = DateFormat('yyyy-MM-dd');
    if (yeardisplay.isEmpty && yearMenu.isEmpty) {
      var time = DateTime.now();
      fromDate = normalformatter.format(DateTime(time.year, 01, 01));
      toDate = normalformatter.format(DateTime(time.year, 12, 31));
    } else {
      fromDate = normalformatter.format(
        DateTime(int.parse(yeardisplay), 01, 01),
      );
      toDate = normalformatter.format(
        DateTime(int.parse(yeardisplay), 12, 31),
      );
    }
    var data = await userSerive.getNote(
      DateTime.parse(fromDate).toIso8601String(),
      DateTime.parse(toDate).toIso8601String(),
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
    return noteDataList;
  }

  getnoteData() async {
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
    return noteDataList;
  }

  allNoteData() async {
    setState(() {
      noteDataList.clear();
    });
    // var data = await userSerive.crtMonthData(firstdate, lastDate);

    var data = await userSerive.readAllNoteData();
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
    return noteDataList;
  }

  getyeardata() async {
    setState(() {
      yearMenu.clear();
    });

    var data = await userSerive.readAllData();
    if (data != null) {
      setState(() {
        for (var i = 0; i < data.length; i++) {
          if (i >= 1 &&
              DateFormat('yyyy').format(
                      DateTime.parse(data[i - 1]['transcationdate']!)) ==
                  DateFormat('yyyy')
                      .format(DateTime.parse(data[i]['transcationdate']!))) {
            continue;
          } else {
            yearMenu.add(
              DropdownMenuItem(
                value: DateFormat('yyyy').format(
                  DateTime.parse(data[i]['transcationdate']!),
                ),
                child: Text(
                  DateFormat('yyyy').format(
                    DateTime.parse(data[i]['transcationdate']!),
                  ),
                ),
              ),
            );
          }
        }
        if (data.length > 0) {
          yeardisplay = yearMenu.first.value;
        }
      });
    }
  }

  Future<bool> storeagePermission() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (androidInfo.version.sdkInt >= 33) {
      if (await Permission.photos.request().isGranted &&
          await Permission.videos.request().isGranted) {
        return true;
      } else {
        openAppSettings();
        return false;
      }
    } else {
      if (await Permission.storage.request().isGranted) {
        return true;
      } else {
        openAppSettings();
        return false;
      }
    }
  }

  downloadPDF() async {
    loading(context);
    if (pdfview && tmpFile != null) {
      if (await storeagePermission()) {
        var file = File(await downloadpath("MY Day Book"));
        file.writeAsBytesSync(tmpFile!.readAsBytesSync());
        successalertshowSnackBar(context, "PDF was Download your Phone");
      }
    } else {
      erroralertshowSnackBar(context, "PDF was Not Download");
    }

    Navigator.pop(context);
  }

  downloadpath(String filename) {
    Directory dir = Directory('/storage/emulated/0/Download');
    String time =
        DateFormat('yyyy-MM-dd-hh-mm-a').format(DateTime.now()).toString();
    return filename = "${dir.absolute.path}/$filename-$time.pdf";
  }

  @override
  void initState() {
    super.initState();
    firstFilter = widget.firstFilter;
    getinitfun();
    getyeardata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          localizedValues[language]!["pdf"]!["report"]!,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          downloadPDF();
        },
        child: const Icon(
          Icons.arrow_downward_outlined,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(
                      left: 10,
                    ),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            if (firstFilter != 0) {
                              setState(() {
                                firstFilter = 0;
                                customFromDate = "";
                                customToDate = "";
                              });
                              alltimePdf();
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 5),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: firstFilter == 0
                                  ? Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1)
                                  : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              localizedValues[language]!["pdf"]!["alltime"]!,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (firstFilter != 1) {
                              setState(() {
                                firstFilter = 1;
                                customFromDate = "";
                                customToDate = "";
                              });
                              createPdf();
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 5),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: firstFilter == 1
                                  ? Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1)
                                  : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: IconButton(
                                    padding: const EdgeInsets.all(0),
                                    onPressed: () {
                                      setState(() {
                                        firstFilter = 1;
                                      });
                                      previousDatefun();
                                    },
                                    icon: const Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      size: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Center(
                                  child: Text(
                                    displayMonth(month),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: IconButton(
                                    padding: const EdgeInsets.all(0),
                                    onPressed: () {
                                      setState(() {
                                        firstFilter = 1;
                                        customFromDate = "";
                                        customToDate = "";
                                      });
                                      nextdatefun();
                                    },
                                    icon: const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (firstFilter != 2) {
                              setState(() {
                                firstFilter = 2;
                                customFromDate = "";
                                customToDate = "";
                              });
                              yearPdf();
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 5),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: firstFilter == 2
                                  ? Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1)
                                  : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: SizedBox(
                              height: 20,
                              child: DropdownButton(
                                underline: const SizedBox(),
                                value: yeardisplay.isEmpty ? null : yeardisplay,
                                items: yearMenu,
                                onChanged: (value) {
                                  setState(() {
                                    yeardisplay = value;
                                    firstFilter = 2;
                                    customFromDate = "";
                                    customToDate = "";
                                  });
                                  yearPdf();
                                },
                              ),
                            ),
                            // child: Row(
                            //   children: const [
                            //     Text("2023"),
                            //     SizedBox(
                            //       width: 1,
                            //     ),
                            //     Icon(Icons.arrow_drop_down_outlined),
                            //   ],
                            // ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            chooseCustomDate();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 5),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: firstFilter == 3
                                  ? Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1)
                                  : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              customFromDate.isEmpty || customToDate.isEmpty
                                  ? localizedValues[language]!["pdf"]![
                                      "custom-date"]!
                                  : "$customFromDate - $customToDate",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
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
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(
                      left: 10,
                    ),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              secoundFilter = 0;
                            });

                            if (firstFilter == 0) {
                              alltimePdf();
                            } else if (firstFilter == 1) {
                              createPdf();
                            } else if (firstFilter == 2) {
                              yearPdf();
                            } else if (firstFilter == 3) {
                              customPdf();
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 5),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: secoundFilter == 0
                                  ? Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1)
                                  : Colors.grey.shade200,
                              border: Border.all(
                                width: 1,
                                color: Theme.of(context).primaryColor,
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              localizedValues[language]!["pdf"]!["all"]!,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              secoundFilter = 1;
                            });
                            if (firstFilter == 0) {
                              alltimePdf();
                            } else if (firstFilter == 1) {
                              createPdf();
                            } else if (firstFilter == 2) {
                              yearPdf();
                            } else if (firstFilter == 3) {
                              customPdf();
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 5),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: secoundFilter == 1
                                  ? Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1)
                                  : Colors.grey.shade200,
                              border: Border.all(
                                width: 1,
                                color: Theme.of(context).primaryColor,
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              localizedValues[language]!["pdf"]!["expense"]!,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              secoundFilter = 2;
                            });
                            if (firstFilter == 0) {
                              alltimePdf();
                            } else if (firstFilter == 1) {
                              createPdf();
                            } else if (firstFilter == 2) {
                              yearPdf();
                            } else if (firstFilter == 3) {
                              customPdf();
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 5),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: secoundFilter == 2
                                  ? Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1)
                                  : Colors.grey.shade200,
                              border: Border.all(
                                width: 1,
                                color: Theme.of(context).primaryColor,
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              localizedValues[language]!["pdf"]!["income"]!,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              secoundFilter = 3;
                            });
                            if (firstFilter == 0) {
                              alltimePdf();
                            } else if (firstFilter == 1) {
                              createPdf();
                            } else if (firstFilter == 2) {
                              yearPdf();
                            } else if (firstFilter == 3) {
                              customPdf();
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 5),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: secoundFilter == 3
                                  ? Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1)
                                  : Colors.grey.shade200,
                              border: Border.all(
                                width: 1,
                                color: Theme.of(context).primaryColor,
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              localizedValues[language]!["pdf"]!["note"]!,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
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
            Expanded(
              child: pdfview
                  ? Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: PDFView(
                          filePath: tmpFile!.path,
                          // enableSwipe: false,
                          enableSwipe: true,

                          autoSpacing: false,
                          pageFling: true,
                          pageSnap: false,
                          fitPolicy: FitPolicy.BOTH,
                          preventLinkNavigation: false,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),
            const SizedBox(
              height: 80,
            ),
          ],
        ),
      ),
    );
  }
}
