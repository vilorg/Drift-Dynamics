import 'dart:io';
import 'package:drift_dynamics/login/text_form.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'login/full_button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  List list = ["", ""];



  @override
  void initState() {
    super.initState();
    autoLogIn();
  }

  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userId = prefs.getString('login');

    if (userId != null) {
      Navigator.pushReplacementNamed(context, '/home');
      return;
    }
  }

  void loginUser() async {
    var response = await http.post(
      "http://drift-dynamics.com/auth/",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: "login=" + list[0] + "&pass=" + list[1],
    );
    assert(response.statusCode == HttpStatus.ok);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('login', list[0]);
    prefs.setString('password', list[1]);
    Navigator.pushReplacementNamed(context, '/home');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(color: Colors.blue),
          padding: EdgeInsets.all(20.0),
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              children: <Widget>[
                Text(
                  "Вход",
                  textAlign: TextAlign.center,
                  style:
                  TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      MyFormTextField(
                        isObscure: false,
                        decoration: InputDecoration(
                          labelText: "Логин",
                          hintText: "login",
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter an email address';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          list[0] = value;
                        },
                      ),
                      MyFormTextField(
                        isObscure: true,
                        decoration: InputDecoration(
                            labelText: "Password", hintText: "my password"),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a password';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          list[1] = value;
                        },
                      ),
                      FormSubmitButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, otherwise false.
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            loginUser();
                            Future.delayed(const Duration(
                                milliseconds: 300), () {
                              Scaffold.of(_formKey.currentContext)
                                  .showSnackBar(SnackBar(
                                  content: Text('Invalid data')));
                            });
                          }
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
