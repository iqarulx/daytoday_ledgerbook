// Flutter imports:
import 'package:flutter/material.dart';

class Sheet {
  static Future<dynamic> showSheet(BuildContext context,
      {required Widget widget, required double size}) async {
    final value = await showModalBottomSheet(
      backgroundColor: Colors.white,
      useSafeArea: true,
      showDragHandle: true,
      isScrollControlled: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        side: BorderSide.none,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      context: context,
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 500),
      ),
      builder: (BuildContext builderContext) {
        return FractionallySizedBox(heightFactor: size, child: widget);
      },
    );
    return value;
  }
}
