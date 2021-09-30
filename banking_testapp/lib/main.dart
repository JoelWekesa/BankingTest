// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'pages/landing.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: "/",
    routes: {
      "/": (context) => Landing(),
    },
    theme: ThemeData(primarySwatch: Colors.cyan),
  ));
}
