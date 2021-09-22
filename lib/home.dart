import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:drift_dynamics/database/round.dart';
import 'package:drift_dynamics/domain/user.dart';
import 'package:drift_dynamics/draw_data.dart';
import 'package:drift_dynamics/draw_graphs.dart';
import 'package:drift_dynamics/get_data.dart';
import 'package:drift_dynamics/providers/data_page.dart';
import 'package:drift_dynamics/providers/user_provider.dart';
import 'package:drift_dynamics/util/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  _HomepageState();

  @override
  Widget build(BuildContext context) {
    DataPageProvider dataPageProvider = Provider.of<DataPageProvider>(context);
    User user = Provider.of<UserProvider>(context).user;
    var padding = MediaQuery.of(context).padding;
    double height =
        MediaQuery.of(context).size.height - padding.top - padding.bottom;
    double width = MediaQuery.of(context).size.width;
    double relation = width / height;
    Timer _timer;

    return SafeArea(
      child: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Column(children: <Widget>[
              Container(
                  height: height / 14,
                  child: Center(
                      child: Text(
                    user.login,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ))),
              Container(
                height: height / 7,
                child: DrawData().tablePilots(height, width, context),
              ),
              Container(
                height: height / 3,
                child: AspectRatio(
                  aspectRatio: 1.7,
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 18.0, left: 12.0, top: 24, bottom: 12),
                      child: DrawGraphs().mainData(context),
                    ),
                  ),
                ),
              ),
              Container(
                height: height / 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    DrawData().listRounds(height, width, context),
                    Container(
                        width: 2 * width / 7,
                        child: ElevatedButton(
                            onPressed: () {
                              GetData().getRounds(context);
                              dataPageProvider.setAllSessionList(null);
                              dataPageProvider.setCurrentSessions(null);
                              dataPageProvider.setCurrentIndexesSession([]);
                              dataPageProvider.setSelectedRound(Round.fromMap(
                                  json.decode(
                                      '{"id":0,"name":"Select round"}')));
                            },
                            child:
                                Text("Refresh", textAlign: TextAlign.center))),
                  ],
                ),
              ),
              DrawData().tableInfoPilots(height, width, context, _timer)
            ]),
            floatingActionButton: FloatingActionButton(
                elevation: 0.0,
                child: new Icon(Icons.login, color: Colors.black),
                backgroundColor: Colors.transparent,
                onPressed: () {
                  UserPreferences().removeUser();
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/login", (route) => false);
                }),
            floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          );
        }
        return Stack(children: <Widget>[
          Center(
            child: AspectRatio(
              aspectRatio: relation,
              child: Container(
                decoration: const BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 18.0, left: 12.0, top: 24, bottom: 12),
                  child: DrawGraphs().mainData(context),
                ),
              ),
            ),
          )
        ]);
      }),
    );
  }
}
