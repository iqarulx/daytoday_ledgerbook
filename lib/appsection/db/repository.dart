/*
  Copyright 2024 Srisoftwarez. All rights reserved.
  Use of this source code is governed by a BSD-style license that can be
  found in the LICENSE file.
*/

import '/appsection/db/database_connection.dart';
import 'package:sqflite/sqflite.dart';

class Repository {
  late DatabaseConnection _databaseConnection;
  Repository() {
    _databaseConnection = DatabaseConnection();
  }
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _databaseConnection.setDatabase();
      return _database;
    }
  }

  insertData(table, values) async {
    var connection = await database;
    return await connection?.insert(table, values);
  }

  readDataTable(table) async {
    var connection = await database;
    return await connection?.query(table);
  }

  readaccount(table, itemdate) async {
    var connection = await database;
    return await connection?.query(
      table,
      where: 'uid=?',
      whereArgs: [itemdate],
    );
  }

  readData(table) async {
    var connection = await database;
    return await connection?.query(
      table,
      orderBy: 'transcationdate ASC',
    );
  }

  readIncomeDataByDate(table, isIncome) async {
    var connection = await database;
    return await connection?.query(
      table,
      where: 'isincome=?',
      whereArgs: [isIncome],
      orderBy: 'transcationdate ASC',
    );
  }

  readDataByDate(table, itemdate) async {
    var connection = await database;
    return await connection?.query(
      table,
      where: 'transcationdate=?',
      whereArgs: [itemdate],
      orderBy: 'transcationdate DESC',
    );
  }

  readDataByMonth(table, fromdate, todate) async {
    var connection = await database;
    return await connection?.query(
      table,
      where: 'transcationtb.transcationdate BETWEEN ? AND ?',
      whereArgs: [fromdate, todate],
      orderBy: 'transcationdate DESC',
    );
  }

  readIncomeDataByMonth(table, fromdate, todate, isIncome) async {
    var connection = await database;
    return await connection?.query(
      table,
      where: 'isincome=? AND transcationtb.transcationdate BETWEEN ? AND ?',
      whereArgs: [isIncome, fromdate, todate],
      orderBy: 'transcationdate DESC',
    );
  }

  readDataByYear(table, fromdate, todate) async {
    var connection = await database;
    return await connection?.query(
      table,
      where: 'transcationtb.transcationdate BETWEEN ? AND ?',
      whereArgs: [fromdate, todate],
      orderBy: 'transcationdate ASC',
    );
  }

  readIncomeDataByYear(table, fromdate, todate, isIncome) async {
    var connection = await database;
    return await connection?.query(
      table,
      where: 'isincome=? AND transcationtb.transcationdate BETWEEN ? AND ?',
      whereArgs: [isIncome, fromdate, todate],
      orderBy: 'transcationdate ASC',
    );
  }

  newNoteCreate(table, values) async {
    var connection = await database;
    return await connection?.insert(table, values);
  }

  getNoteDetails(table, fromdate, todate) async {
    var connection = await database;
    return await connection?.query(
      table,
      where: 'transcationdate BETWEEN ? AND ?',
      whereArgs: [fromdate, todate],
      orderBy: 'transcationdate DESC',
    );
  }

  getNoteDateDetails(table, itemdate) async {
    var connection = await database;
    return await connection?.query(
      table,
      where: 'transcationdate=?',
      whereArgs: [itemdate],
    );
  }

  updateNoteDetails(table, itemdate, values) async {
    var connection = await database;
    return await connection?.update(
      table,
      values,
      where: 'transcationdate=?',
      whereArgs: [itemdate],
    );
  }

  updateMakeDefalut(table, values, uid) async {
    var connection = await database;
    return await connection?.update(
      table,
      values,
      where: 'uid=?',
      whereArgs: [uid],
    );
  }

  updateMakeDefalutprofile(table, values) async {
    var connection = await database;
    return await connection?.update(
      table,
      values,
    );
  }

  updateProfileDetails(table, values, uid) async {
    var connection = await database;
    return await connection?.update(
      table,
      values,
      where: 'uid=?',
      whereArgs: [uid],
    );
  }

  updateAccountDetails(table, values, uid, aid) async {
    var connection = await database;
    return await connection?.update(
      table,
      values,
      where: 'uid=? AND aid=?',
      whereArgs: [uid, aid],
    );
  }
}
