// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

// Project imports:
import '/constants/constants.dart';
import '/functions/functions.dart';
import '/model/model.dart';
import '/services/services.dart';
import '/ui/ui.dart';
import '/utils/utils.dart';

class Entry extends StatefulWidget {
  const Entry({super.key});

  @override
  State<Entry> createState() => _EntryState();
}

class _EntryState extends State<Entry> {
  String entryType = "credit";
  TextEditingController amount = TextEditingController();
  TextEditingController accountName = TextEditingController();
  String? accountId;
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController createdDate = TextEditingController();
  DateTime? _selectedDate;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    createdDate.text = DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now());
    _selectedDate = DateTime.now();
    super.initState();
  }

  _createEntry() async {
    try {
      futureLoading(context);
      var uid = await Db.getData(type: UserData.uid);
      EntryModel model = EntryModel(
        uid: '',
        userId: uid ?? '',
        type: entryType == "credit" ? 1 : 2,
        entry: int.parse(amount.text),
        accountId: accountId ?? '',
        accountIdentification: accountName.text,
        description: description.text,
        title: title.text,
        created: _selectedDate ?? DateTime.now(),
      );

      await ScreensFunctions.createEntry(model);
      Navigator.pop(context);
      Snackbar.showSnackBar(context,
          content: "New expense created", isSuccess: true);
      Navigator.pop(context, true);
    } catch (e) {
      Navigator.pop(context);
      Snackbar.showSnackBar(context, content: e.toString(), isSuccess: false);
    }
  }

  _createdDatePicker() async {
    final DateTime? picked = await dateTimePicker(context);
    if (picked != null) {
      setState(() {
        createdDate.text = DateFormat('yyyy-MM-dd hh:mm a').format(picked);
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: Scaffold(
        backgroundColor: AppColors.pureWhiteColor,
        body: Padding(
          padding: const EdgeInsets.only(left: 15, bottom: 15, right: 15),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                Text(
                  "Create new entry",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 5),
                const Divider(),
                const SizedBox(height: 5),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            entryType = "credit";
                            setState(() {});
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                topLeft: Radius.circular(10),
                              ),
                              color: entryType == "credit"
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).secondaryHeaderColor,
                            ),
                            child: Text(
                              "Credit",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: AppColors.pureWhiteColor),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            entryType = "debit";
                            setState(() {});
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                              color: entryType == "debit"
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).secondaryHeaderColor,
                            ),
                            child: Text(
                              "Debit",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: AppColors.pureWhiteColor),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                FormFields(
                  controller: createdDate,
                  label: "Date",
                  hintText: "Date",
                  readOnly: true,
                  onTap: () {
                    _createdDatePicker();
                  },
                  suffixIcon: const Icon(Iconsax.calendar),
                  valid: (input) {
                    if (input != null) {
                      if (input.isEmpty) {
                        return 'Enter date';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                FormFields(
                  controller: amount,
                  label: "Amount",
                  hintText: "Amount",
                  keyType: TextInputType.number,
                  valid: (input) {
                    if (input != null) {
                      if (input.isEmpty) {
                        return 'Enter amount';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                FormFields(
                  suffixIcon: accountName.text.isEmpty
                      ? const Icon(Icons.arrow_drop_down_rounded)
                      : IconButton(
                          tooltip: "Clear",
                          onPressed: () {
                            accountName.clear();
                            accountId = null;
                            setState(() {});
                          },
                          icon: Icon(
                            Iconsax.close_circle,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                  controller: accountName,
                  label: "Account Name",
                  hintText: "Select",
                  onTap: () async {
                    var value = await Sheet.showSheet(context,
                        size: 0.9, widget: const AccountList());
                    if (value != null) {
                      accountName.text = value["name"];
                      accountId = value["id"];
                      setState(() {});
                    }
                  },
                  readOnly: true,
                  // valid: (input) {
                  //   if (input != null) {
                  //     if (input.isEmpty) {
                  //       return 'Select site';
                  //     }
                  //   }
                  //   return null;
                  // },
                ),
                const SizedBox(height: 10),
                FormFields(
                  controller: title,
                  label: "Title",
                  hintText: "Title",
                ),
                const SizedBox(height: 10),
                FormFields(
                  controller: description,
                  label: "Description",
                  hintText: "Description",
                  maxLines: 3,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minimumSize: MaterialStateProperty.all(const Size(100, 40)),
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  child: Text("Create",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: AppColors.pureWhiteColor,
                          )),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      _createEntry();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
