import 'package:flutter/material.dart';

import '/services/services.dart';

TableRow dailyHead(
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

TableRow dailyBody(
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

TableRow dailyFooter(BuildContext context, String leftData, String rightData) {
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
