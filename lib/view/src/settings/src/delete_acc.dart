// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Project imports:
import '/services/services.dart';
import '/ui/ui.dart';
import '/view/view.dart';

class DeleteAcc extends StatefulWidget {
  const DeleteAcc({super.key});

  @override
  State<DeleteAcc> createState() => _DeleteAccState();
}

class _DeleteAccState extends State<DeleteAcc> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: "Back",
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Delete Account"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.pureWhiteColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Attention",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Please read carefully before deleting your account:",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  "1. Once you delete your account, you will no longer have access to it.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 5),
                Text(
                  "2. All your data will be permanently deleted, including expense entries, notes, and uploaded files.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 5),
                Text(
                  "3. Recovery is not possible as we do not maintain deleted data in a trash or backup.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 5),
                Text(
                  "4. For your security, your financial data will be removed immediately upon submitting the deletion request.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  "If you're sure about deleting your account, proceed with caution.",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Theme.of(context).primaryColor),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: MaterialStateProperty.all(const Size(100, 40)),
              padding: MaterialStateProperty.all(EdgeInsets.zero),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            child: Text("Confirm delete?",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: AppColors.pureWhiteColor,
                    )),
            onPressed: () {
              _deleteAcc();
            },
          ),
        ],
      ),
    );
  }

  _deleteAcc() async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const CDialog(
        title: "Delete Account",
        content: "Are you sure want to delete account?",
      ),
    ).then((v) async {
      if (v != null) {
        if (v) {
          try {
            futureLoading(context);
            await AuthService.deleteAccount();
            Navigator.pop(context);
            Snackbar.showSnackBar(context,
                isSuccess: true, content: "Account deleted");
            Navigator.pushReplacement(context,
                CupertinoPageRoute(builder: (context) {
              return const Signin();
            }));
          } catch (e) {
            Navigator.pop(context);

            Snackbar.showSnackBar(context,
                isSuccess: false, content: e.toString());
          }
        }
      }
    });
  }
}
