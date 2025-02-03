// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '/model/model.dart';
import '/services/services.dart';
import '/utils/src/sheet.dart';
import '/view/view.dart';

TableRow eTableHead(
    BuildContext context, String account, String leftData, String rightData) {
  return TableRow(
    children: [
      Padding(
        padding: const EdgeInsets.all(2.0),
        child: account.isNotEmpty
            ? Text(
                account,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: AppColors.blackColor, fontWeight: FontWeight.bold),
              )
            : Text(
                "-",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: AppColors.blackColor,
                    ),
              ),
      ),
      Padding(
        padding: const EdgeInsets.all(2.0),
        child: leftData.isNotEmpty
            ? Text(
                leftData,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: AppColors.blackColor, fontWeight: FontWeight.bold),
              )
            : Text(
                "-",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: AppColors.blackColor,
                    ),
              ),
      ),
      Padding(
        padding: const EdgeInsets.all(2.0),
        child: rightData.isNotEmpty
            ? Text(
                rightData,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: AppColors.blackColor, fontWeight: FontWeight.bold),
              )
            : Text(
                "-",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: AppColors.blackColor,
                    ),
              ),
      ),
    ],
  );
}

TableRow eTableBody(BuildContext context, String account, String leftData,
    String rightData, EntryModel query, void Function() func) {
  return TableRow(
    children: [
      GestureDetector(
        onTap: () async {
          var v = await Sheet.showSheet(context,
              size: 0.9, widget: EditEntry(query: query));
          if (v != null) {
            if (v) {
              func();
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: account.isNotEmpty
              ? Text(
                  account,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: AppColors.blackColor,
                      ),
                )
              : Text(
                  "-",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: AppColors.blackColor,
                      ),
                ),
        ),
      ),
      GestureDetector(
        onTap: () async {
          var v = await Sheet.showSheet(context,
              size: 0.9, widget: EditEntry(query: query));
          if (v != null) {
            if (v) {
              func();
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: leftData.isNotEmpty
              ? Text(
                  leftData,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: AppColors.greenColor,
                      ),
                )
              : Text(
                  "-",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: AppColors.greenColor,
                      ),
                ),
        ),
      ),
      GestureDetector(
        onTap: () async {
          var v = await Sheet.showSheet(context,
              size: 0.9, widget: EditEntry(query: query));
          if (v != null) {
            if (v) {
              func();
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: rightData.isNotEmpty
              ? Text(
                  rightData,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: AppColors.redColor,
                      ),
                )
              : Text(
                  "-",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: AppColors.redColor,
                      ),
                ),
        ),
      ),
    ],
  );
}

TableRow eTableFooter(BuildContext context, String leftData, String rightData) {
  return TableRow(
    children: [
      Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(
          "Total",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: AppColors.blackColor, fontWeight: FontWeight.bold),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(2.0),
        child: leftData.isNotEmpty
            ? Text(
                leftData,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: AppColors.greenColor,
                    ),
              )
            : Text(
                "-",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: AppColors.greenColor,
                    ),
              ),
      ),
      Padding(
        padding: const EdgeInsets.all(2.0),
        child: rightData.isNotEmpty
            ? Text(
                rightData,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: AppColors.redColor,
                    ),
              )
            : Text(
                "-",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: AppColors.redColor,
                    ),
              ),
      ),
    ],
  );
}
