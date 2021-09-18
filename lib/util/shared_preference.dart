import 'package:drift_dynamics/domain/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class UserPreferences {
  Future<bool> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("login", user.login);
    prefs.setString("password", user.password);
    prefs.setString("token", user.token);

    return prefs.commit();
  }

  Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String login = prefs.getString("login");
    String password = prefs.getString("password");
    String token = prefs.getString("token");

    return User(
        login: login,
        password: password,
        token: token);
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("login");
    prefs.remove("password");
    prefs.remove("token");
  }

  void addToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
    prefs.setString("token", token);
  }
}
