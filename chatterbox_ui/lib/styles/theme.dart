import 'package:chatterbox_ui/styles/colors.dart';
import 'package:flutter/material.dart';

class CustomTheme {
  Color textFontColor = greyFontColor;
  Color primaryColor = Color(0xFFEF5350);
  Color secondaryColor = Colors.white;
  Color backgroundColor = Color(0xFF212121);
  Color lighterPrimaryColor = Color(0xFFEF9A9A);

  initializeTheme(
      {textFontColor,
      primaryColor,
      secondaryColor,
      backgroundColor,
      lighterPrimaryColor}) {
    this.textFontColor = textFontColor;
    this.primaryColor = primaryColor;
    this.secondaryColor = secondaryColor;
    this.backgroundColor = backgroundColor;
    this.lighterPrimaryColor = lighterPrimaryColor;
  }
}

CustomTheme baseTheme = CustomTheme();

CustomTheme coolTheme = CustomTheme();

themeInitializer() {
  baseTheme.initializeTheme(
    textFontColor: greyFontColor,
    primaryColor: Color(0xFFEF5350),
    secondaryColor: Colors.white,
    backgroundColor: Color(0xFF212121),
    lighterPrimaryColor: Colors.red[200],
  );
  coolTheme.initializeTheme(
    textFontColor: Colors.white,
    primaryColor: Colors.lightBlue[200],
    secondaryColor: Colors.grey[900],
    backgroundColor: Colors.white,
    lighterPrimaryColor: Colors.red[200],
  );
}
