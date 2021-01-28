import 'package:flutter/material.dart';

class DatosGlobales with ChangeNotifier {
  bool visible1 = false;

  set isVisible1 (bool visible1) {
    this.visible1 = visible1;
    notifyListeners();
  }
  bool get Visible1 => visible1;
}