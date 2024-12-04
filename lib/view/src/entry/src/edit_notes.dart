import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '/functions/functions.dart';
import '/model/model.dart';
import '/services/services.dart';
import '/ui/ui.dart';
import '/utils/utils.dart';

class EditNotes extends StatefulWidget {
  final NotesModel query;
  const EditNotes({super.key, required this.query});

  @override
  State<EditNotes> createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  TextEditingController notes = TextEditingController();
  TextEditingController date = TextEditingController();
  late DateTime selectedDate;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // date.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    // selectedDate = DateTime.now();

    _init();

    super.initState();
  }

  _init() {
    notes.text = widget.query.notes;
    date.text = DateFormat('yyyy-MM-dd').format(widget.query.date);
    selectedDate = widget.query.date;
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

  _editNotes() async {
    try {
      futureLoading(context);
      NotesModel model = NotesModel(
        uid: widget.query.uid,
        userId: '',
        date: selectedDate,
        notes: notes.text,
        created: DateTime.now(),
      );

      await ScreensFunctions.editNotes(model);
      Navigator.pop(context);
      Snackbar.showSnackBar(context, content: "Notes updated", isSuccess: true);
      Navigator.pop(context, true);
    } catch (e) {
      Navigator.pop(context);
      Snackbar.showSnackBar(context, content: e.toString(), isSuccess: false);
    }
  }

  _deleteNotes() async {
    try {
      futureLoading(context);
      NotesModel model = NotesModel(
        uid: widget.query.uid,
        userId: '',
        date: DateTime.now(),
        notes: '',
        created: DateTime.now(),
      );

      await ScreensFunctions.deleteNotes(model);
      Navigator.pop(context);
      Snackbar.showSnackBar(context, content: "Notes deleted", isSuccess: true);
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Create new notes",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    IconButton(
                      tooltip: "Delete",
                      icon: const Icon(Iconsax.trash),
                      onPressed: () {
                        _deleteNotes();
                      },
                    ),
                  ],
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
                  child: Text("Update",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: AppColors.pureWhiteColor,
                          )),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      _editNotes();
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
