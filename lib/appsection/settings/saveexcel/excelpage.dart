/*
  Copyright 2024 Srisoftwarez. All rights reserved.
  Use of this source code is governed by a BSD-style license that can be
  found in the LICENSE file.
*/

import 'package:flutter/material.dart';
import '/appsection/settings/saveexcel/exceldownload.dart';
import '/appui/alartbox.dart';
import 'package:intl/intl.dart';
import '../../../language/applanguage.dart';
import '../../../main.dart';
import '../../db/datamodel.dart';
import '../../db/dbservice.dart';

class ExcelPage extends StatefulWidget {
  const ExcelPage({super.key});

  @override
  State<ExcelPage> createState() => _ExcelPageState();
}

class _ExcelPageState extends State<ExcelPage> {
  bool alltime = false;
  bool yearly = false;
  bool monthly = false;
  bool custom = false;
  String exportType = "all";
  var userSerive = DateService();

  TextEditingController month = TextEditingController();
  TextEditingController fromdate = TextEditingController();
  TextEditingController toDate = TextEditingController();

  List<DropdownMenuItem> yearMenu = [];
  String yeardisplay = "";
  String monthDisplayMonth = "";
  String monthDisplayYear = "";
  String customStartDate = "";
  String customEndDate = "";

  createdata(dynamic data) {
    List<ExcelDataModel> exceldata = [];
    for (var i = 0; i < data.length; i++) {
      exceldata.add(
        ExcelDataModel(
          name: data[i]['name'],
          amount: double.parse(data[i]['amount'].toString()),
          describe: data[i]['describe'],
          transcationdate: data[i]['transcationdate'],
          isIncome: data[i]['isincome'],
        ),
      );
    }
    return exceldata;
  }

  readData() async {
    if (alltime) {
      return await userSerive.readAllData();
    } else if (yearly) {
      final DateFormat normalformatter = DateFormat('yyyy-MM-dd');
      String fromDate =
          normalformatter.format(DateTime(int.parse(yeardisplay), 01, 01));
      String toDate =
          normalformatter.format(DateTime(int.parse(yeardisplay), 12, 31));
      return await userSerive.crtYearData(fromDate, toDate);
    } else if (monthly) {
      if (monthDisplayMonth.isNotEmpty && monthDisplayYear.isNotEmpty) {
        final DateFormat normalformatter = DateFormat('yyyy-MM-dd');
        DateTime lastDate = DateTime(
            int.parse(monthDisplayYear), int.parse(monthDisplayMonth) + 1, 0);
        String fromDate = normalformatter.format(DateTime(
            int.parse(monthDisplayYear), int.parse(monthDisplayMonth), 01));
        String toDate = normalformatter.format(DateTime(
            int.parse(monthDisplayYear),
            int.parse(monthDisplayMonth),
            lastDate.day));
        return await userSerive.crtYearData(fromDate, toDate);
      }
    } else if (custom) {
      if (customStartDate.isNotEmpty && customEndDate.isNotEmpty) {
        final DateFormat normalformatter = DateFormat('yyyy-MM-dd');
        String fromDate = normalformatter.parse(customStartDate).toString();
        String toDate = normalformatter.parse(customEndDate).toString();
        return await userSerive.crtYearData(fromDate, toDate);
      } else {
        return null;
      }
    }
  }

  downloadexcel() async {
    loading(context);
    ExcelDownload excelDownload = ExcelDownload();

    var data = await readData();
    Navigator.pop(context);
    if (data != null) {
      if (data.length > 0) {
        excelDownload.createExcel(context, excelData: await createdata(data));
      } else {
        erroralertshowSnackBar(context, "No Data Found");
      }
    } else {
      erroralertshowSnackBar(context, "No Data Found");
    }
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

  showDialogMonth() async {
    DateTime? data = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const CustomMonth();
      },
    );
    if (data != null) {
      setState(() {
        monthDisplayMonth = DateFormat("MM").format(data);
        monthDisplayYear = DateFormat("yyyy").format(data);
        month.text = "$monthDisplayMonth, $monthDisplayYear";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getyeardata();
  }

  void _handleExpansion(int panelIndex, bool isExpanded) {
    setState(() {
      switch (panelIndex) {
        case 0:
          alltime = !alltime;
          yearly = false;
          monthly = false;
          custom = false;
          break;
        case 1:
          yearly = !yearly;
          alltime = false;
          monthly = false;
          custom = false;
          break;
        case 2:
          monthly = !monthly;
          alltime = false;
          yearly = false;
          custom = false;
          break;
        case 3:
          custom = !custom;
          alltime = false;
          yearly = false;
          monthly = false;
          break;
        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizedValues[language]!["save-excel"]!["title"]!,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Row(
                        children: [
                          Text(
                            localizedValues[language]!["save-excel"]![
                                "export"]!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: ExpansionPanelList(
                        expandedHeaderPadding: const EdgeInsets.all(0),
                        elevation: 0,
                        expansionCallback: (panelIndex, isExpanded) {
                          _handleExpansion(panelIndex, isExpanded);
                        },
                        children: [
                          ExpansionPanel(
                            canTapOnHeader: true,
                            isExpanded: alltime,
                            headerBuilder: (context, isExpanded) {
                              return const ListTile(
                                title: Text('All Time'),
                              );
                            },
                            body: Column(
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    // Function to handle download
                                    downloadexcel();
                                  },
                                  icon: Icon(
                                    Icons.cloud_download,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  label: Text(
                                    'Download',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ExpansionPanel(
                            canTapOnHeader: true,
                            isExpanded: yearly,
                            headerBuilder: (context, isExpanded) {
                              return const ListTile(
                                title: Text('Yearly'),
                              );
                            },
                            body: Column(
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    // Function to handle download
                                    downloadexcel();
                                  },
                                  icon: Icon(
                                    Icons.cloud_download,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  label: Text(
                                    'Download',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ExpansionPanel(
                            canTapOnHeader: true,
                            isExpanded: monthly,
                            headerBuilder: (context, isExpanded) {
                              return const ListTile(
                                title: Text('Monthly'),
                              );
                            },
                            body: Column(
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    // Function to handle download
                                    downloadexcel();
                                  },
                                  icon: Icon(
                                    Icons.cloud_download,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  label: Text(
                                    'Download',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ExpansionPanel(
                            canTapOnHeader: true,
                            isExpanded: custom,
                            headerBuilder: (context, isExpanded) {
                              return const ListTile(
                                title: Text('Custom'),
                              );
                            },
                            body: Column(
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    // Function to handle download
                                    downloadexcel();
                                  },
                                  icon: Icon(
                                    Icons.cloud_download,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  label: Text(
                                    'Download',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomMonth extends StatefulWidget {
  const CustomMonth({super.key});

  @override
  State<CustomMonth> createState() => _CustomMonthState();
}

class _CustomMonthState extends State<CustomMonth> {
  DateTime selectedDate = DateTime.now();

  int selectedMonth = 1;
  int selectedYear = 2023;

  @override
  void initState() {
    super.initState();
    selectedMonth = selectedDate.month;
    selectedYear = selectedDate.year;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text('Select Month and Year'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Customize the appearance of the date picker
            Theme(
              data: ThemeData(
                primarySwatch: Colors.blue,
                dialogBackgroundColor: Colors.white,
                textTheme: const TextTheme(
                  titleMedium: TextStyle(fontSize: 20.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Month picker
                  DropdownButton<int>(
                    value: selectedMonth,
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedMonth = newValue!;
                      });
                    },
                    items:
                        List<DropdownMenuItem<int>>.generate(12, (int index) {
                      return DropdownMenuItem<int>(
                        value: index + 1,
                        child: Text('${index + 1}'),
                      );
                    }),
                  ),

                  // Year picker
                  DropdownButton<int>(
                    value: selectedYear,
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedYear = newValue!;
                      });
                    },
                    items:
                        List<DropdownMenuItem<int>>.generate(10, (int index) {
                      return DropdownMenuItem<int>(
                        value: selectedDate.year + index,
                        child: Text('${selectedDate.year + index}'),
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                selectedDate = DateTime(selectedYear, selectedMonth);
                Navigator.of(context).pop(selectedDate);
              },
            ),
          ],
        ),
      ),
    );
  }
}
