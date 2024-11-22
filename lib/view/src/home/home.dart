import 'package:flutter/material.dart';

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
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _tableTabController = TabController(length: 4, vsync: this);

    _dailyHandler = _getDaily();
    _weeklyHandler = _getWeekly();
    _monthlyHandler = _getMonthly();
    _yearlyHandler = _getYearly();
    super.initState();
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
      return ListView(
        padding: const EdgeInsets.all(10),
        children: [
          for (var i in _dailyList)
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
                            i.balance,
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
                      dailyHead(context, "Account", "Credit", "Debit"),
                      ...i.expense.map((j) {
                        return dailyBody(
                            context,
                            j.accountIdentification,
                            j.type == 1 ? j.entry.toString() : '',
                            j.type == 2 ? j.entry.toString() : '');
                      }),
                      dailyFooter(context, i.totalCredit, i.totalDebit)
                    ],
                  )
                ],
              ),
            )
        ],
      );
    }
    return noData(context);
  }

  Widget _buildWeekly() {
    if (_weeklyList.isNotEmpty) {
      return ListView(
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
                            i.balance,
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
                      dailyHead(context, "Account", "Credit", "Debit"),
                      ...i.expense.map((j) {
                        return dailyBody(
                            context,
                            j.accountIdentification,
                            j.type == 1 ? j.entry.toString() : '',
                            j.type == 2 ? j.entry.toString() : '');
                      }),
                      dailyFooter(context, i.totalCredit, i.totalDebit)
                    ],
                  )
                ],
              ),
            )
        ],
      );
    }
    return noData(context);
  }

  Widget _buildMonthly() {
    if (_monthlyList.isNotEmpty) {
      return ListView(
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
                            i.balance,
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
                      dailyHead(context, "Account", "Credit", "Debit"),
                      ...i.expense.map((j) {
                        return dailyBody(
                            context,
                            j.accountIdentification,
                            j.type == 1 ? j.entry.toString() : '',
                            j.type == 2 ? j.entry.toString() : '');
                      }),
                      dailyFooter(context, i.totalCredit, i.totalDebit)
                    ],
                  )
                ],
              ),
            )
        ],
      );
    }
    return noData(context);
  }

  Widget _buildYearly() {
    if (_yearlyList.isNotEmpty) {
      return ListView(
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
                            i.balance,
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
                      dailyHead(context, "Account", "Credit", "Debit"),
                      ...i.expense.map((j) {
                        return dailyBody(
                            context,
                            j.accountIdentification,
                            j.type == 1 ? j.entry.toString() : '',
                            j.type == 2 ? j.entry.toString() : '');
                      }),
                      dailyFooter(context, i.totalCredit, i.totalDebit)
                    ],
                  )
                ],
              ),
            )
        ],
      );
    }
    return noData(context);
  }

  FloatingActionButton? _floatingButton() {
    return FloatingActionButton(
      heroTag: null,
      foregroundColor: AppColors.whiteColor,
      backgroundColor: Theme.of(context).primaryColor,
      shape: const CircleBorder(),
      onPressed: () async {
        await Sheet.showSheet(context, size: 0.9, widget: const Entry());
      },
      child: const Icon(Icons.add_rounded),
    );
  }
}
