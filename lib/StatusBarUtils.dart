import 'dart:ui';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
class StatusBarUtils {
  static Future setStatus(Color color) async{
    await FlutterStatusbarcolor.setStatusBarColor(color);
   /* if (useWhiteForeground(color)) {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    } else {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    }*/
  }

}
