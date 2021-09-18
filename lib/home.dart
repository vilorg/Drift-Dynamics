import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:drift_dynamics/database/round.dart';
import 'package:drift_dynamics/database/session.dart';
import 'package:drift_dynamics/database/session_list.dart';
import 'package:drift_dynamics/domain/user.dart';
import 'package:drift_dynamics/providers/user_provider.dart';
import 'package:drift_dynamics/util/app_url.dart';
import 'package:drift_dynamics/util/shared_preference.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Round selectedRound =
      Round.fromMap(json.decode('{"id":-1,"name":"2018 RDS GP Round 1"}'));

  final List<String> round = <String>[];
  List<Round> allRounds = [];
  List<SessionList> allSessionList = [];
  List<int> indexSessionList = [];
  List<Session> allSession = [];
  List colors = [];
  double maxTime = 0;

  _HomepageState() {
    getRounds();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;

    var padding = MediaQuery.of(context).padding;
    double height =
        MediaQuery.of(context).size.height - padding.top - padding.bottom;
    double width = MediaQuery.of(context).size.width;
    double relation = width / height;

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
              TablePilots(height, width),
              Container(
                height: height / 3,
                child: AspectRatio(
                  aspectRatio: 1.7,
                  child: Container(
                    height: height / 3,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 18.0, left: 12.0, top: 24, bottom: 12),
                      child: LineChart(
                        mainData(),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: height / 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                        width: 3 * width / 5,
                        child: DropdownButton(
                            underline: SizedBox(),
                            items: allRounds
                                .map<DropdownMenuItem<Round>>((Round round) {
                              return DropdownMenuItem<Round>(
                                value: round,
                                child: Text(round.name),
                              );
                            }).toList(),
                            onChanged: (Round newRound) {
                              setState(() {
                                selectedRound = newRound;
                              });
                              getAllSessionList();
                            },
                            hint: Text("Выберите заезд",
                                textAlign: TextAlign.center))),
                    Container(
                        width: 2 * width / 7,
                        child: ElevatedButton(
                            onPressed: () {
                              getRounds();
                            },
                            child: Text("Обновить список",
                                textAlign: TextAlign.center))),
                  ],
                ),
              ),
              TableInfoPilots(height, width)
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
                child: LineChart(
                  mainData(),
                ),
              ),
            ),
          ))
        ]);
      }),
    );
  }

  void getRounds() async {
    User user = Provider.of<UserProvider>(context, listen: false).user;
    var response = await http.post(
      "http://drift-dynamics.com/get_rounds/",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: "token=" + user.token,
    );
    assert(response.statusCode == HttpStatus.ok);
    List res = json.decode(response.body)["Items"];
    allRounds = [];
    for (var item in res) {
      Round round = new Round.fromMap(item);
      setState(() {
        allRounds.add(round);
      });
    }
  }

  void getAllSessionList() async {
    User user = Provider.of<UserProvider>(context, listen: false).user;
    var response = await http.post(
      "http://drift-dynamics.com/get_session_list/",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: "token=" + user.token + "&round_id=" + selectedRound.id.toString(),
    );
    assert(response.statusCode == HttpStatus.ok);
    List res = json.decode(response.body)["Items"];
    setState(() {
      allSessionList = [];
    });
    for (var item in res) {
      SessionList sessionList = new SessionList.fromMap(item);
      setState(() {
        allSessionList.add(sessionList);
      });
    }
  }

  void getAllSession() async {
    User user = Provider.of<UserProvider>(context, listen: false).user;
    allSession = [];
    for (int index in indexSessionList) {
      var response = await http.post(
        AppUrl.getSession,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: "token=" + user.token + "&session_id=" + index.toString(),
      );
      assert(response.statusCode == HttpStatus.ok);
      Session session = Session.fromMap(jsonDecode(response.body));
      setState(() {
        allSession.add(session);
      });
    }
  }

  LineChartData mainData() {
    return LineChartData(
        gridData: FlGridData(show: true, drawVerticalLine: true),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: SideTitles(showTitles: false),
          topTitles: SideTitles(showTitles: false),
          bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            interval: 10000,
            getTextStyles: (context, value) =>
                const TextStyle(color: Colors.black, fontSize: 16),
            getTitles: (value) {
              return (value / 1000).toInt().toString();
            },
            margin: 8,
          ),
          leftTitles: SideTitles(
            showTitles: true,
            interval: 100,
            getTextStyles: (context, value) => const TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
            getTitles: (value) {
              return value.toString();
            },
            reservedSize: 32,
            margin: 12,
          ),
        ),
        minX: 0,
        maxX: maxTime,
        minY: -150,
        maxY: 150,
        lineBarsData: drawGraphs());
  }

  Container TablePilots(height, width) {
    return (Container(
        height: height / 7,
        child: Column(children: <Widget>[
          Container(
            height: height / 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: width / 4,
                  child: Text(
                    "Pilot's name",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: width / 4,
                  child: Text(
                    "Entry",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: width / 7,
                  child: Text(
                    "Average",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: width / 4,
                  child: Text(
                    "Entry angle",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: height / 11,
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: allSession.length,
              itemBuilder: (BuildContext context, int index) {
                if (colors.length != 0) {
                  Color color = Colors.transparent;
                  try {
                    color = colors[index][1];
                  } on Exception catch (_) {}
                  return Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Container(
                              width: width / 4,
                              child: Text(
                                allSession[index].pilot,
                                style: TextStyle(fontSize: 13),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Container(
                            width: width / 5,
                            child: Text(
                              allSession[index].speed,
                              style: TextStyle(fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: width / 6,
                            child: Text(
                              allSession[index].speedAvg,
                              style: TextStyle(fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: width / 6,
                            child: Text(
                              allSession[index].angle,
                              style: TextStyle(fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      color: color);
                } else {
                  return Container();
                }
              },
            ),
          )
        ])));
  }

  TableInfoPilots(height, width) {
    if (allSessionList == []) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
        height: height * 0.384,
        child: Column(children: <Widget>[
          Container(
            height: height / 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: width / 4,
                  child: Text(
                    "Time",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: width / 4,
                  child: Text(
                    "Tag",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: width / 4,
                  child: Text(
                    "Pilot",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: width / 4,
                  child: Text(
                    "Ring",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: height / 3,
            child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: allSessionList.length,
                itemBuilder: (BuildContext context, int index) {
                  Color colorItem = Colors.transparent;
                  for (List list in colors) {
                    if (list[0] == allSessionList[index].id) {
                      colorItem = list[1];
                    }
                  }
                  return InkWell(
                    child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Container(
                                width: width / 5,
                                child: Text(
                                  allSessionList[index].raceDT.toString(),
                                  style: TextStyle(fontSize: 13),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Container(
                              width: width / 5,
                              child: Text(
                                allSessionList[index].tag.toString(),
                                style: TextStyle(fontSize: 13),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              width: width / 5,
                              child: Text(
                                allSessionList[index].pilot.toString(),
                                style: TextStyle(fontSize: 13),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              width: width / 5,
                              child: Text(
                                allSessionList[index].track.toString(),
                                style: TextStyle(fontSize: 13),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        color: colorItem),
                    onTap: () {
                      for (int val in indexSessionList) {
                        if (val == allSessionList[index].id) {
                          for (List list in colors) {
                            if (list[0] == allSessionList[index].id) {
                              setState(() {
                                colors.remove(list);
                                indexSessionList
                                    .remove(allSessionList[index].id);
                                getAllSession();
                              });
                            }
                          }
                          return;
                        }
                      }
                      setState(() {
                        indexSessionList.add(allSessionList[index].id);
                        Color color =
                            Color((Random().nextDouble() * 0xFFFFFF).toInt())
                                .withOpacity(1.0);
                        colors.add([allSessionList[index].id, color]);
                        getAllSession();
                      });
                    },
                  );
                }),
          )
        ]));
  }

  drawGraphs() {
    List<LineChartBarData> result = [];
    int index = 0;
    for (Session session in allSession) {
      List<FlSpot> arraySpeed = [];
      List<FlSpot> arrayAngle = [];
      List data = session.session;
      for (List item in data) {
        if (item[1].toDouble() > maxTime) {
          maxTime = item[1].toDouble();
        }
        arraySpeed.add(FlSpot(item[1].toDouble(), item[4].toDouble()));
        arrayAngle.add(FlSpot(item[1].toDouble(), item[5].toDouble()));
      }
      result.add(LineChartBarData(
        spots: arraySpeed,
        isCurved: false,
        barWidth: 3,
        dotData: FlDotData(show: false),
        colors: [colors[index][1]],
      ));
      result.add(LineChartBarData(
        spots: arrayAngle,
        isCurved: false,
        barWidth: 3,
        dotData: FlDotData(show: false),
        colors: [colors[index][1]],
      ));
      index += 1;
    }
    return result;
  }
}
