// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '/functions/functions.dart';
import '/model/model.dart';
import '/services/services.dart';
import '/ui/ui.dart';

class AccountList extends StatefulWidget {
  const AccountList({super.key});

  @override
  State<AccountList> createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  TextEditingController searchForm = TextEditingController();
  List<AccountModel> mandapam = [];
  List<AccountModel> allMandapam = [];
  Future? mandapamHandler;

  void resetSearch() {
    setState(() {
      mandapam = List.from(allMandapam);
    });
  }

  searchSite() {
    List<AccountModel> filteredList = allMandapam.where((site) {
      return site.accountIdentification
          .toLowerCase()
          .contains(searchForm.text.toLowerCase());
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
      var d = await ScreensFunctions.getAccounts();
      var data = d["accountList"];
      for (var i in data) {
        mandapam.add(AccountModel(
          accountId: i["accountId"],
          accountColor: i["accountColor"],
          accountIdentification: i["accountIdentification"],
          bankDetails: i["bankDetails"],
          openingBalance: i["openingBalance"],
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
                    hintText: "Search account",
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
                            Navigator.pop(context, {
                              "name": mandapam[index].accountIdentification,
                              "id": mandapam[index].accountId
                            });
                          },
                          title: Text(
                            mandapam[index].accountIdentification,
                            style: const TextStyle(color: Colors.black),
                          ),
                          subtitle: Text(
                            mandapam[index].bankDetails,
                            style: const TextStyle(color: Colors.black),
                          ),
                          trailing: Icon(
                            Icons.circle,
                            color:
                                Color(int.parse(mandapam[index].accountColor)),
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
                                "${index + 1}",
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
