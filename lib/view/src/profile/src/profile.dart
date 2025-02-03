// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:iconsax/iconsax.dart';

// Project imports:
import '/constants/constants.dart';
import '/functions/functions.dart';
import '/model/model.dart';
import '/ui/ui.dart';
import '/utils/utils.dart';
import '/view/view.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future _profileHanlder;
  String _profileName = "";
  String _purpose = "";
  String _additionalInfo = "";
  String _currency = "";
  String _dateFormat = "";
  String _profileImg = emptyProfilePhoto;
  final List<AccountModel> _accList = [];
  Map<String, dynamic> data = {};

  @override
  void initState() {
    _profileHanlder = _getProfile();

    super.initState();
  }

  _getProfile() async {
    _accList.clear();
    var d = await ScreensFunctions.getAccounts();
    data = d;
    if (d.isNotEmpty) {
      _profileName = d["profileName"];
      _purpose = d["purpose"];
      _additionalInfo = d["additionalInfo"];
      _profileImg = d["profileImage"];
      _currency = d["currency"];
      _dateFormat = d["dateFormat"];

      for (var i in d["accountList"]) {
        _accList.add(AccountModel(
          accountColor: i["accountColor"],
          accountId: i["accountId"],
          accountIdentification: i["accountIdentification"],
          bankDetails: i["bankDetails"],
          openingBalance: i["openingBalance"],
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        leading: IconButton(
          tooltip: "Back",
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.edit),
            onPressed: () async {
              var v = await Navigator.push(context,
                  CupertinoPageRoute(builder: (context) {
                return EditProfile(data: data);
              }));
              if (v != null) {
                if (v) {
                  _profileHanlder = _getProfile();
                  setState(() {});
                }
              }
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: _profileHanlder,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return futureWaitingLoading(context);
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return ListView(
              padding: const EdgeInsets.all(10),
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Center(
                        child: ClipOval(
                          child: Image.network(
                            _profileImg,
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Table(
                        children: [
                          tableData(
                              context, "Profile Name", _profileName, null),
                          tableData(context, "Purpose", _purpose, null),
                          tableData(context, "Additional Info", _additionalInfo,
                              null),
                          tableData(context, "Currency", _currency, null),
                          tableData(context, "Date format", _dateFormat, null)
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${_accList.length} Accounts",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      ..._accList.map((j) {
                        return Column(
                          children: [
                            const Divider(),
                            Table(
                              children: [
                                tableData(context, "Account Identification",
                                    j.accountIdentification, null),
                                tableData(context, "Bank Details",
                                    j.bankDetails, null),
                                tableData(
                                  context,
                                  "Account Color",
                                  j.accountColor,
                                  Icon(
                                    Icons.circle,
                                    color: Color(int.parse(j.accountColor)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      })
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
