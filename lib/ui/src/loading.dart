import 'package:flutter/material.dart';

futureLoading(context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    ),
  );
}

futureWaitingLoading(context) {
  return Center(
    child: CircularProgressIndicator(
      color: Theme.of(context).primaryColor,
    ),
  );
}

futureExpandedLoading(context) {
  return Expanded(
    child: Center(
      child: CircularProgressIndicator(
        color: Theme.of(context).primaryColor,
      ),
    ),
  );
}
