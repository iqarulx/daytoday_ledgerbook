import 'package:daytoday_ledgerbook/functions/screens/home_functions.dart';
import 'package:daytoday_ledgerbook/ui/ui.dart';
import 'package:daytoday_ledgerbook/view/src/entry/entry.dart';
import 'package:flutter/material.dart';
import '../../../services/src/color/app_colors.dart';
import '../../../utils/utils.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  TabController? _tableTabController;
  late Future _homeHandler;

  @override
  void initState() {
    _tableTabController = TabController(length: 3, vsync: this);

    _homeHandler = _init();
    super.initState();
  }

  _init() async {
    await HomeFunctions.getDaily();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Daybook"),
        actions: const [],
        bottom: TabBar(
          controller: _tableTabController,
          labelColor: AppColors.pureWhiteColor,
          indicatorColor: AppColors.pureWhiteColor,
          unselectedLabelColor: Colors.white54,
          tabs: const [
            Tab(text: "Daily"),
            Tab(text: "Weekly"),
            Tab(text: "Yearly"),
          ],
        ),
      ),
      floatingActionButton: _floatingButton(),
      body: FutureBuilder(
        future: _homeHandler,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return futureWaitingLoading(context);
          } else if (snapshot.hasError) {
            return ErrorWidget(snapshot.error!);
          } else {
            return Container();
          }
        },
      ),
    );
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
