import 'package:flutter/material.dart';
import 'package:movie_Reviewer/screens/home.dart';
import 'package:movie_Reviewer/screens/details_page.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/home',
    routes: {
      '/home':(context)=>Home(),
      '/details':(context)=>Details()
    },
  ));
}
