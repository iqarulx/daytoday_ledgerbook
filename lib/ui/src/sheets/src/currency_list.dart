import 'package:flutter/material.dart';

import '/functions/functions.dart';
import '/model/model.dart';
import '/services/services.dart';
import '/ui/ui.dart';

class CurrencyList extends StatefulWidget {
  const CurrencyList({super.key});

  @override
  State<CurrencyList> createState() => _CurrencyListState();
}

class _CurrencyListState extends State<CurrencyList> {
  TextEditingController searchForm = TextEditingController();
  List<CurrencyModel> mandapam = [];
  List<CurrencyModel> allMandapam = [];
  Future? mandapamHandler;

  void resetSearch() {
    setState(() {
      mandapam = List.from(allMandapam);
    });
  }

  searchSite() {
    List<CurrencyModel> filteredList = allMandapam.where((site) {
      return site.code.toLowerCase().contains(searchForm.text.toLowerCase()) ||
          site.region.toLowerCase().contains(searchForm.text.toLowerCase());
    }).toList();
    setState(() {
      mandapam = filteredList;
    });
  }

  @override
  void initState() {
    mandapamHandler = getCountry();
    super.initState();
  }

  getCountry() async {
    try {
      var d = await ScreensFunctions.getCurrency();
      for (var i in d) {
        mandapam.add(CurrencyModel(
          symbol: i["symbol"],
          code: i["code"],
          region: i["region"],
        ));
      }
      allMandapam = mandapam;
      setState(() {});
    } catch (e) {
      Snackbar.showSnackBar(context, content: e.toString(), isSuccess: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: FutureBuilder(
        future: mandapamHandler,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return futureWaitingLoading(context);
          } else if (snapshot.hasError) {
            return ErrorWidget(snapshot.error!);
          } else {
            return Padding(
              padding: const EdgeInsets.only(left: 15, bottom: 15, right: 15),
              child: Column(
                children: [
                  FormFields(
                    controller: searchForm,
                    hintText: "Search currency",
                    onChanged: (value) {
                      searchSite();
                    },
                    suffixIcon: searchForm.text.isNotEmpty
                        ? TextButton(
                            onPressed: () {
                              searchForm.clear();
                              resetSearch();
                            },
                            child: Text(
                              "Clear",
                              style: TextStyle(
                                color: AppColors.greyColor,
                              ),
                            ),
                          )
                        : null,
                  ),
                  Flexible(
                    child: ListView.separated(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: mandapam.length,
                      separatorBuilder: (context, index) {
                        return Divider(
                          color: Colors.grey.shade300,
                        );
                      },
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            Navigator.pop(context, mandapam[index].symbol);
                          },
                          title: Text(
                            mandapam[index].code,
                            style: const TextStyle(color: Colors.black),
                          ),
                          subtitle: Text(
                            mandapam[index].region,
                            style: const TextStyle(color: Colors.black),
                          ),
                          leading: Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                mandapam[index].symbol,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
