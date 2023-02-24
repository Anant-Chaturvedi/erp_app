import 'dart:ui';
import 'package:flutter/material.dart';

class ColorConstant {
  static Color whiteA7007f = fromHex('#7fffffff');

  static Color gray100A3 = fromHex('#a3f3f3f3');

  static Color blueA700 = fromHex('#2d68fe');

  static Color red500 = fromHex('#ff3b3b');

  static Color blueGray900Bf01 = fromHex('#bf14213d');

  static Color whiteA70033 = fromHex('#33ffffff');

  static Color black900 = fromHex('#000000');

  static Color deepOrange600 = fromHex('#e4572e');

  static Color purpleA700 = fromHex('#ae04ff');

  static Color gray20001 = fromHex('#eaeaea');

  static Color blueGray90002 = fromHex('#14213d');

  static Color whiteA70019 = fromHex('#19ffffff');

  static Color blueGray90001 = fromHex('#272635');

  static Color blue5001 = fromHex('#eef2ff');

  static Color blueGray900 = fromHex('#071e50');

  static Color black90026 = fromHex('#26000000');

  static Color gray700 = fromHex('#5b5b5b');

  static Color blue900 = fromHex('#0c3ba0');

  static Color blueGray100 = fromHex('#cecece');

  static Color gray4003f = fromHex('#3fb6b6b6');

  static Color blueGray900Bf = fromHex('#bf272635');

  static Color gray900 = fromHex('#151515');

  static Color amber700 = fromHex('#fca311');

  static Color blueGray90003 = fromHex('#333333');

  static Color blueGray9007f = fromHex('#7f272635');

  static Color gray200 = fromHex('#e7e7e7');

  static Color blue50 = fromHex('#eaf0ff');

  static Color whiteA700Bf = fromHex('#bfffffff');

  static Color bluegray400 = fromHex('#888888');

  static Color blueGray9003f = fromHex('#3f272635');

  static Color whiteA700 = fromHex('#ffffff');

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
