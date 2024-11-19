/*
  Copyright 2024 Srisoftwarez. All rights reserved.
  Use of this source code is governed by a BSD-style license that can be
  found in the LICENSE file.
*/

import 'dart:developer';
import 'package:flutter/material.dart';
import '/appui/alartbox.dart';
import '../../language/applanguage.dart';
import '../../main.dart';
import '../db/datamodel.dart';
import '../db/dbservice.dart';

List<CategoryFormat> categoryList = [];

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  var userSerive = DateService();
  TextEditingController categoryname = TextEditingController();

  int crttab = 0;

  getdata() async {
    if (categoryList.isEmpty) {
      categoryList.clear();
      var data = await userSerive.readAllDataCategory();
      setState(() {
        for (var element in data) {
          CategoryFormat categoryFormat = CategoryFormat();
          categoryFormat.name = element["name"];
          categoryFormat.iSincome = element["isincome"];
          categoryFormat.hide = element["hide"];
          categoryFormat.custom = element["custom"];

          categoryList.add(categoryFormat);
        }
      });
      log(data.toString());
    }
  }

  createCategory() async {
    if (categoryname.text.isNotEmpty) {
      loading(context);

      CategoryFormat categoryFormat = CategoryFormat();
      categoryFormat.name = categoryname.text;
      categoryFormat.iSincome = crttab == 0 ? 1 : 2;
      categoryFormat.hide = 0;
      categoryFormat.custom = 1;
      var data = await userSerive.saveCategoryData(categoryFormat);
      Navigator.pop(context);
      Navigator.pop(context);
      if (data > -1) {
        categoryList.clear();
        getdata();
      } else {
        alertbox(context, "Alert", "Category Not Create");
      }
    } else {
      Navigator.pop(context);
      alertbox(context, "Alert", "Category Name is Must");
    }
  }

  geticonfun<IconsData>(String icon) {
    switch (icon.toLowerCase()) {
      case "bonus":
        return Icons.new_releases;
      case "interest income":
        return Icons.account_balance;
      case "inverstment":
        return Icons.paid;
      case "reimbursement":
        return Icons.article_outlined;
      case "rental income":
        return Icons.maps_home_work;
      case "returned purchase":
        return Icons.shopping_cart_checkout;
      case "salary":
        return Icons.payments;
      case "atm":
        return Icons.atm;
      case "air tickets":
        return Icons.flight;
      case "auto and transport":
        return Icons.commute;
      case "beauty":
        return Icons.face;
      case "Bike":
        return Icons.two_wheeler;
      case "bills and utilities":
        return Icons.two_wheeler;
      case "books":
        return Icons.library_books;
      case "Bus Fare":
        return Icons.directions_bus;
      case "cc bill payment":
        return Icons.credit_card;
      case "cable":
        return Icons.tv;
      case "cake":
        return Icons.cake;
      case "car":
        return Icons.drive_eta;
      case "car loan":
        return Icons.drive_eta;
      case "cigarette":
        return Icons.smoking_rooms;
      case "clothing":
        return Icons.local_mall;
      case "coffee":
        return Icons.local_cafe;
      case "dining":
        return Icons.lunch_dining;
      case "drinks":
        return Icons.wine_bar;
      case "emi":
        return Icons.account_balance;
      case "education":
        return Icons.school;
      case "education loan":
        return Icons.school;
      case "electricity":
        return Icons.tungsten;
      case "electronics":
        return Icons.devices;
      case "entertainment":
        return Icons.theaters;
      case "festivals":
        return Icons.theaters;
      case "finance":
        return Icons.assignment;
      case "fitness":
        return Icons.fitness_center;
      case "flowers":
        return Icons.filter_vintage;
      case "food and dining":
        return Icons.restaurant_menu;
      case "fruits":
        return Icons.dining;
      case "games":
        return Icons.sports_basketball;
      case "gas":
        return Icons.propane_tank;
      case "gifts and donations":
        return Icons.redeem;
      case "groceries":
        return Icons.shopping_cart;
      case "health":
        return Icons.local_hospital;
      case "home loan":
        return Icons.cottage;
      case "hotel":
        return Icons.local_hotel;
      case "Household":
        return Icons.home;
      case "ice cream":
        return Icons.home;
      case "internet":
        return Icons.language;
      case "kids":
        return Icons.child_care;
      case "laundry":
        return Icons.local_laundry_service;
      case "maid/driver":
        return Icons.local_laundry_service;
      case "maintenance":
        return Icons.build;
      case "medicines":
        return Icons.monitor_heart;
      case "milk":
        return Icons.local_drink;
      case "misc":
        return Icons.new_releases;
      case "mobile":
        return Icons.smartphone;
      case "movie":
        return Icons.chair;
      case "personal care":
        return Icons.spa;
      case "personal loan":
        return Icons.account_balance;
      case "petrol/gas":
        return Icons.local_gas_station;
      case "pizza":
        return Icons.local_pizza;
      case "printing and scanning":
        return Icons.local_pizza;
      case "rent":
        return Icons.house;
      case "salon":
        return Icons.content_cut;
      case "savings":
        return Icons.account_balance_wallet;
      case "shopping":
        return Icons.shopping_basket;
      case "stationery":
        return Icons.description;
      case "taxes":
        return Icons.local_offer;
      case "taxi":
        return Icons.local_taxi;
      case "toll":
        return Icons.toll;
      case "toys":
        return Icons.smart_toy;
      case "train":
        return Icons.train;
      case "travel":
        return Icons.business_center_outlined;
      case "vacation":
        return Icons.soup_kitchen;
      case "water":
        return Icons.water_drop;
      case "work":
        return Icons.work;
      default:
        return Icons.home;
    }
  }

  addcustomCategory() async {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Container(
                height: 35,
                decoration: BoxDecoration(
                  color: const Color(0xffe6e6ff),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            crttab = 0;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: crttab == 0
                                ? const Color(0xff6666ff)
                                : const Color(0xffe6e6ff),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Center(
                            child: Text(
                              "Income (Credit)",
                              style: TextStyle(
                                color:
                                    crttab == 0 ? Colors.white : Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            crttab = 1;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: crttab == 1
                                ? const Color(0xff6666ff)
                                : const Color(0xffe6e6ff),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Center(
                            child: Text(
                              "Expense (Debit)",
                              style: TextStyle(
                                color:
                                    crttab == 1 ? Colors.white : Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              content: TextFormField(
                controller: categoryname,
                decoration: const InputDecoration(hintText: "Category Name"),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel".toUpperCase(),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    createCategory();
                  },
                  child: Text(
                    "OK".toUpperCase(),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(localizedValues[language]!["category"]!["title"]!),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addcustomCategory();
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
              ),
              child: Text(
                localizedValues[language]!["category"]!["income"]!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            for (var icondata in categoryList)
              if (icondata.iSincome == 1)
                ListTile(
                  leading: icondata.custom == 0
                      ? Icon(
                          geticonfun(icondata.name!),
                          color: Theme.of(context).primaryColor,
                          size: 40,
                        )
                      : Container(
                          height: 40,
                          width: 40,
                          decoration: const BoxDecoration(
                            color: Colors.pinkAccent,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              icondata.name!.substring(0, 2).toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                  title: Text(
                    icondata.name!,
                  ),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_vert,
                    ),
                  ),
                ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
              ),
              child: Text(
                localizedValues[language]!["category"]!["expense"]!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            for (var icondata in categoryList)
              if (icondata.iSincome == 2)
                ListTile(
                  leading: Icon(
                    geticonfun(icondata.name!),
                    color: Theme.of(context).primaryColor,
                    size: 28,
                  ),
                  title: Text(
                    icondata.name!,
                  ),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_vert,
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
