// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:intl/intl.dart';

// Project imports:
import '/model/model.dart';
import '/services/services.dart';
import '/ui/ui.dart';
import '/utils/utils.dart';
import '/view/view.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  late Future _notesHandler;
  List<DailyNotesModel> _notesList = [];
  @override
  void initState() {
    _notesHandler = _init();
    super.initState();
  }

  _init() async {
    try {
      _notesList.clear();
      _notesList = await HomeService.getDailyNotes();
    } catch (e) {
      Snackbar.showSnackBar(context, content: e.toString(), isSuccess: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        leading: IconButton(
          tooltip: "Back",
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder(
        future: _notesHandler,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return futureWaitingLoading(context);
          } else if (snapshot.hasError) {
            return ErrorWidget(snapshot.error!);
          } else {
            return _buildView();
          }
        },
      ),
    );
  }

  Widget _buildView() {
    if (_notesList.isNotEmpty) {
      return ListView(
        padding: const EdgeInsets.all(10),
        children: [
          for (var i in _notesList)
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            i.date,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 5),
                          const Text("Notes List"),
                        ],
                      ),
                    ],
                  ),
                  const Divider(),
                  ...i.notesList.map((j) {
                    return GestureDetector(
                      onTap: () async {
                        var v = await Sheet.showSheet(context,
                            size: 0.9, widget: EditNotes(query: j));
                        if (v != null) {
                          if (v) {
                            _notesHandler = _init();
                            setState(() {});
                          }
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('hh:mm a').format(j.date),
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            j.notes,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.normal,
                                    ),
                          ),
                          const Divider(),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            )
        ],
      );
    }
    return noData(context);
  }
}
