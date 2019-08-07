import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
class ToastUtils{
    static show(String text){
      Fluttertoast.showToast(
          msg: text,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
}