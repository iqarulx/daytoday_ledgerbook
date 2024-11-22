/*
  Copyright 2024 Srisoftwarez. All rights reserved.
  Use of this source code is governed by a BSD-style license that can be
  found in the LICENSE file.
*/

import 'package:flutter/material.dart';
import '/services/services.dart';

class CacheDialog extends StatefulWidget {
  const CacheDialog({super.key});

  @override
  State<CacheDialog> createState() => _CacheDialogState();
}

class _CacheDialogState extends State<CacheDialog> {
  Future<String>? _cacheHandler;

  @override
  void initState() {
    _cacheHandler = getCache();
    super.initState();
  }

  Future<String> getCache() async {
    try {
      return await AppCache.getCacheSize(context);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide.none,
      ),
      title: const Text("Cache Size"),
      content: FutureBuilder(
        future: _cacheHandler,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading...");
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            if (snapshot.data != null) {
              return RichText(
                text: TextSpan(
                  text: "Total cache size is ",
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                  children: [
                    TextSpan(
                      text: snapshot.data,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.blackColor,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                      ),
                    )
                  ],
                ),
              );
            } else {
              return const Text("Loading...");
            }
          }
        },
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context, true);
                },
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.whiteColor,
                  ),
                  child: Center(
                    child: Text(
                      "Clear",
                      style: TextStyle(
                        color: AppColors.greyColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context, false);
                },
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primaryColor,
                  ),
                  child: Center(
                    child: Text(
                      "Ok",
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
