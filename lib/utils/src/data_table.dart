// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '/services/services.dart';

TableRow tableData(
    BuildContext context, String leftData, String rightData, Widget? icon) {
  return TableRow(
    children: [
      Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(
          leftData,
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: AppColors.greyColor,
              ),
        ),
      ),
      if (icon == null)
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: rightData.isNotEmpty
              ? Text(
                  rightData,
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: AppColors.blackColor,
                      ),
                )
              : Text(
                  "-",
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                ),
        )
      else
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              icon,
            ],
          ),
        )
    ],
  );
}
