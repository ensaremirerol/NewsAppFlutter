import "package:flutter/material.dart";
import 'package:flushbar/flushbar.dart';
import 'package:news_app/services/theme_manager.dart';

class Utils {
  static Flushbar showFlushBar(BuildContext context, String message) {
    return Flushbar(
      messageText: Text(message),
      duration: Duration(seconds: 3),
      backgroundColor: ThemeManager.instance.getTheme().backgroundColor,
    )..show(context);
  }

  static void push(BuildContext context, Widget widget) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => widget));
  }

  static void pushAndRemove(BuildContext context, Widget widget) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => widget), (route) => false);
  }
}
