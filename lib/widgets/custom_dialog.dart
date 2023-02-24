import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class MyDialogs {
  static void showSnackbar(
      {required BuildContext context,
      required Color,
      String msg = 'Something Went Wrong(Check Internet)!'}) {
    Flushbar(
      borderRadius: BorderRadius.circular(15),
      message: msg,
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: const EdgeInsets.all(8),
      barBlur: 1,
      duration: const Duration(seconds: 2),
      messageSize: 18,
      backgroundColor: Color,
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }

  static void showProgressBar(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => const Center(child: CircularProgressIndicator()));
  }
}
