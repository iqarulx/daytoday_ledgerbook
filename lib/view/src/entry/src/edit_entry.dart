import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '/functions/functions.dart';
import '/model/model.dart';
import '/services/services.dart';
import '/ui/ui.dart';
import '/utils/utils.dart';

class EditEntry extends StatefulWidget {
  final EntryModel query;
  const EditEntry({super.key, required this.query});

  @override
  State<EditEntry> createState() => _EditEntryState();
}

class _EditEntryState extends State<EditEntry> {
  String entryType = "credit";
  TextEditingController amount = TextEditingController();
  TextEditingController accountName = TextEditingController();
  String? accountId;
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  var formKey = GlobalKey<FormState>();

  _editEntry() async {
    try {
      futureLoading(context);
      EntryModel model = EntryModel(
        uid: widget.query.uid,
        userId: '',
        type: entryType == "credit" ? 1 : 2,
        entry: int.parse(amount.text),
        accountId: accountId ?? '',
        accountIdentification: accountName.text,
        description: description.text,
        title: title.text,
        created: DateTime.now(),
      );

      await ScreensFunctions.editEntry(model);

      Navigator.pop(context);
      Snackbar.showSnackBar(context,
          content: "Expense updated", isSuccess: true);
      Navigator.pop(context, true);
    } catch (e) {
      Navigator.pop(context);
      Snackbar.showSnackBar(context, content: e.toString(), isSuccess: false);
    }
  }

  _deleteEntry() async {
    try {
      var v = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => const CDialog(
          title: "Delete Entry",
          content: "Are you sure want to delete entry?",
        ),
      );

      if (v != null) {
        if (v) {
          futureLoading(context);
          EntryModel model = EntryModel(
            uid: widget.query.uid,
            userId: '',
            type: 0,
            entry: 0,
            accountId: '',
            accountIdentification: '',
            description: '',
            title: '',
            created: DateTime.now(),
          );

          await ScreensFunctions.deleteEntry(model);
          Navigator.pop(context);
          Snackbar.showSnackBar(context,
              content: "Expense deleted", isSuccess: true);
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      Navigator.pop(context);
      Snackbar.showSnackBar(context, content: e.toString(), isSuccess: false);
    }
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() {
    entryType = widget.query.type == 1 ? "credit" : "debit";
    amount.text = widget.query.entry.toString();
    accountName.text = widget.query.accountIdentification;
    accountId = widget.query.accountId;
    title.text = widget.query.title;
    description.text = widget.query.description;
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Edit entry",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    IconButton(
                      tooltip: "Delete",
                      icon: const Icon(Iconsax.trash),
                      onPressed: () {
                        _deleteEntry();
                      },
                    ),
                  ],
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
                  child: Text("Update",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: AppColors.pureWhiteColor,
                          )),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      _editEntry();
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
