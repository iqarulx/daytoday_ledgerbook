/*
  Copyright 2024 Srisoftwarez. All rights reserved.
  Use of this source code is governed by a BSD-style license that can be
  found in the LICENSE file.
*/

import 'dart:developer';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:path_provider/path_provider.dart';

import 'db/datamodel.dart';

class PdfCreation {
  File? tmpFile;
  List<TranscationModel> monthData = [];
  List<List<List<TranscationModel>>> yearData = [];
  List<NoteModel> noteDataList = [];
  bool? isCustome;
  String? fromDate;
  String? toDate;
  String? dateFormat;

  PdfCreation(
    this.monthData,
    this.noteDataList,
    this.yearData,
    this.isCustome, {
    this.fromDate,
    this.toDate,
    this.dateFormat,
  });

  totalexpance() {
    String result = "";
    double total = 0.00;
    for (var element in monthData) {
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
    for (var element in monthData) {
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

  dateformatechange(String date) {
    return DateFormat(dateFormat).format(DateTime.parse(date)).toString();
  }

  createPdf() async {
    final pdf = pw.Document();
    const headerPadding = pw.EdgeInsets.all(3);
    const contentPadding = pw.EdgeInsets.all(3);
    var headerTextstyle = pw.TextStyle(
      color: PdfColors.white,
      fontSize: 10,
      fontWeight: pw.FontWeight.bold,
    );
    var contentTextstyle = const pw.TextStyle(
      color: PdfColors.black,
      fontSize: 10,
    );

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(10),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Center(
              child: pw.Text(
                'My Daybook',
                style: pw.TextStyle(
                  color: const PdfColor.fromInt(0xff6666ff),
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Text('04 February 2023, 09:54 Am'),
            pw.SizedBox(height: 10),
            pw.Center(
              child: pw.Text('January 2023'),
            ),
            pw.SizedBox(height: 5),
            pw.Table(
              border: pw.TableBorder.all(
                width: 1,
                color: PdfColors.black,
              ),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(
                    color: PdfColor.fromInt(0xff6666ff),
                  ),
                  children: [
                    pw.Center(
                      child: pw.Padding(
                        padding: headerPadding,
                        child: pw.Text(
                          "Date",
                          style: headerTextstyle,
                        ),
                      ),
                    ),
                    pw.Center(
                      child: pw.Padding(
                        padding: headerPadding,
                        child: pw.Text(
                          "Description",
                          style: headerTextstyle,
                        ),
                      ),
                    ),
                    pw.Center(
                      child: pw.Padding(
                        padding: headerPadding,
                        child: pw.Text(
                          "Category",
                          style: headerTextstyle,
                        ),
                      ),
                    ),
                    pw.Center(
                      child: pw.Padding(
                        padding: headerPadding,
                        child: pw.Text(
                          "Income (Credit)",
                          style: headerTextstyle,
                        ),
                      ),
                    ),
                    pw.Center(
                      child: pw.Padding(
                        padding: headerPadding,
                        child: pw.Text(
                          "Expense (Debit)",
                          style: headerTextstyle,
                        ),
                      ),
                    ),
                  ],
                ),
                for (int i = 0; i < 3; i++)
                  pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: i.isOdd ? PdfColors.grey200 : null,
                    ),
                    children: [
                      pw.Center(
                        child: pw.Padding(
                          padding: contentPadding,
                          child: pw.Text(
                            "30-01-2023",
                            style: contentTextstyle,
                          ),
                        ),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.centerRight,
                        child: pw.Padding(
                          padding: contentPadding,
                          child: pw.Text(
                            "",
                            style: contentTextstyle,
                          ),
                        ),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.centerRight,
                        child: pw.Padding(
                          padding: contentPadding,
                          child: pw.Text(
                            "",
                            style: contentTextstyle,
                          ),
                        ),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.centerRight,
                        child: pw.Padding(
                          padding: contentPadding,
                          child: pw.Text(
                            "25000",
                            style: contentTextstyle,
                          ),
                        ),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.centerRight,
                        child: pw.Padding(
                          padding: contentPadding,
                          child: pw.Text(
                            "",
                            style: contentTextstyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                pw.TableRow(
                  decoration: const pw.BoxDecoration(
                    color: PdfColor.fromInt(0xffe6e6ff),
                  ),
                  children: [
                    pw.Center(
                      child: pw.Padding(
                        padding: contentPadding,
                        child: pw.Text(
                          "",
                          style: contentTextstyle,
                        ),
                      ),
                    ),
                    pw.Container(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Padding(
                        padding: contentPadding,
                        child: pw.Text(
                          "",
                          style: contentTextstyle,
                        ),
                      ),
                    ),
                    pw.Container(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Padding(
                        padding: contentPadding,
                        child: pw.Text(
                          "",
                          style: contentTextstyle,
                        ),
                      ),
                    ),
                    pw.Container(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Padding(
                        padding: contentPadding,
                        child: pw.Text(
                          "75000",
                          style: contentTextstyle,
                        ),
                      ),
                    ),
                    pw.Container(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Padding(
                        padding: contentPadding,
                        child: pw.Text(
                          "25000",
                          style: contentTextstyle,
                        ),
                      ),
                    ),
                  ],
                ),
                for (int i = 0; i < 2; i++)
                  pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: i.isOdd ? PdfColors.grey200 : null,
                    ),
                    children: [
                      pw.Center(
                        child: pw.Padding(
                          padding: contentPadding,
                          child: pw.Text(
                            "30-01-2023",
                            style: contentTextstyle,
                          ),
                        ),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.centerRight,
                        child: pw.Padding(
                          padding: contentPadding,
                          child: pw.Text(
                            "",
                            style: contentTextstyle,
                          ),
                        ),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.centerRight,
                        child: pw.Padding(
                          padding: contentPadding,
                          child: pw.Text(
                            "",
                            style: contentTextstyle,
                          ),
                        ),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.centerRight,
                        child: pw.Padding(
                          padding: contentPadding,
                          child: pw.Text(
                            "25000",
                            style: contentTextstyle,
                          ),
                        ),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.centerRight,
                        child: pw.Padding(
                          padding: contentPadding,
                          child: pw.Text(
                            "",
                            style: contentTextstyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                pw.TableRow(
                  decoration: const pw.BoxDecoration(
                    color: PdfColor.fromInt(0xffe6e6ff),
                  ),
                  children: [
                    pw.Center(
                      child: pw.Padding(
                        padding: contentPadding,
                        child: pw.Text(
                          "",
                          style: contentTextstyle,
                        ),
                      ),
                    ),
                    pw.Container(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Padding(
                        padding: contentPadding,
                        child: pw.Text(
                          "",
                          style: contentTextstyle,
                        ),
                      ),
                    ),
                    pw.Container(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Padding(
                        padding: contentPadding,
                        child: pw.Text(
                          "",
                          style: contentTextstyle,
                        ),
                      ),
                    ),
                    pw.Container(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Padding(
                        padding: contentPadding,
                        child: pw.Text(
                          "75000",
                          style: contentTextstyle,
                        ),
                      ),
                    ),
                    pw.Container(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Padding(
                        padding: contentPadding,
                        child: pw.Text(
                          "25000",
                          style: contentTextstyle,
                        ),
                      ),
                    ),
                  ],
                ),
                pw.TableRow(
                  decoration: const pw.BoxDecoration(
                    color: PdfColor.fromInt(0xffe6e6ff),
                  ),
                  children: [
                    pw.Center(
                      child: pw.Padding(
                        padding: contentPadding,
                        child: pw.Text(
                          "",
                          style: contentTextstyle,
                        ),
                      ),
                    ),
                    pw.Container(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Padding(
                        padding: contentPadding,
                        child: pw.Text(
                          "",
                          style: contentTextstyle,
                        ),
                      ),
                    ),
                    pw.Container(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Padding(
                        padding: contentPadding,
                        child: pw.Text(
                          "",
                          style: contentTextstyle,
                        ),
                      ),
                    ),
                    pw.Container(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Padding(
                        padding: contentPadding,
                        child: pw.Text(
                          "150000",
                          style: pw.TextStyle(
                            color: PdfColors.green800,
                            fontSize: contentTextstyle.fontSize,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    pw.Container(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Padding(
                        padding: contentPadding,
                        child: pw.Text(
                          "50000",
                          style: pw.TextStyle(
                            color: PdfColors.red,
                            fontSize: contentTextstyle.fontSize,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                pw.TableRow(
                  decoration: const pw.BoxDecoration(
                    color: PdfColor.fromInt(0xffe6e6ff),
                  ),
                  children: [
                    pw.Center(
                      child: pw.Padding(
                        padding: contentPadding,
                        child: pw.Text(
                          "",
                          style: contentTextstyle,
                        ),
                      ),
                    ),
                    pw.Container(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Padding(
                        padding: contentPadding,
                        child: pw.Text(
                          "",
                          style: contentTextstyle,
                        ),
                      ),
                    ),
                    pw.Container(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Padding(
                        padding: contentPadding,
                        child: pw.Text(
                          "",
                          style: contentTextstyle,
                        ),
                      ),
                    ),
                    pw.Container(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Padding(
                        padding: contentPadding,
                        child: pw.Text(
                          "",
                          style: contentTextstyle,
                        ),
                      ),
                    ),
                    pw.Container(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Padding(
                        padding: contentPadding,
                        child: pw.Text(
                          "Balance : 100000",
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            fontSize: contentTextstyle.fontSize,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 15),
            pw.Table(
              border: pw.TableBorder.all(
                width: 1,
                color: PdfColors.black,
              ),
              columnWidths: {
                0: const pw.FlexColumnWidth(1),
                1: const pw.FlexColumnWidth(5),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(
                    color: PdfColor.fromInt(0xff6666ff),
                  ),
                  children: [
                    pw.Center(
                      child: pw.Padding(
                        padding: headerPadding,
                        child: pw.Text(
                          "Date",
                          style: headerTextstyle,
                        ),
                      ),
                    ),
                    pw.Center(
                      child: pw.Padding(
                        padding: headerPadding,
                        child: pw.Text(
                          "Notes",
                          style: headerTextstyle,
                        ),
                      ),
                    ),
                  ],
                ),
                for (int j = 0; j < 2; j++)
                  pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: j.isOdd ? PdfColors.grey200 : null,
                    ),
                    children: [
                      pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Padding(
                          padding: contentPadding,
                          child: pw.Text(
                            "30-01-2023",
                            style: contentTextstyle,
                          ),
                        ),
                      ),
                      pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Padding(
                          padding: contentPadding,
                          child: pw.Text(
                            "Demo Notes",
                            style: contentTextstyle,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ];
        },
      ),
    );
    Directory path = await getTemporaryDirectory();
    final file = File('${path.path}/example.pdf');
    log(file.path);
    return tmpFile = await file.writeAsBytes(await pdf.save());
  }

  monthlyPdfCreation() async {
    final pdf = pw.Document();
    const headerPadding = pw.EdgeInsets.all(3);
    const contentPadding = pw.EdgeInsets.all(3);
    var headerTextstyle = pw.TextStyle(
      color: PdfColors.white,
      fontSize: 10,
      fontWeight: pw.FontWeight.bold,
    );
    var contentTextstyle = const pw.TextStyle(
      color: PdfColors.black,
      fontSize: 10,
    );

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(10),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Center(
              child: pw.Text(
                'My Daybook',
                style: pw.TextStyle(
                  color: const PdfColor.fromInt(0xff6666ff),
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 10),
            // pw.Text('04 February 2023, 09:54 Am'),
            pw.Text(
              DateFormat('dd MMMM yyyy, hh:mm a').format(
                DateTime.now(),
              ),
            ),
            pw.SizedBox(height: 10),
            monthData.isNotEmpty
                ? isCustome != null && isCustome == false
                    ? pw.Center(
                        child: pw.Text(
                          DateFormat('MMMM, yyyy')
                              .format(
                                DateTime.parse(
                                    monthData.first.transcationdate!),
                              )
                              .toString(),
                        ),
                      )
                    : pw.Center(
                        child: pw.Text(
                          "$fromDate - $toDate",
                        ),
                      )
                : pw.SizedBox(),
            pw.SizedBox(height: 5),
            monthData.isNotEmpty
                ? pw.Table(
                    border: pw.TableBorder.all(
                      width: 1,
                      color: PdfColors.black,
                    ),
                    children: [
                      pw.TableRow(
                        decoration: const pw.BoxDecoration(
                          color: PdfColor.fromInt(0xff6666ff),
                        ),
                        children: [
                          pw.Center(
                            child: pw.Padding(
                              padding: headerPadding,
                              child: pw.Text(
                                "Date",
                                style: headerTextstyle,
                              ),
                            ),
                          ),
                          pw.Center(
                            child: pw.Padding(
                              padding: headerPadding,
                              child: pw.Text(
                                "Description",
                                style: headerTextstyle,
                              ),
                            ),
                          ),
                          pw.Center(
                            child: pw.Padding(
                              padding: headerPadding,
                              child: pw.Text(
                                "Category",
                                style: headerTextstyle,
                              ),
                            ),
                          ),
                          pw.Center(
                            child: pw.Padding(
                              padding: headerPadding,
                              child: pw.Text(
                                "Income (Credit)",
                                style: headerTextstyle,
                              ),
                            ),
                          ),
                          pw.Center(
                            child: pw.Padding(
                              padding: headerPadding,
                              child: pw.Text(
                                "Expense (Debit)",
                                style: headerTextstyle,
                              ),
                            ),
                          ),
                        ],
                      ),
                      for (int i = 0; i < monthData.length; i++)
                        pw.TableRow(
                          decoration: pw.BoxDecoration(
                            color: i.isOdd ? PdfColors.grey200 : null,
                          ),
                          children: [
                            pw.Center(
                              child: pw.Padding(
                                padding: contentPadding,
                                child: pw.Text(
                                  dateformatechange(
                                          monthData[i].transcationdate!)
                                      .toString(),
                                  style: contentTextstyle,
                                ),
                              ),
                            ),
                            pw.Container(
                              alignment: pw.Alignment.centerRight,
                              child: pw.Padding(
                                padding: contentPadding,
                                child: pw.Text(
                                  monthData[i].name!,
                                  style: contentTextstyle,
                                ),
                              ),
                            ),
                            pw.Container(
                              alignment: pw.Alignment.centerRight,
                              child: pw.Padding(
                                padding: contentPadding,
                                child: pw.Text(
                                  "",
                                  style: contentTextstyle,
                                ),
                              ),
                            ),
                            pw.Container(
                              alignment: pw.Alignment.centerRight,
                              child: pw.Padding(
                                padding: contentPadding,
                                child: pw.Text(
                                  monthData[i].isIncome == 1
                                      ? monthData[i].amount.toString()
                                      : "",
                                  style: contentTextstyle,
                                ),
                              ),
                            ),
                            pw.Container(
                              alignment: pw.Alignment.centerRight,
                              child: pw.Padding(
                                padding: contentPadding,
                                child: pw.Text(
                                  monthData[i].isIncome == 2
                                      ? monthData[i].amount.toString()
                                      : "",
                                  style: contentTextstyle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      pw.TableRow(
                        decoration: const pw.BoxDecoration(
                          color: PdfColor.fromInt(0xffe6e6ff),
                        ),
                        children: [
                          pw.Center(
                            child: pw.Padding(
                              padding: contentPadding,
                              child: pw.Text(
                                "",
                                style: contentTextstyle,
                              ),
                            ),
                          ),
                          pw.Container(
                            alignment: pw.Alignment.centerRight,
                            child: pw.Padding(
                              padding: contentPadding,
                              child: pw.Text(
                                "",
                                style: contentTextstyle,
                              ),
                            ),
                          ),
                          pw.Container(
                            alignment: pw.Alignment.centerRight,
                            child: pw.Padding(
                              padding: contentPadding,
                              child: pw.Text(
                                "",
                                style: contentTextstyle,
                              ),
                            ),
                          ),
                          pw.Container(
                            alignment: pw.Alignment.centerRight,
                            child: pw.Padding(
                              padding: contentPadding,
                              child: pw.Text(
                                totalincome().toString(),
                                style: contentTextstyle,
                              ),
                            ),
                          ),
                          pw.Container(
                            alignment: pw.Alignment.centerRight,
                            child: pw.Padding(
                              padding: contentPadding,
                              child: pw.Text(
                                totalexpance().toString(),
                                style: contentTextstyle,
                              ),
                            ),
                          ),
                        ],
                      ),
                      pw.TableRow(
                        decoration: const pw.BoxDecoration(
                          color: PdfColor.fromInt(0xffe6e6ff),
                        ),
                        children: [
                          pw.Center(
                            child: pw.Padding(
                              padding: contentPadding,
                              child: pw.Text(
                                "",
                                style: contentTextstyle,
                              ),
                            ),
                          ),
                          pw.Container(
                            alignment: pw.Alignment.centerRight,
                            child: pw.Padding(
                              padding: contentPadding,
                              child: pw.Text(
                                "",
                                style: contentTextstyle,
                              ),
                            ),
                          ),
                          pw.Container(
                            alignment: pw.Alignment.centerRight,
                            child: pw.Padding(
                              padding: contentPadding,
                              child: pw.Text(
                                "",
                                style: contentTextstyle,
                              ),
                            ),
                          ),
                          pw.Container(
                            alignment: pw.Alignment.centerRight,
                            child: pw.Padding(
                              padding: contentPadding,
                              child: pw.Text(
                                totalincome().toString(),
                                style: pw.TextStyle(
                                  color: PdfColors.green800,
                                  fontSize: contentTextstyle.fontSize,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          pw.Container(
                            alignment: pw.Alignment.centerRight,
                            child: pw.Padding(
                              padding: contentPadding,
                              child: pw.Text(
                                totalexpance().toString(),
                                style: pw.TextStyle(
                                  color: PdfColors.red,
                                  fontSize: contentTextstyle.fontSize,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      pw.TableRow(
                        decoration: const pw.BoxDecoration(
                          color: PdfColor.fromInt(0xffe6e6ff),
                        ),
                        children: [
                          pw.Center(
                            child: pw.Padding(
                              padding: contentPadding,
                              child: pw.Text(
                                "",
                                style: contentTextstyle,
                              ),
                            ),
                          ),
                          pw.Container(
                            alignment: pw.Alignment.centerRight,
                            child: pw.Padding(
                              padding: contentPadding,
                              child: pw.Text(
                                "",
                                style: contentTextstyle,
                              ),
                            ),
                          ),
                          pw.Container(
                            alignment: pw.Alignment.centerRight,
                            child: pw.Padding(
                              padding: contentPadding,
                              child: pw.Text(
                                "",
                                style: contentTextstyle,
                              ),
                            ),
                          ),
                          pw.Container(
                            alignment: pw.Alignment.centerRight,
                            child: pw.Padding(
                              padding: contentPadding,
                              child: pw.Text(
                                "",
                                style: contentTextstyle,
                              ),
                            ),
                          ),
                          pw.Container(
                            alignment: pw.Alignment.centerRight,
                            child: pw.Padding(
                              padding: contentPadding,
                              child: pw.Text(
                                "Balance : ${totalbalance().toString()}",
                                style: pw.TextStyle(
                                  color: PdfColors.black,
                                  fontSize: contentTextstyle.fontSize,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : pw.SizedBox(),
            pw.SizedBox(height: 15),
            noteDataList.isNotEmpty
                ? pw.Table(
                    border: pw.TableBorder.all(
                      width: 1,
                      color: PdfColors.black,
                    ),
                    columnWidths: {
                      0: const pw.FlexColumnWidth(1),
                      1: const pw.FlexColumnWidth(5),
                    },
                    children: [
                      pw.TableRow(
                        decoration: const pw.BoxDecoration(
                          color: PdfColor.fromInt(0xff6666ff),
                        ),
                        children: [
                          pw.Center(
                            child: pw.Padding(
                              padding: headerPadding,
                              child: pw.Text(
                                "Date",
                                style: headerTextstyle,
                              ),
                            ),
                          ),
                          pw.Center(
                            child: pw.Padding(
                              padding: headerPadding,
                              child: pw.Text(
                                "Notes",
                                style: headerTextstyle,
                              ),
                            ),
                          ),
                        ],
                      ),
                      for (int j = 0; j < noteDataList.length; j++)
                        pw.TableRow(
                          decoration: pw.BoxDecoration(
                            color: j.isOdd ? PdfColors.grey200 : null,
                          ),
                          children: [
                            pw.Container(
                              alignment: pw.Alignment.centerLeft,
                              child: pw.Padding(
                                padding: contentPadding,
                                child: pw.Text(
                                  dateformatechange(
                                          noteDataList[j].transcationdate!)
                                      .toString(),
                                  style: contentTextstyle,
                                ),
                              ),
                            ),
                            pw.Container(
                              alignment: pw.Alignment.centerLeft,
                              child: pw.Padding(
                                padding: contentPadding,
                                child: pw.Text(
                                  noteDataList[j].notetodo!,
                                  style: contentTextstyle,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  )
                : pw.SizedBox(),
          ];
        },
      ),
    );
    Directory path = await getTemporaryDirectory();
    final file = File('${path.path}/example.pdf');
    log(file.path);
    return tmpFile = await file.writeAsBytes(await pdf.save());
  }

  yearlyPdf() async {
    final pdf = pw.Document();
    const headerPadding = pw.EdgeInsets.all(3);
    const contentPadding = pw.EdgeInsets.all(3);
    var headerTextstyle = pw.TextStyle(
      color: PdfColors.white,
      fontSize: 10,
      fontWeight: pw.FontWeight.bold,
    );
    var contentTextstyle = const pw.TextStyle(
      color: PdfColors.black,
      fontSize: 10,
    );

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.all(10),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Center(
              child: pw.Text(
                'My Daybook',
                style: pw.TextStyle(
                  color: const PdfColor.fromInt(0xff6666ff),
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 10),
            // pw.Text('04 February 2023, 09:54 Am'),
            pw.Text(
              DateFormat('dd MMMM yyyy, hh:mm a').format(
                DateTime.now(),
              ),
            ),
            pw.SizedBox(height: 10),
            for (var element in yearData)
              pw.Column(
                children: [
                  for (var monthElement in element)
                    pw.Column(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(top: 10),
                          child: pw.Center(
                            child: pw.Text(
                              DateFormat('MMMM, yyyy')
                                  .format(
                                    DateTime.parse(
                                        monthElement[0].transcationdate!),
                                  )
                                  .toString(),
                            ),
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Table(
                          border: pw.TableBorder.all(
                            width: 1,
                            color: PdfColors.black,
                          ),
                          children: [
                            pw.TableRow(
                              decoration: const pw.BoxDecoration(
                                color: PdfColor.fromInt(0xff6666ff),
                              ),
                              children: [
                                pw.Center(
                                  child: pw.Padding(
                                    padding: headerPadding,
                                    child: pw.Text(
                                      "Date",
                                      style: headerTextstyle,
                                    ),
                                  ),
                                ),
                                pw.Center(
                                  child: pw.Padding(
                                    padding: headerPadding,
                                    child: pw.Text(
                                      "Description",
                                      style: headerTextstyle,
                                    ),
                                  ),
                                ),
                                pw.Center(
                                  child: pw.Padding(
                                    padding: headerPadding,
                                    child: pw.Text(
                                      "Category",
                                      style: headerTextstyle,
                                    ),
                                  ),
                                ),
                                pw.Center(
                                  child: pw.Padding(
                                    padding: headerPadding,
                                    child: pw.Text(
                                      "Income (Credit)",
                                      style: headerTextstyle,
                                    ),
                                  ),
                                ),
                                pw.Center(
                                  child: pw.Padding(
                                    padding: headerPadding,
                                    child: pw.Text(
                                      "Expense (Debit)",
                                      style: headerTextstyle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            for (int i = 0; i < monthElement.length; i++)
                              pw.TableRow(
                                decoration: pw.BoxDecoration(
                                  color: i.isOdd ? PdfColors.grey200 : null,
                                ),
                                children: [
                                  pw.Center(
                                    child: pw.Padding(
                                      padding: contentPadding,
                                      child: pw.Text(
                                        dateformatechange(
                                          monthElement[i].transcationdate!,
                                        ).toString(),
                                        style: contentTextstyle,
                                      ),
                                    ),
                                  ),
                                  pw.Container(
                                    alignment: pw.Alignment.centerRight,
                                    child: pw.Padding(
                                      padding: contentPadding,
                                      child: pw.Text(
                                        monthElement[i].name!,
                                        style: contentTextstyle,
                                      ),
                                    ),
                                  ),
                                  pw.Container(
                                    alignment: pw.Alignment.centerRight,
                                    child: pw.Padding(
                                      padding: contentPadding,
                                      child: pw.Text(
                                        "",
                                        style: contentTextstyle,
                                      ),
                                    ),
                                  ),
                                  pw.Container(
                                    alignment: pw.Alignment.centerRight,
                                    child: pw.Padding(
                                      padding: contentPadding,
                                      child: pw.Text(
                                        monthElement[i].isIncome == 1
                                            ? monthElement[i].amount.toString()
                                            : "",
                                        style: contentTextstyle,
                                      ),
                                    ),
                                  ),
                                  pw.Container(
                                    alignment: pw.Alignment.centerRight,
                                    child: pw.Padding(
                                      padding: contentPadding,
                                      child: pw.Text(
                                        monthElement[i].isIncome == 2
                                            ? monthElement[i].amount.toString()
                                            : "",
                                        style: contentTextstyle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            pw.TableRow(
                              decoration: const pw.BoxDecoration(
                                color: PdfColor.fromInt(0xffe6e6ff),
                              ),
                              children: [
                                pw.Center(
                                  child: pw.Padding(
                                    padding: contentPadding,
                                    child: pw.Text(
                                      "",
                                      style: contentTextstyle,
                                    ),
                                  ),
                                ),
                                pw.Container(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Padding(
                                    padding: contentPadding,
                                    child: pw.Text(
                                      "",
                                      style: contentTextstyle,
                                    ),
                                  ),
                                ),
                                pw.Container(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Padding(
                                    padding: contentPadding,
                                    child: pw.Text(
                                      "",
                                      style: contentTextstyle,
                                    ),
                                  ),
                                ),
                                pw.Container(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Padding(
                                    padding: contentPadding,
                                    child: pw.Text(
                                      monthElement.fold(0.0,
                                          (previousValue, element) {
                                        if (element.isIncome == 1) {
                                          return previousValue.toDouble() +
                                              element.amount!.toDouble();
                                        } else {
                                          return previousValue + 0;
                                        }
                                      }).toStringAsFixed(1),
                                      style: contentTextstyle,
                                    ),
                                  ),
                                ),
                                pw.Container(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Padding(
                                    padding: contentPadding,
                                    child: pw.Text(
                                      monthElement.fold(0.0,
                                          (previousValue, element) {
                                        if (element.isIncome == 2) {
                                          return previousValue.toDouble() +
                                              element.amount!.toDouble();
                                        } else {
                                          return previousValue + 0;
                                        }
                                      }).toStringAsFixed(1),
                                      style: contentTextstyle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            pw.TableRow(
                              decoration: const pw.BoxDecoration(
                                color: PdfColor.fromInt(0xffe6e6ff),
                              ),
                              children: [
                                pw.Center(
                                  child: pw.Padding(
                                    padding: contentPadding,
                                    child: pw.Text(
                                      "",
                                      style: contentTextstyle,
                                    ),
                                  ),
                                ),
                                pw.Container(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Padding(
                                    padding: contentPadding,
                                    child: pw.Text(
                                      "",
                                      style: contentTextstyle,
                                    ),
                                  ),
                                ),
                                pw.Container(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Padding(
                                    padding: contentPadding,
                                    child: pw.Text(
                                      "",
                                      style: contentTextstyle,
                                    ),
                                  ),
                                ),
                                pw.Container(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Padding(
                                    padding: contentPadding,
                                    child: pw.Text(
                                      monthElement.fold(0.0,
                                          (previousValue, element) {
                                        if (element.isIncome == 1) {
                                          return previousValue.toDouble() +
                                              element.amount!.toDouble();
                                        } else {
                                          return previousValue + 0;
                                        }
                                      }).toStringAsFixed(1),
                                      style: pw.TextStyle(
                                        color: PdfColors.green800,
                                        fontSize: contentTextstyle.fontSize,
                                        fontWeight: pw.FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                pw.Container(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Padding(
                                    padding: contentPadding,
                                    child: pw.Text(
                                      monthElement.fold(0.0,
                                          (previousValue, element) {
                                        if (element.isIncome == 2) {
                                          return previousValue.toDouble() +
                                              element.amount!.toDouble();
                                        } else {
                                          return previousValue + 0;
                                        }
                                      }).toStringAsFixed(1),
                                      style: pw.TextStyle(
                                        color: PdfColors.red,
                                        fontSize: contentTextstyle.fontSize,
                                        fontWeight: pw.FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            pw.TableRow(
                              decoration: const pw.BoxDecoration(
                                color: PdfColor.fromInt(0xffe6e6ff),
                              ),
                              children: [
                                pw.Center(
                                  child: pw.Padding(
                                    padding: contentPadding,
                                    child: pw.Text(
                                      "",
                                      style: contentTextstyle,
                                    ),
                                  ),
                                ),
                                pw.Container(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Padding(
                                    padding: contentPadding,
                                    child: pw.Text(
                                      "",
                                      style: contentTextstyle,
                                    ),
                                  ),
                                ),
                                pw.Container(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Padding(
                                    padding: contentPadding,
                                    child: pw.Text(
                                      "",
                                      style: contentTextstyle,
                                    ),
                                  ),
                                ),
                                pw.Container(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Padding(
                                    padding: contentPadding,
                                    child: pw.Text(
                                      "",
                                      style: contentTextstyle,
                                    ),
                                  ),
                                ),
                                pw.Container(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Padding(
                                    padding: contentPadding,
                                    child: pw.Text(
                                      "Balance : ${monthElement.fold(0.0, (previousValue, element) {
                                            if (element.isIncome == 1) {
                                              return previousValue.toDouble() +
                                                  element.amount!.toDouble();
                                            } else {
                                              return previousValue + 0;
                                            }
                                          }) - monthElement.fold(0.0, (previousValue, element) {
                                            if (element.isIncome == 2) {
                                              return previousValue.toDouble() +
                                                  element.amount!.toDouble();
                                            } else {
                                              return previousValue + 0;
                                            }
                                          })}",
                                      style: pw.TextStyle(
                                        color: PdfColors.black,
                                        fontSize: contentTextstyle.fontSize,
                                        fontWeight: pw.FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  pw.SizedBox(height: 5),
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(top: 5),
                    child: pw.Center(
                      child: pw.Text(
                        "Yearly Report ${DateFormat('yyyy').format(
                              DateTime.parse(element[0][0].transcationdate!),
                            ).toString()}",
                        style: const pw.TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  pw.Table(
                    border: pw.TableBorder.all(
                      width: 1,
                      color: PdfColors.black,
                    ),
                    children: [
                      pw.TableRow(
                        decoration: const pw.BoxDecoration(
                          color: PdfColor.fromInt(0xff6666ff),
                        ),
                        children: [
                          pw.Center(
                            child: pw.Padding(
                              padding: headerPadding,
                              child: pw.Text(
                                "Month",
                                style: headerTextstyle,
                              ),
                            ),
                          ),
                          pw.Center(
                            child: pw.Padding(
                              padding: headerPadding,
                              child: pw.Text(
                                "Income (Credit)",
                                style: headerTextstyle,
                              ),
                            ),
                          ),
                          pw.Center(
                            child: pw.Padding(
                              padding: headerPadding,
                              child: pw.Text(
                                "Expense (Debit)",
                                style: headerTextstyle,
                              ),
                            ),
                          ),
                          pw.Center(
                            child: pw.Padding(
                              padding: headerPadding,
                              child: pw.Text(
                                "Saveing",
                                style: headerTextstyle,
                              ),
                            ),
                          ),
                        ],
                      ),
                      for (int i = 0; i < element.length; i++)
                        pw.TableRow(
                          decoration: pw.BoxDecoration(
                            color: i.isOdd ? PdfColors.grey200 : null,
                          ),
                          children: [
                            pw.Center(
                              child: pw.Padding(
                                padding: contentPadding,
                                child: pw.Text(
                                  DateFormat('MMMM')
                                      .format(
                                        DateTime.parse(
                                          element[i].first.transcationdate!,
                                        ),
                                      )
                                      .toString(),
                                  style: contentTextstyle,
                                ),
                              ),
                            ),
                            pw.Container(
                              alignment: pw.Alignment.centerRight,
                              child: pw.Padding(
                                padding: contentPadding,
                                child: pw.Text(
                                  // monthElement[i].name!,
                                  element[i].fold(0.0,
                                      (previousValue, newelement) {
                                    if (newelement.isIncome == 1) {
                                      return previousValue.toDouble() +
                                          newelement.amount!.toDouble();
                                    } else {
                                      return previousValue + 0;
                                    }
                                  }).toStringAsFixed(1),
                                  style: contentTextstyle,
                                ),
                              ),
                            ),
                            pw.Container(
                              alignment: pw.Alignment.centerRight,
                              child: pw.Padding(
                                padding: contentPadding,
                                child: pw.Text(
                                  element[i].fold(0.0,
                                      (previousValue, newelement) {
                                    if (newelement.isIncome == 2) {
                                      return previousValue.toDouble() +
                                          newelement.amount!.toDouble();
                                    } else {
                                      return previousValue + 0;
                                    }
                                  }).toStringAsFixed(1),
                                  style: contentTextstyle,
                                ),
                              ),
                            ),
                            pw.Container(
                              alignment: pw.Alignment.centerRight,
                              child: pw.Padding(
                                padding: contentPadding,
                                child: pw.Text(
                                  // monthElement[i].isIncome == 1
                                  //     ? monthElement[i].amount.toString()
                                  //     : "",
                                  (element[i].fold(0,
                                              (previousValue, newelement) {
                                            if (newelement.isIncome == 1) {
                                              return previousValue +
                                                  newelement.amount!.toInt();
                                            } else {
                                              return previousValue + 0;
                                            }
                                          }) -
                                          element[i].fold(0,
                                              (previousValue, newelement) {
                                            if (newelement.isIncome == 2) {
                                              return previousValue +
                                                  newelement.amount!.toInt();
                                            } else {
                                              return previousValue + 0;
                                            }
                                          }))
                                      .toString(),
                                  style: contentTextstyle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      pw.TableRow(
                        decoration: const pw.BoxDecoration(
                          color: PdfColor.fromInt(0xffe6e6ff),
                        ),
                        children: [
                          pw.Container(
                            alignment: pw.Alignment.centerRight,
                            child: pw.Padding(
                              padding: contentPadding,
                              child: pw.Text(
                                "",
                                style: contentTextstyle,
                              ),
                            ),
                          ),
                          pw.Container(
                            alignment: pw.Alignment.centerRight,
                            child: pw.Padding(
                              padding: contentPadding,
                              child: pw.Text(
                                element.fold(0.0, (previousValue, findelement) {
                                  return previousValue +
                                      findelement.fold(0,
                                          (previousValue, newelement) {
                                        if (newelement.isIncome == 1) {
                                          return previousValue +
                                              newelement.amount!.toInt();
                                        } else {
                                          return previousValue + 0;
                                        }
                                      });
                                }).toStringAsFixed(1),
                                style: pw.TextStyle(
                                  color: PdfColors.green600,
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                          pw.Container(
                            alignment: pw.Alignment.centerRight,
                            child: pw.Padding(
                              padding: contentPadding,
                              child: pw.Text(
                                  element.fold(0.0,
                                      (previousValue, findelement) {
                                    return previousValue +
                                        findelement.fold(0,
                                            (previousValue, newelement) {
                                          if (newelement.isIncome == 2) {
                                            return previousValue +
                                                newelement.amount!.toInt();
                                          } else {
                                            return previousValue + 0;
                                          }
                                        });
                                  }).toStringAsFixed(1),
                                  style: pw.TextStyle(
                                    color: PdfColors.red,
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 10,
                                  )),
                            ),
                          ),
                          pw.Container(
                            alignment: pw.Alignment.centerRight,
                            child: pw.Padding(
                              padding: contentPadding,
                              child: pw.Text(
                                (element.fold(0.0,
                                            (previousValue, findelement) {
                                          return previousValue +
                                              findelement.fold(0,
                                                  (previousValue, newelement) {
                                                if (newelement.isIncome == 1) {
                                                  return previousValue +
                                                      newelement.amount!
                                                          .toInt();
                                                } else {
                                                  return previousValue + 0;
                                                }
                                              });
                                        }) -
                                        element.fold(0.0,
                                            (previousValue, findelement) {
                                          return previousValue +
                                              findelement.fold(0,
                                                  (previousValue, newelement) {
                                                if (newelement.isIncome == 2) {
                                                  return previousValue +
                                                      newelement.amount!
                                                          .toInt();
                                                } else {
                                                  return previousValue + 0;
                                                }
                                              });
                                        }))
                                    .toString(),
                                style: pw.TextStyle(
                                  color: PdfColors.blueGrey800,
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            pw.SizedBox(height: 10),
            noteDataList.isNotEmpty
                ? pw.Table(
                    border: pw.TableBorder.all(
                      width: 1,
                      color: PdfColors.black,
                    ),
                    columnWidths: {
                      0: const pw.FlexColumnWidth(1),
                      1: const pw.FlexColumnWidth(5),
                    },
                    children: [
                      pw.TableRow(
                        decoration: const pw.BoxDecoration(
                          color: PdfColor.fromInt(0xff6666ff),
                        ),
                        children: [
                          pw.Center(
                            child: pw.Padding(
                              padding: headerPadding,
                              child: pw.Text(
                                "Date",
                                style: headerTextstyle,
                              ),
                            ),
                          ),
                          pw.Center(
                            child: pw.Padding(
                              padding: headerPadding,
                              child: pw.Text(
                                "Notes",
                                style: headerTextstyle,
                              ),
                            ),
                          ),
                        ],
                      ),
                      for (int j = 0; j < noteDataList.length; j++)
                        pw.TableRow(
                          decoration: pw.BoxDecoration(
                            color: j.isOdd ? PdfColors.grey200 : null,
                          ),
                          children: [
                            pw.Container(
                              alignment: pw.Alignment.centerLeft,
                              child: pw.Padding(
                                padding: contentPadding,
                                child: pw.Text(
                                  dateformatechange(
                                          noteDataList[j].transcationdate!)
                                      .toString(),
                                  style: contentTextstyle,
                                ),
                              ),
                            ),
                            pw.Container(
                              alignment: pw.Alignment.centerLeft,
                              child: pw.Padding(
                                padding: contentPadding,
                                child: pw.Text(
                                  noteDataList[j].notetodo!,
                                  style: contentTextstyle,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  )
                : pw.SizedBox(),
          ];
        },
      ),
    );
    Directory path = await getTemporaryDirectory();
    final file = File('${path.path}/example.pdf');
    log(file.path);
    return tmpFile = await file.writeAsBytes(await pdf.save());
  }
}
