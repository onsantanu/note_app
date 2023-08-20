import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

showCustomToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 14.0);
}
