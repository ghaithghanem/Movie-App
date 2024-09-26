import 'package:flutter/material.dart';

import 'my_colors.dart';

extension CustomColorScheme on ColorScheme {
  Color get yellow => brightness == Brightness.light ? MyColors.yellow : Colors.yellow;
  Color get lightBlue => brightness == Brightness.light ? MyColors.lightBlue : Colors.lightBlue;
  Color get lightBlue2 => brightness == Brightness.light ? MyColors.lightBlue2 : Colors.lightBlueAccent;
  Color get backgroundGrey => brightness == Brightness.light ? MyColors.backgroundGey : Colors.grey;
  Color get grey => brightness == Brightness.light ? MyColors.grey : Colors.grey;
  Color get black => brightness == Brightness.light ? MyColors.black : Colors.white;
  Color get editText => brightness == Brightness.light ? MyColors.edittext : Colors.grey;
  Color get blue => brightness == Brightness.light ? MyColors.blue : Colors.blue;
  Color get primaryRed => brightness == Brightness.light ? Colors.red : Colors.redAccent;
}
