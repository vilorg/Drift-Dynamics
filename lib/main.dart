import 'package:drift_dynamics/draw/get_data.dart';
import 'package:drift_dynamics/home.dart';
import 'package:drift_dynamics/login.dart';
import 'package:drift_dynamics/providers/auth.dart';
import 'package:drift_dynamics/providers/data_page.dart';
import 'package:drift_dynamics/providers/user_provider.dart';
import 'package:drift_dynamics/util/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'domain/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<User> getUserData() => UserPreferences().getUser();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => DataPageProvider())
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: FutureBuilder(
              future: getUserData(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return CircularProgressIndicator();
                  default:
                    if (snapshot.hasError)
                      return Text('Error: ${snapshot.error}');
                    else if (snapshot.data.token == null)
                      return Login();
                    else {
                      UserProvider userProvider =
                          Provider.of<UserProvider>(context);
                      AuthProvider auth = Provider.of<AuthProvider>(context);
                      auth.refreshToken();
                      User user = new User(
                          login: snapshot.data.login,
                          password: snapshot.data.password,
                          token: snapshot.data.token);
                      userProvider.setUser(user);
                      GetData().getRounds(context);
                      return Homepage();
                    }
                }
              }),
          routes: {
            '/dashboard': (context) => Homepage(),
            '/login': (context) => Login(),
          }),
    );
  }
}
