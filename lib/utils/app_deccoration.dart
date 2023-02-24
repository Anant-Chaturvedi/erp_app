import 'package:flutter/material.dart';

import 'color_constant.dart';
import 'size.dart';

class AppDecoration {
  static BoxDecoration get gradientBlue50Gray100a3 => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(
            0.5,
            0,
          ),
          end: Alignment(
            0.5,
            1,
          ),
          colors: [
            ColorConstant.blue50,
            ColorConstant.gray100A3,
          ],
        ),
      );
  static BoxDecoration get txtFillBluegray900 => BoxDecoration(
        color: ColorConstant.blueGray900,
      );
  static BoxDecoration get outlineBluegray9003f1 => BoxDecoration(
        color: ColorConstant.whiteA700,
        border: Border.all(
          color: ColorConstant.blueGray9003f,
          width: getHorizontalSize(
            1.00,
          ),
          strokeAlign: StrokeAlign.outside,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorConstant.blue5001,
            spreadRadius: getHorizontalSize(
              2.00,
            ),
            blurRadius: getHorizontalSize(
              2.00,
            ),
            offset: Offset(
              0,
              4,
            ),
          ),
        ],
      );
  static BoxDecoration get txtFillBluegray90002 => BoxDecoration(
        color: ColorConstant.blueGray90002,
      );
  static BoxDecoration get outlineBluegray9003f => BoxDecoration(
        border: Border.all(
          color: ColorConstant.blueGray9003f,
          width: getHorizontalSize(
            1.00,
          ),
        ),
      );
  static BoxDecoration get txtFillAmber700 => BoxDecoration(
        color: ColorConstant.amber700,
      );
  static BoxDecoration get gradientBluegray90002Amber700 => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(
            0,
            0.06,
          ),
          end: Alignment(
            1.97,
            1.93,
          ),
          colors: [
            ColorConstant.blueGray90002,
            ColorConstant.amber700,
          ],
        ),
      );
  static BoxDecoration get fillWhiteA700 => BoxDecoration(
        color: ColorConstant.whiteA700,
      );
  static BoxDecoration get fillBluegray900 => BoxDecoration(
        color: ColorConstant.blueGray900,
      );
  static BoxDecoration get txtFillBlue900 => BoxDecoration(
        color: ColorConstant.blue900,
      );
  static BoxDecoration get outlineBlack90026 => BoxDecoration(
        color: ColorConstant.whiteA700,
        boxShadow: [
          BoxShadow(
            color: ColorConstant.black90026,
            spreadRadius: getHorizontalSize(
              2.00,
            ),
            blurRadius: getHorizontalSize(
              2.00,
            ),
            offset: Offset(
              -2.49,
              3.32,
            ),
          ),
        ],
      );
  static BoxDecoration get fillAmber700 => BoxDecoration(
        color: ColorConstant.amber700,
      );
  static BoxDecoration get outlineBluegray9003f3 => BoxDecoration(
        border: Border.all(
          color: ColorConstant.blueGray9003f,
          width: getHorizontalSize(
            1.00,
          ),
          strokeAlign: StrokeAlign.outside,
        ),
      );
  static BoxDecoration get outlineBluegray9003f2 => BoxDecoration(
        color: ColorConstant.whiteA700,
        border: Border.all(
          color: ColorConstant.blueGray9003f,
          width: getHorizontalSize(
            1.00,
          ),
        ),
      );
}

class BorderRadiusStyle {
  static BorderRadius customBorderTL30 = BorderRadius.only(
    topLeft: Radius.circular(
      getHorizontalSize(
        30.00,
      ),
    ),
    topRight: Radius.circular(
      getHorizontalSize(
        30.00,
      ),
    ),
  );

  static BorderRadius roundedBorder7 = BorderRadius.circular(
    getHorizontalSize(
      7.00,
    ),
  );

  static BorderRadius roundedBorder4 = BorderRadius.circular(
    getHorizontalSize(
      4.00,
    ),
  );

  static BorderRadius roundedBorder10 = BorderRadius.circular(
    getHorizontalSize(
      10.00,
    ),
  );

  static BorderRadius txtRoundedBorder5 = BorderRadius.circular(
    getHorizontalSize(
      5.00,
    ),
  );

  static BorderRadius roundedBorder20 = BorderRadius.circular(
    getHorizontalSize(
      20.00,
    ),
  );

  static BorderRadius circleBorder50 = BorderRadius.circular(
    getHorizontalSize(
      50.00,
    ),
  );

  static BorderRadius roundedBorder90 = BorderRadius.circular(
    getHorizontalSize(
      90.00,
    ),
  );

  static BorderRadius roundedBorder29 = BorderRadius.circular(
    getHorizontalSize(
      29.00,
    ),
  );
}
