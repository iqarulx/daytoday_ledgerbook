import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '/services/services.dart';
import '/model/model.dart';
import '/utils/utils.dart';
import '/constants/constants.dart';
import '/ui/ui.dart';

class PdfView extends StatefulWidget {
  final ExportType type;
  final List<DailyModel>? daily;
  final List<WeeklyModel>? weekly;
  final List<MonthlyModel>? monthly;
  final List<YearlyModel>? yearly;
  const PdfView({
    super.key,
    required this.type,
    this.daily,
    this.weekly,
    this.monthly,
    this.yearly,
  });

  @override
  State<PdfView> createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  Uint8List? pdfData;

  _genPdf() async {
    PdfExport pdf;
    Uint8List dataResult;
    if (widget.type == ExportType.daily) {
      pdf = PdfExport(type: widget.type, daily: widget.daily);
      dataResult = await pdf.dailyPdf();
    } else if (widget.type == ExportType.weekly) {
      pdf = PdfExport(type: widget.type, weekly: widget.weekly);
      dataResult = await pdf.weeklyPdf();
    } else if (widget.type == ExportType.monthly) {
      pdf = PdfExport(type: widget.type, monthly: widget.monthly);
      dataResult = await pdf.monthlyPdf();
    } else {
      pdf = PdfExport(type: widget.type, yearly: widget.yearly);
      dataResult = await pdf.yearlyPdf();
    }
    setState(() {
      pdfData = dataResult;
    });
  }

  _printPdf() async {
    try {
      await Printing.layoutPdf(
        onLayout: (_) => pdfData!,
      );
    } catch (e) {
      Snackbar.showSnackBar(context, isSuccess: false, content: e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _genPdf();
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
        title: const Text("Pdf Preview"),
        actions: [
          IconButton(
            icon: SvgPicture.asset(SvgAssets.download),
            onPressed: () async {
              await FileUtils.openAsBytes(
                  context, pdfData, "${widget.type.name}_report", "pdf");
            },
          ),
          IconButton(
            icon: const Icon(Iconsax.printer),
            onPressed: () {
              _printPdf();
            },
          )
        ],
      ),
      body: pdfData != null
          ? SfPdfViewer.memory(
              pdfData!,
            )
          : const SizedBox(),
    );
  }
}
