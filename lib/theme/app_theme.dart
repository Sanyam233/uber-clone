import 'package:uberapp1/assists/size_config.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color appBackgroundColor = Colors.white;
  static const Color primaryColor = Colors.black;
  // static const Color accentColor = Color(0xFFEF2D56);
  // static const Color errorColor = Color(0xFFEF233C);


  static final ThemeData lightTheme = ThemeData(
      scaffoldBackgroundColor: AppTheme.appBackgroundColor,
      primaryColor: AppTheme.primaryColor,
      // accentColor: AppTheme.accentColor,
      // errorColor: AppTheme.errorColor,
      brightness: Brightness.light,
      textTheme: _lightTextTheme,);

  static final TextTheme _lightTextTheme = TextTheme(
    headline2: _lightTileLabel,
    headline3: _lightTileCategory,
    headline4: _lightButtonTheme,
    subtitle1: _lightDataTheme,
    // headline5: _lightStatTitle,
    headline6: _lightTile2Category,
    // headline1: _lightLogo,
  );

  static final TextStyle _lightTileLabel = TextStyle(
    color: Colors.black,
    fontFamily: "Roboto",
    fontSize: 2.69 * SizeConfig.heightMultiplier,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle _lightTileCategory = TextStyle(
      color: Colors.black,
      fontFamily: "Roboto",
      fontSize: 1.90 * SizeConfig.heightMultiplier,
      fontWeight: FontWeight.w500);

  static final TextStyle _lightButtonTheme = TextStyle(
      color: Colors.black,
      fontFamily: "Roboto",
      fontSize: 2.01 * SizeConfig.heightMultiplier,
      fontWeight: FontWeight.w500);

  static final TextStyle _lightDataTheme =
      TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400);

  // static final TextStyle _lightStatTitle = TextStyle(
  //     color: AppTheme.accentColor,
  //     fontSize: 2.23 * SizeConfig.heightMultiplier,
  //     fontFamily: "Roboto",
  //     fontWeight: FontWeight.bold);

  static final TextStyle _lightTile2Category = TextStyle(
      color: Colors.black,
      fontSize: 2.12 * SizeConfig.heightMultiplier,
      fontFamily: "Roboto",
      fontWeight: FontWeight.w500);

  // static final TextStyle _lightLogo = TextStyle(
  //   color: AppTheme.accentColor,
  //   fontSize: 2.80 * SizeConfig.heightMultiplier,
  //   fontWeight: FontWeight.bold,
  // );

  
}
