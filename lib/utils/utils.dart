import 'package:flutter/material.dart';

Color hexToColor(String hex) {
  assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex),
      'hex color must be #rrggbb or #rrggbbaa');

  return Color(
    int.parse(hex.substring(1), radix: 16) +
        (hex.length == 7 ? 0xff000000 : 0x00000000),
  );
}

class AppColor {
  static Color lightScaffoldBackgroundColor = hexToColor('#F9F9F9');
  static Color darkScaffoldBackgroundColor = hexToColor('#2F2E2E');
  static Color secondaryAppColor = hexToColor('#5E92F3');
  static Color secondaryDarkAppColor = Colors.white;

  static Color emiScaffoldBgColor = const Color(0xFF607D8B);
  static Color emiContanerTransparent = const Color(0x721D1D1D);

  static Color loanListTileBG = const Color.fromARGB(255, 251, 251, 251);
  static Color emiListTileBG = const Color.fromARGB(255, 34, 24, 24);
}

class AppText {
  static Text titleStatic = const TextStyle(color: Colors.white) as Text;
  static Color emiContanerTransparent = const Color(0x721D1D1D);
}
