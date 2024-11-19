/*
  Copyright 2024 Srisoftwarez. All rights reserved.
  Use of this source code is governed by a BSD-style license that can be
  found in the LICENSE file.
*/

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseConnection {
  Future<Database> setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'sri_software');
    var database =
        await openDatabase(path, version: 1, onCreate: _createDatabase);
    return database;
  }

  Future<void> _createDatabase(Database database, int version) async {
    String sql =
        "CREATE TABLE transcationtb(name TEXT,amount NUMERIC,describe TEXT,transcationdate TEXT,isincome INTEGER,category TEXT,uid INTEGER NOT NULL,aid INTEGER NOT NULL)";
    await database.execute(sql);
    String notesql = "CREATE TABLE notetb(notetodo TEXT,transcationdate TEXT)";
    await database.execute(notesql);
    String categorysql =
        "CREATE TABLE category(isincome INTEGER NOT NULL, name TEXT NOT NULL, hide INTEGER NOT NULL, custom INTEGER NOT NULL)";
    await database.execute(categorysql);
    String insertCategory =
        "INSERT INTO `category`(`isincome`,`name`,`hide`,`custom`) VALUES (1,'Bonus','0','0'),(1,'Interest Income','0','0'),(1,'Inverstment','0','0'),(1,'Reimbursement','0','0'),(1,'Rental income','0','0'),(1,'Returned Purchase','0','0'),(1,'Salary','0','0'),(2,'ATM','0','0'),(2,'Air tickets','0','0'),(2,'Auto And Transport','0','0'),(2,'Beauty','0','0'),(2,'Bike','0','0'),(2,'Bills and Utilities','0','0'),(2,'Books','0','0'),(2,'Bus Fare','0','0'),(2,'CC bill payment','0','0'),(2,'Cable','0','0'),(2,'Cake','0','0'),(2,'Car','0','0'),(2,'Car loan','0','0'),(2,'Cigarette','0','0'),(2,'Clothing','0','0'),(2,'Coffee','0','0'),(2,'Dining','0','0'),(2,'Drinks','0','0'),(2,'EMI','0','0'),(2,'Education','0','0'),(2,'Education Loan','0','0'),(2,'Electricity','0','0'),(2,'Electronics','0','0'),(2,'Entertainment','0','0'),(2,'Festivals','0','0'),(2,'Finance','0','0'),(2,'Fitness','0','0'),(2,'Flowers','0','0'),(2,'Food and Dining','0','0'),(2,'Fruits','0','0'),(2,'Games','0','0'),(2,'Gas','0','0'),(2,'Gifts and Donations','0','0'),(2,'Groceries','0','0'),(2,'Health','0','0'),(2,'Home Loan','0','0'),(2,'Hotel','0','0'),(2,'Household','0','0'),(2,'Ice Cream','0','0'),(2,'Internet','0','0'),(2,'kids','0','0'),(2,'Laundry','0','0'),(2,'Maid/Driver','0','0'),(2,'Maintenance','0','0'),(2,'Medicines','0','0'),(2,'Milk','0','0'),(2,'Misc','0','0'),(2,'Personal Care','0','0'),(2,'Personal Loan','0','0'),(2,'Pet Care','0','0'),(2,'Petrol/Gas','0','0'),(2,'Pizza','0','0'),(2,'Printing and Scanning','0','0'),(2,'Rent','0','0'),(2,'Salon','0','0'),(2,'Savings','0','0'),(2,'Shopping','0','0'),(2,'Stationery','0','0'),(2,'Taxes','0','0'),(2,'Taxi','0','0'),(2,'Toll','0','0'),(2,'Toys','0','0'),(2,'Train','0','0'),(2,'Travel','0','0'),(2,'Vacation','0','0'),(2,'Vegetables','0','0'),(2,'Water','0','0'),(2,'Work','0','0');";
    await database.execute(insertCategory);
    String profilesql =
        "CREATE TABLE profile(uid INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, profileimage TEXT NOT NULL, profilename TEXT NOT NULL, profilepurpose TEXT NULL, information TEXT NULL,makedefault INTEGER NOT NULL,deleteprofie INTEGER NOT NULL)";
    await database.execute(profilesql);
    String accountSql =
        "CREATE TABLE profileaccount(aid INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, uid INTEGER NOT NULL,identi TEXT NOT NULL, bank TEXT NOT NULL, balance NUMERIC NOT NULL,color TEXT NOT NULL,makedefault INTEGER NOT NULL,deleteprofie INTEGER NOT NULL)";
    await database.execute(accountSql);
  }
}
