import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:drift_dynamics/domain/login.dart';
import 'package:drift_dynamics/domain/user.dart';
import 'package:drift_dynamics/util/app_url.dart';
import 'package:drift_dynamics/util/shared_preference.dart';
import 'package:http/http.dart' as http;

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut
}

class AuthProvider with ChangeNotifier {
  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;

  Status get registeredInStatus => _registeredInStatus;

  Future<Map<String, dynamic>> login(String login, String password) async {
    var result;

    String loginData = "login=" + login + "&pass=" + password;

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    Response response = await http.post(
      AppUrl.login,
      body: loginData,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
    );

    if (response.statusCode == HttpStatus.ok) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      Login loginResult = Login.fromJson(responseData);

      User authUser =
          User(login: login, password: password, token: loginResult.token);

      UserPreferences().saveUser(authUser);

      _loggedInStatus = Status.LoggedIn;
      notifyListeners();

      result = {'status': true, 'message': 'Successful', 'user': authUser};
    } else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {'status': false, 'message': "Error"};
    }
    return result;
  }

  void refreshToken() async {
    Future<User> getUserData() => UserPreferences().getUser();
    User user = await getUserData();

    String loginData = "login=" + user.login + "&pass=" + user.password;

    Response response = await http.post(
      AppUrl.login,
      body: loginData,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
    );
    assert(response.statusCode == HttpStatus.ok);

    String token = Login.fromJson(jsonDecode(response.body)).token;
    UserPreferences().addToken(token);
  }
}
