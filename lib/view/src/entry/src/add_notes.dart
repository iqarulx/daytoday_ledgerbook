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

class AddNotes extends StatefulWidget {
  const AddNotes({super.key});

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  TextEditingController notes = TextEditingController();
  TextEditingController date = TextEditingController();
  late DateTime selectedDate;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    date.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    selectedDate = DateTime.now();
    super.initState();
  }

  _fromPicker() async {
    final DateTime? picked = await datePicker(context);
    if (picked != null) {
      setState(() {
        date.text = DateFormat('yyyy-MM-dd').format(picked);
        selectedDate = picked;
      });
    }
  }

  _createNotes() async {
    try {
      futureLoading(context);
      var userId = await Db.getData(type: UserData.uid);
      NotesModel model = NotesModel(
        userId: userId ?? '',
        date: selectedDate,
        notes: notes.text,
        created: DateTime.now(),
      );

      await ScreensFunctions.createNotes(model);
      Navigator.pop(context);
      Snackbar.showSnackBar(context,
          content: "New notes created", isSuccess: true);
      Navigator.pop(context, true);
    } catch (e) {
      Navigator.pop(context);
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
      child: Scaffold(
        backgroundColor: AppColors.pureWhiteColor,
        body: Padding(
          padding: const EdgeInsets.only(left: 15, bottom: 15, right: 15),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                Text(
                  "Create new notes",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 5),
                const Divider(),
                const SizedBox(height: 5),
                FormFields(
                  suffixIcon: const Icon(Iconsax.calendar_1),
                  controller: date,
                  label: "Date",
                  hintText: "dd-MM-yyyy",
                  onTap: () => _fromPicker(),
                  readOnly: true,
                ),
                const SizedBox(height: 10),
                FormFields(
                  controller: notes,
                  label: "Notes",
                  hintText: "Notes",
                  maxLines: 8,
                  valid: (input) {
                    if (input != null) {
                      if (input.isEmpty) {
                        return 'Enter notes';
                      }
                    }
                    return null;
                  },
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
                      _createNotes();
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
