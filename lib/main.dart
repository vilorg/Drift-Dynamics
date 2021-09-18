import 'package:drift_dynamics/home.dart';
import 'package:drift_dynamics/login_page.dart';
import 'package:flutter/material.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Auto Login',
        initialRoute: '/',
        routes: {
          '/': (context) => LoginPage(),
          '/home': (context) => Homepage()
        }
    );
  }
}