/*
  Copyright 2024 Srisoftwarez. All rights reserved.
  Use of this source code is governed by a BSD-style license that can be
  found in the LICENSE file.
*/

import 'package:flutter/material.dart';

class SetSateDaily with ChangeNotifier {
  bool _stateRefrece = false;
  get stateRefrece => _stateRefrece;

  toggletab(bool stateRefrece) {
    _stateRefrece = stateRefrece;
    notifyListeners();
  }
}

class EditNoteState with ChangeNotifier {
  bool _stateRefrece = false;
  bool _isUpdate = false;
  get stateRefrece => _stateRefrece;
  get isUpdate => _isUpdate;

  toggletab(bool stateRefrece) {
    _stateRefrece = stateRefrece;
    notifyListeners();
  }

  toggleUpdate(bool update) {
    _isUpdate = update;
    notifyListeners();
  }
}

class SetSateLocal with ChangeNotifier {
  Locale _locale = const Locale.fromSubtags(languageCode: 'de');
  get locale => _locale;

  toggletab(Locale value) {
    _locale = value;
    notifyListeners();
  }
}

class ChangeLanguagefun with ChangeNotifier {
  bool _stateRefrece = false;
  get stateRefrece => _stateRefrece;

  toggletab(bool stateRefrece) {
    _stateRefrece = stateRefrece;
    notifyListeners();
  }
}

class ChangeThemeApp with ChangeNotifier {
  String _theme = "orginal";
  get theme => _theme;

  toggletab(String theme) {
    _theme = theme;
    notifyListeners();
  }
}
