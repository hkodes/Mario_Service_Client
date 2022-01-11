import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

showSnackSuccess(BuildContext context, String text) {
  Flushbar(
    message: text ?? "Done",
    icon: Icon(
      Icons.done,
      size: 28.0,
      color: Colors.white,
    ),
    duration: Duration(seconds: 3),
    backgroundColor: Colors.green[300],
    margin: EdgeInsets.all(8),
  )..show(context);
}

showSnackError(BuildContext context, String text) {
  Flushbar(
    title: "Error",
    message: text ?? "Error",
    icon: Icon(
      Icons.info_outline,
      size: 28.0,
      color: Colors.white,
    ),
    duration: Duration(seconds: 3),
    margin: EdgeInsets.all(8),
    backgroundColor: Colors.red[600],
  )..show(context);
}

showSnackLoading(BuildContext context, String text) {
  if (FocusScope.of(context).isFirstFocus) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }
  Flushbar(
    message: text ?? "Loading",
    showProgressIndicator: true,
    duration: Duration(seconds: 2),
    margin: EdgeInsets.all(8),
  )..show(context);
}
