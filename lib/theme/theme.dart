import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier {
  //PARA CAMBIAR EL TEMA LIGHT/DARK
  ThemeData _themeData;
  ThemeChanger(this._themeData);

  getTheme() => _themeData;
  setTheme(ThemeData theme) {
    _themeData = theme;

    notifyListeners();
  }
}