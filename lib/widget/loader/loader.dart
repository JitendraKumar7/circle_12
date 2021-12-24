import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showCenterLoader(BuildContext context, [int? seconds]) {
  var snackBar = SnackBar(
    duration: Duration(seconds: seconds ?? 3),
    backgroundColor: Colors.black45,
    content: Container(
      height: double.infinity,
      alignment: Alignment.center,
      child: CupertinoActivityIndicator(),
    ),
  );
  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(snackBar);
}
