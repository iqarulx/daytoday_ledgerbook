// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';

// Project imports:
import '/services/services.dart';
import '/ui/ui.dart';
import '/utils/utils.dart';

class Downloads extends StatefulWidget {
  const Downloads({super.key});

  @override
  State<Downloads> createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  List<Map<String, dynamic>> downloadsList = [];

  @override
  void initState() {
    super.initState();
    dHanlder = fetchDownloads();
  }

  Future? dHanlder;

  Future fetchDownloads() async {
    downloadsList.clear();
    var data = await DownloadService.getDownloads();

    if (data != null) {
      for (var entry in data.entries) {
        String key = entry.key;
        Map<String, dynamic> value = entry.value;

        downloadsList.add({
          'id': key,
          'file_name': value['file_name'],
          'location': value['location'],
          'file_type': value['file_type'],
          'created': DateTime.parse(value['created']), // Parse to DateTime
        });
      }

      // Sort by 'created' in ascending order
      downloadsList.sort((b, a) => a['created'].compareTo(b['created']));
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Downloads"),
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: "Back",
        ),
        actions: [
          IconButton(
            tooltip: "Delete Downloads",
            onPressed: () async {
              var dr = await showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => const CDialog(
                  title: "Delete",
                  content: "Are you sure want to delete downloads",
                ),
              );
              if (dr != null && dr) {
                await DownloadService.clearDownloads().then((value) {
                  Snackbar.showSnackBar(context,
                      content: "Downloads Deleted", isSuccess: true);
                  dHanlder = fetchDownloads();
                  setState(() {});
                });
              }
            },
            icon: const Icon(Iconsax.trash),
          ),
        ],
      ),
      body: FutureBuilder(
        future: dHanlder,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return futureWaitingLoading(context);
          } else if (snapshot.hasError) {
            return ErrorWidget(snapshot.error!);
          } else {
            if (downloadsList.isEmpty) {
              return noData(context);
            }

            return ListView.separated(
              padding: const EdgeInsets.all(5),
              primary: false,
              shrinkWrap: true,
              itemCount: downloadsList.length,
              itemBuilder: (context, index) {
                var d = downloadsList;

                return ListTile(
                  onTap: () {
                    OpenFile.open(d[index]["location"]);
                  },
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      d[index]["file_type"],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    d[index]["file_name"] ?? "No file name",
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(DateFormat('dd-MM-yyyy hh:mm a')
                      .format(d[index]["created"])),
                  trailing: IconButton(
                    tooltip: "Open file",
                    icon: const Icon(Icons.open_in_new_outlined),
                    onPressed: () {
                      OpenFile.open(d[index]["location"]);
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: Colors.grey.shade300,
                );
              },
            );
          }
        },
      ),
    );
  }
}
