// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';

// Project imports:
import '/constants/constants.dart';
import '/functions/functions.dart';
import '/model/model.dart';
import '/services/services.dart';
import '/ui/ui.dart';
import '/utils/utils.dart';
import '/view/view.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  TabController? _tableTabController;
  late Future _dailyHandler;
  late Future _weeklyHandler;
  late Future _monthlyHandler;
  late Future _yearlyHandler;
  List<DailyModel> _dailyList = [];
  List<WeeklyModel> _weeklyList = [];
  List<MonthlyModel> _monthlyList = [];
  List<YearlyModel> _yearlyList = [];
  String _currency = "";
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _tableTabController = TabController(length: 4, vsync: this);

    _dailyHandler = _getDaily();
    _weeklyHandler = _getWeekly();
    _monthlyHandler = _getMonthly();
    _yearlyHandler = _getYearly();
    _getCurrency();
    super.initState();
  }

  _getCurrency() async {
    _currency = await Db.getData(type: UserData.currency) ?? '';
    setState(() {});
  }

  _getDaily() async {
    try {
      _dailyList.clear();
      _dailyList = await HomeFunctions.getDaily();
    } catch (e) {
      Snackbar.showSnackBar(context, content: e.toString(), isSuccess: false);
    }
  }

  _getWeekly() async {
    try {
      _weeklyList.clear();
      _weeklyList = await HomeFunctions.getWeekly();
    } catch (e) {
      Snackbar.showSnackBar(context, content: e.toString(), isSuccess: false);
    }
  }

  _getMonthly() async {
    try {
      _monthlyList.clear();
      _monthlyList = await HomeFunctions.getMonthly();
    } catch (e) {
      Snackbar.showSnackBar(context, content: e.toString(), isSuccess: false);
    }
  }

  _getYearly() async {
    try {
      _yearlyList.clear();
      _yearlyList = await HomeFunctions.getYearly();
    } catch (e) {
      Snackbar.showSnackBar(context, content: e.toString(), isSuccess: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            await _export(context);
          },
          icon: SvgPicture.asset(SvgAssets.download),
          tooltip: "Menu",
        ),
        title: const Text("My Daybook"),
        actions: [
          IconButton(
            onPressed: () {
              if (scaffoldKey.currentState != null) {
                scaffoldKey.currentState?.openEndDrawer();
              } else {
                debugPrint('ScaffoldKey currentState is null');
              }
            },
            icon: const Icon(Icons.menu_rounded),
            tooltip: "Menu",
          ),
        ],
        bottom: TabBar(
          controller: _tableTabController,
          labelColor: AppColors.pureWhiteColor,
          indicatorColor: AppColors.pureWhiteColor,
          unselectedLabelColor: Colors.white54,
          tabs: const [
            Tab(text: "Daily"),
            Tab(text: "Weekly"),
            Tab(text: "Monthly"),
            Tab(text: "Yearly"),
          ],
        ),
      ),
      endDrawer: const Sidebar(),
      floatingActionButton: _floatingButton(),
      body: TabBarView(
        controller: _tableTabController,
        children: [
          FutureBuilder(
            future: _dailyHandler,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return futureWaitingLoading(context);
              } else if (snapshot.hasError) {
                return ErrorWidget(snapshot.error!);
              } else {
                return _buildDaily();
              }
            },
          ),
          FutureBuilder(
            future: _weeklyHandler,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return futureWaitingLoading(context);
              } else if (snapshot.hasError) {
                return ErrorWidget(snapshot.error!);
              } else {
                return _buildWeekly();
              }
            },
          ),
          FutureBuilder(
            future: _monthlyHandler,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return futureWaitingLoading(context);
              } else if (snapshot.hasError) {
                return ErrorWidget(snapshot.error!);
              } else {
                return _buildMonthly();
              }
            },
          ),
          FutureBuilder(
            future: _yearlyHandler,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return futureWaitingLoading(context);
              } else if (snapshot.hasError) {
                return ErrorWidget(snapshot.error!);
              } else {
                return _buildYearly();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDaily() {
    if (_dailyList.isNotEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          _dailyHandler = _getDaily();
          setState(() {});
        },
        child:
            // ResponsiveGridList(
            //   physics: const NeverScrollableScrollPhysics(),
            //   shrinkWrap: true,
            //   desiredItemWidth:
            //       MediaQuery.of(context).size.width > 600 ? 200 : 150,
            //   minSpacing: 10,
            //   children: [
            //     for (var i in _dailyList)
            //       Container(
            //         margin: const EdgeInsets.only(bottom: 10),
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(7),
            //           color: AppColors.pureWhiteColor,
            //         ),
            //         padding: const EdgeInsets.all(10),
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: [
            //                 Column(
            //                   children: [
            //                     Text(
            //                       i.date,
            //                       style: Theme.of(context).textTheme.titleLarge,
            //                     ),
            //                     const SizedBox(height: 5),
            //                     const Text("Expenses List"),
            //                   ],
            //                 ),
            //                 Column(
            //                   children: [
            //                     Text(
            //                       "Balance",
            //                       style: Theme.of(context).textTheme.titleLarge,
            //                     ),
            //                     const SizedBox(height: 5),
            //                     Text(
            //                       "$_currency ${i.balance}",
            //                       style: Theme.of(context)
            //                           .textTheme
            //                           .titleMedium!
            //                           .copyWith(
            //                             fontWeight: FontWeight.bold,
            //                             color: AppColors.primaryColor,
            //                           ),
            //                     ),
            //                   ],
            //                 ),
            //               ],
            //             ),
            //             const Divider(),
            //             Table(
            //               children: [
            //                 eTableHead(context, "Account", "Credit", "Debit"),
            //                 ...i.expense.map((j) {
            //                   return eTableBody(
            //                     context,
            //                     j.accountIdentification,
            //                     j.type == 1
            //                         ? "$_currency ${j.entry.toString()}"
            //                         : '',
            //                     j.type == 2
            //                         ? "$_currency ${j.entry.toString()}"
            //                         : '',
            //                     j,
            //                     () {
            //                       _dailyHandler = _getDaily();
            //                       _weeklyHandler = _getWeekly();
            //                       _monthlyHandler = _getMonthly();
            //                       _yearlyHandler = _getYearly();
            //                       setState(() {});
            //                     },
            //                   );
            //                 }),
            //                 eTableFooter(context, "$_currency ${i.totalCredit}",
            //                     "$_currency ${i.totalDebit}")
            //               ],
            //             )
            //           ],
            //         ),
            //       )
            //   ],
            // )
            ListView(
          padding: const EdgeInsets.all(10),
          children: [
            for (var i in _dailyList)
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: AppColors.pureWhiteColor,
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              i.date,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 5),
                            const Text("Expenses List"),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Balance",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "$_currency ${i.balance}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColor,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(),
                    Table(
                      children: [
                        eTableHead(context, "Account", "Credit", "Debit"),
                        ...i.expense.map((j) {
                          return eTableBody(
                            context,
                            j.accountIdentification,
                            j.type == 1
                                ? "$_currency ${j.entry.toString()}"
                                : '',
                            j.type == 2
                                ? "$_currency ${j.entry.toString()}"
                                : '',
                            j,
                            () {
                              _dailyHandler = _getDaily();
                              _weeklyHandler = _getWeekly();
                              _monthlyHandler = _getMonthly();
                              _yearlyHandler = _getYearly();
                              setState(() {});
                            },
                          );
                        }),
                        eTableFooter(context, "$_currency ${i.totalCredit}",
                            "$_currency ${i.totalDebit}")
                      ],
                    )
                  ],
                ),
              )
          ],
        ),
      );
    }
    return noData(context);
  }

  Widget _buildWeekly() {
    if (_weeklyList.isNotEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          _weeklyHandler = _getWeekly();
          setState(() {});
        },
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            for (var i in _weeklyList)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: AppColors.pureWhiteColor,
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              "${i.fromDate} - ${i.toDate}",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 5),
                            const Text("Expenses List"),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Balance",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "$_currency ${i.balance}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColor,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(),
                    Table(
                      children: [
                        eTableHead(context, "Account", "Credit", "Debit"),
                        ...i.expense.map((j) {
                          return eTableBody(
                            context,
                            j.accountIdentification,
                            j.type == 1
                                ? "$_currency ${j.entry.toString()}"
                                : '',
                            j.type == 2
                                ? "$_currency ${j.entry.toString()}"
                                : '',
                            j,
                            () {
                              _dailyHandler = _getDaily();
                              _weeklyHandler = _getWeekly();
                              _monthlyHandler = _getMonthly();
                              _yearlyHandler = _getYearly();
                              setState(() {});
                            },
                          );
                        }),
                        eTableFooter(context, "$_currency ${i.totalCredit}",
                            "$_currency ${i.totalDebit}")
                      ],
                    )
                  ],
                ),
              )
          ],
        ),
      );
    }
    return noData(context);
  }

  Widget _buildMonthly() {
    if (_monthlyList.isNotEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          _monthlyHandler = _getMonthly();
          setState(() {});
        },
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            for (var i in _monthlyList)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: AppColors.pureWhiteColor,
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              "${i.fromDate} - ${i.toDate}",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 5),
                            const Text("Expenses List"),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Balance",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "$_currency ${i.balance}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColor,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(),
                    Table(
                      children: [
                        eTableHead(context, "Account", "Credit", "Debit"),
                        ...i.expense.map((j) {
                          return eTableBody(
                            context,
                            j.accountIdentification,
                            j.type == 1
                                ? "$_currency ${j.entry.toString()}"
                                : '',
                            j.type == 2
                                ? "$_currency ${j.entry.toString()}"
                                : '',
                            j,
                            () {
                              _dailyHandler = _getDaily();
                              _weeklyHandler = _getWeekly();
                              _monthlyHandler = _getMonthly();
                              _yearlyHandler = _getYearly();
                              setState(() {});
                            },
                          );
                        }),
                        eTableFooter(context, "$_currency ${i.totalCredit}",
                            "$_currency ${i.totalDebit}")
                      ],
                    )
                  ],
                ),
              )
          ],
        ),
      );
    }
    return noData(context);
  }

  Widget _buildYearly() {
    if (_yearlyList.isNotEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          _yearlyHandler = _getYearly();
          setState(() {});
        },
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            for (var i in _yearlyList)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: AppColors.pureWhiteColor,
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              "${i.fromDate} - ${i.toDate}",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 5),
                            const Text("Expenses List"),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Balance",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "$_currency ${i.balance}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColor,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(),
                    Table(
                      children: [
                        eTableHead(context, "Account", "Credit", "Debit"),
                        ...i.expense.map((j) {
                          return eTableBody(
                            context,
                            j.accountIdentification,
                            j.type == 1
                                ? "$_currency ${j.entry.toString()}"
                                : '',
                            j.type == 2
                                ? "$_currency ${j.entry.toString()}"
                                : '',
                            j,
                            () {
                              _dailyHandler = _getDaily();
                              _weeklyHandler = _getWeekly();
                              _monthlyHandler = _getMonthly();
                              _yearlyHandler = _getYearly();
                              setState(() {});
                            },
                          );
                        }),
                        eTableFooter(context, "$_currency ${i.totalCredit}",
                            "$_currency ${i.totalDebit}")
                      ],
                    )
                  ],
                ),
              )
          ],
        ),
      );
    }
    return noData(context);
  }

  Widget _floatingButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: null,
          foregroundColor: AppColors.whiteColor,
          backgroundColor: Theme.of(context).primaryColor,
          shape: const CircleBorder(),
          onPressed: () async {
            await Sheet.showSheet(context, size: 0.9, widget: const AddNotes());
            // if (v != null) {
            //   if (v) {
            //     _dailyHandler = _getDaily();
            //     _weeklyHandler = _getWeekly();
            //     _monthlyHandler = _getMonthly();
            //     _yearlyHandler = _getYearly();
            //     setState(() {});
            //   }
            // }
          },
          child: const Icon(Iconsax.note),
        ),
        const SizedBox(height: 10),
        FloatingActionButton(
          heroTag: null,
          foregroundColor: AppColors.whiteColor,
          backgroundColor: Theme.of(context).primaryColor,
          shape: const CircleBorder(),
          onPressed: () async {
            var v = await Sheet.showSheet(context,
                size: 0.9, widget: const Entry());
            if (v != null) {
              if (v) {
                _dailyHandler = _getDaily();
                _weeklyHandler = _getWeekly();
                _monthlyHandler = _getMonthly();
                _yearlyHandler = _getYearly();
                setState(() {});
              }
            }
          },
          child: const Icon(Icons.add_rounded),
        ),
      ],
    );
  }

  Future<void> _export(BuildContext context) async {
    var v =
        await Sheet.showSheet(context, size: 0.2, widget: const ExportOption());
    if (v != null) {
      if (v == 1) {
        if (_tableTabController!.index == 0) {
          if (_dailyList.isNotEmpty) {
            Navigator.push(context, CupertinoPageRoute(builder: (context) {
              return PdfView(type: ExportType.daily, daily: _dailyList);
            }));
          } else {
            Snackbar.showSnackBar(context,
                content: "No data found to print", isSuccess: false);
          }
        } else if (_tableTabController!.index == 1) {
          if (_weeklyList.isNotEmpty) {
            Navigator.push(context, CupertinoPageRoute(builder: (context) {
              return PdfView(type: ExportType.weekly, weekly: _weeklyList);
            }));
          } else {
            Snackbar.showSnackBar(context,
                content: "No data found to print", isSuccess: false);
          }
        } else if (_tableTabController!.index == 2) {
          if (_monthlyList.isNotEmpty) {
            Navigator.push(context, CupertinoPageRoute(builder: (context) {
              return PdfView(type: ExportType.monthly, monthly: _monthlyList);
            }));
          } else {
            Snackbar.showSnackBar(context,
                content: "No data found to print", isSuccess: false);
          }
        } else if (_tableTabController!.index == 3) {
          if (_yearlyList.isNotEmpty) {
            Navigator.push(context, CupertinoPageRoute(builder: (context) {
              return PdfView(type: ExportType.yearly, yearly: _yearlyList);
            }));
          } else {
            Snackbar.showSnackBar(context,
                content: "No data found to print", isSuccess: false);
          }
        }
      } else {
        if (_tableTabController!.index == 0) {
          if (_dailyList.isNotEmpty) {
            var r = XlsExport(type: ExportType.daily, daily: _dailyList);
            var d = await r.dailyExcel();
            await FileUtils.openAsBytes(context, d, "daily_report", "xls");
          } else {
            Snackbar.showSnackBar(context,
                content: "No data found generate excel", isSuccess: false);
          }
        } else if (_tableTabController!.index == 1) {
          if (_weeklyList.isNotEmpty) {
            var r = XlsExport(type: ExportType.weekly, weekly: _weeklyList);
            var d = await r.weeklyExcel();
            await FileUtils.openAsBytes(context, d, "weekly_report", "xls");
          } else {
            Snackbar.showSnackBar(context,
                content: "No data found generate excel", isSuccess: false);
          }
        } else if (_tableTabController!.index == 2) {
          if (_monthlyList.isNotEmpty) {
            var r = XlsExport(type: ExportType.monthly, monthly: _monthlyList);
            var d = await r.monhtlyExcel();
            await FileUtils.openAsBytes(context, d, "monthly_report", "xls");
          } else {
            Snackbar.showSnackBar(context,
                content: "No data found generate excel", isSuccess: false);
          }
        } else if (_tableTabController!.index == 3) {
          if (_yearlyList.isNotEmpty) {
            var r = XlsExport(type: ExportType.yearly, yearly: _yearlyList);
            var d = await r.yearlyExcel();
            await FileUtils.openAsBytes(context, d, "yearly_report", "xls");
          } else {
            Snackbar.showSnackBar(context,
                content: "No data found generate excel", isSuccess: false);
          }
        }
      }
    }
  }
}
