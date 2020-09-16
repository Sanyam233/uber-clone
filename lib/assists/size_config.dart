import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SizeConfig {
  static double _screenWidth;
  static double _screenHeight;
  static double _blockWidth = 0;
  static double _blockHeight = 0;

  static double textMultiplier;
  static double imageSizeMultiplier;
  static double heightMultiplier;
  static double widthMultiplier;
  static bool isPortrait = true;
  static bool isMobilePortrait = false;
  static var orientationType;

  void init(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      _screenWidth = constraints.maxWidth;
      _screenHeight = constraints.maxHeight;
      isPortrait = true;
      if (_screenWidth < 450) {
        isMobilePortrait = true;
      }
    } else {
      _screenWidth = constraints.maxHeight;
      _screenHeight = constraints.maxWidth;
      isPortrait = false;
      isMobilePortrait = false;
    }

    _blockWidth = _screenWidth / 100;
    _blockHeight = _screenHeight / 100;

    textMultiplier = _blockHeight;
    imageSizeMultiplier = _blockWidth;
    heightMultiplier = _blockHeight;
    widthMultiplier = _blockWidth;
    orientationType = orientation;
    
  }

  static double heightAdjustment(double heightMultiplier) {
    if ((6.5 <= heightMultiplier) && (heightMultiplier < 7.5)) {
      return (40.93 * heightMultiplier);
    } else if ((7.5 <= heightMultiplier) && (heightMultiplier <= 9.0)) {
      return (35.85 * heightMultiplier);
    } else if ((9.0 < heightMultiplier) && (heightMultiplier <= 12)) {
      return (30.15 * heightMultiplier);
    }

    return (35.85 * heightMultiplier);
  }
}
