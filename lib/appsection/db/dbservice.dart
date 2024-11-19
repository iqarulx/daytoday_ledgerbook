/*
  Copyright 2024 Srisoftwarez. All rights reserved.
  Use of this source code is governed by a BSD-style license that can be
  found in the LICENSE file.
*/

import '/appsection/db/datamodel.dart';
import '/appsection/db/repository.dart';

class DateService {
  late Repository _repository;
  DateService() {
    _repository = Repository();
  }

  createProfile(ProfileDataModel values) async {
    return await _repository.insertData("profile", values.dataMap());
  }

  createProfileAccount(AccountDataModel values) async {
    return await _repository.insertData("profileaccount", values.dataMap());
  }

  readAllDataProfile() async {
    return await _repository.readDataTable('profile');
  }

  readAllDataaccount(String uid) async {
    return await _repository.readaccount('profileaccount', uid);
  }

  saveData(TranscationModel modeldata) async {
    return await _repository.insertData("transcationtb", modeldata.dataMap());
  }

  saveCategoryData(CategoryFormat modeldata) async {
    return await _repository.insertData("category", modeldata.dataMap());
  }

  readAllData() async {
    return await _repository.readData('transcationtb');
  }

  readAllDataCategory() async {
    return await _repository.readDataTable('category');
  }

  readAllIncomeData(int isIncome) async {
    return await _repository.readIncomeDataByDate('transcationtb', isIncome);
  }

  readAllNoteData() async {
    return await _repository.readData('notetb');
  }

  crtdayData(String itemdate) async {
    return await _repository.readDataByDate('transcationtb', itemdate);
  }

  crtMonthData(String fromDate, String toDate) async {
    return await _repository.readDataByMonth('transcationtb', fromDate, toDate);
  }

  crtIncomeMonthData(String fromDate, String toDate, int isIncome) async {
    return await _repository.readIncomeDataByMonth(
      'transcationtb',
      fromDate,
      toDate,
      isIncome,
    );
  }

  crtYearData(String fromDate, String toDate) async {
    return await _repository.readDataByYear('transcationtb', fromDate, toDate);
  }

  crtYearIncomeData(String fromDate, String toDate, int isIncome) async {
    return await _repository.readIncomeDataByYear(
      'transcationtb',
      fromDate,
      toDate,
      isIncome,
    );
  }

  saveNote(NoteModel modeldata) async {
    return await _repository.newNoteCreate(
      "notetb",
      modeldata.dataMap(),
    );
  }

  getNote(String fromDate, String toDate) async {
    return await _repository.getNoteDetails('notetb', fromDate, toDate);
  }

  getNoteDate(String itemdate) async {
    return await _repository.getNoteDateDetails('notetb', itemdate);
  }

  updateNote(NoteModel modeldata, String itemdate) async {
    return await _repository.updateNoteDetails(
        'notetb', itemdate, modeldata.dataMap());
  }

  updateaccountDefault(Map<String, Object?> values, int uid) async {
    return await _repository.updateMakeDefalut('profileaccount', values, uid);
  }

  updateAccountSet(int uid, int aid, AccountDataModel values) async {
    return await _repository.updateAccountDetails(
      "profileaccount",
      values.dataMap(),
      uid,
      aid,
    );
  }

  updateProfileDefault(Map<String, Object?> values) async {
    return await _repository.updateMakeDefalutprofile('profile', values);
  }

  updatePorfileSet(int uid, Map<String, Object?> values) async {
    return await _repository.updateProfileDetails('profile', values, uid);
  }
}
