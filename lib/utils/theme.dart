import 'package:flutter/material.dart';

abstract class ThemeUtils {
  static const Color scaffoldBg = Color.fromRGBO(247, 247, 247, 1);
  static const Color buttonColor = Color.fromRGBO(0, 0, 0, 0.8);
  static const Color bottomNavBg =  Color.fromRGBO(220, 220, 220, 1);
  static const TextStyle rectionText = TextStyle(
      fontSize: 13, color: ThemeUtils.buttonColor, fontWeight: FontWeight.w600);

  static const InputDecoration inputDec = InputDecoration(isDense: true,
    border: OutlineInputBorder()
  );
}
