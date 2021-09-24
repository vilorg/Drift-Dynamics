import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:drift_dynamics/database/round.dart';
import 'package:drift_dynamics/draw/get_data.dart';
import 'package:drift_dynamics/providers/data_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../domain/data.dart';

class DrawData {
  listRounds(height, width, context) {
    DataPageProvider dataPageProvider =
        Provider.of<DataPageProvider>(context, listen: false);
    if (dataPageProvider.data.allRounds == null) {
      return Center(child: CircularProgressIndicator());
    }
    if (dataPageProvider.data.selectedRound == null)
      dataPageProvider.setSelectedRound(
          Round.fromMap(json.decode('{"id":-1,"name":"Select round"}')));
    return Container(
        width: 3 * width / 5,
        child: DropdownButton(
            underline: SizedBox(),
            items: dataPageProvider.data.allRounds
                .map<DropdownMenuItem<Round>>((Round round) {
              return DropdownMenuItem<Round>(
                value: round,
                child: Text(round.name),
              );
            }).toList(),
            onChanged: (Round newRound) {
              dataPageProvider.setSelectedRound(newRound);
              dataPageProvider.setCurrentIndexesSession([]);
              dataPageProvider.setCurrentSessions([]);
              dataPageProvider.setAllSessionList(null);
              GetData().getAllSessionList(context);
            },
            hint: Text(dataPageProvider.data.selectedRound.name.toString(),
                textAlign: TextAlign.center)));
  }

  tablePilots(height, width, context) {
    Data data = Provider.of<DataPageProvider>(context, listen: false).data;
    if (data.currentSessions == null) {
      return Text("No data available");
    }
    return (Column(children: <Widget>[
      Container(
        height: height / 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
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
          itemCount: data.currentSessions.length,
          itemBuilder: (BuildContext context, int index) {
            if (data.colors.length >= index + 1) {
              Color color = Colors.transparent;
              try {
                color = data.colors[index];
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
                            data.currentSessions[index].pilot,
                            style: TextStyle(fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        width: width / 5,
                        child: Text(
                          data.currentSessions[index].speed,
                          style: TextStyle(fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        width: width / 6,
                        child: Text(
                          data.currentSessions[index].speedAvg,
                          style: TextStyle(fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        width: width / 6,
                        child: Text(
                          data.currentSessions[index].angle,
                          style: TextStyle(fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  color: color);
            }
            return Container();
          },
        ),
      )
    ]));
  }

  tableInfoPilots(height, width, context, timer) {
    Timer _timer = timer;
    DataPageProvider dataPageProvider =
        Provider.of<DataPageProvider>(context, listen: false);
    if (dataPageProvider.data.allSessionList == null) {
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
                    "Track",
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
                itemCount: dataPageProvider.data.allSessionList.length,
                itemBuilder: (BuildContext context, int index) {
                  Color colorItem = Colors.white;
                  if (dataPageProvider.data.currentIndexesSession != null) {
                    for (int i = 0;
                        i < dataPageProvider.data.currentIndexesSession.length;
                        i++) {
                      if (dataPageProvider.data.currentIndexesSession[i] ==
                              dataPageProvider.data.allSessionList[index].id &&
                          dataPageProvider.data.colors.length >= i + 1) {
                        colorItem = dataPageProvider.data.colors[i];
                      }
                    }
                  }
                  return AbsorbPointer(
                      child: InkWell(
                        child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  child: Container(
                                    width: width / 5,
                                    child: Text(
                                      dataPageProvider
                                          .data.allSessionList[index].raceDT
                                          .toString(),
                                      style: TextStyle(fontSize: 13),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: width / 5,
                                  child: Text(
                                    dataPageProvider
                                        .data.allSessionList[index].tag
                                        .toString(),
                                    style: TextStyle(fontSize: 13),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                  width: width / 5,
                                  child: Text(
                                    dataPageProvider
                                        .data.allSessionList[index].pilot
                                        .toString(),
                                    style: TextStyle(fontSize: 13),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                  width: width / 5,
                                  child: Text(
                                    dataPageProvider
                                        .data.allSessionList[index].track
                                        .toString(),
                                    style: TextStyle(fontSize: 13),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            color: colorItem),
                        onTap: () {
                          dataPageProvider.setKey(true);
                          _timer = Timer(Duration(milliseconds: 1000), () {
                            dataPageProvider.setKey(false);
                          });
                          if (dataPageProvider.data.currentIndexesSession ==
                              null)
                            dataPageProvider.setCurrentIndexesSession([]);
                          for (int i = 0;
                              i <
                                  dataPageProvider
                                      .data.currentIndexesSession.length;
                              i++) {
                            if (dataPageProvider
                                    .data.currentIndexesSession[i] ==
                                dataPageProvider
                                    .data.allSessionList[index].id) {
                              dataPageProvider.removeAtCurrentIndexesSession(i);
                              GetData().getAllSession(context);
                              return;
                            }
                          }
                          if (dataPageProvider.data.colors.length >
                              dataPageProvider
                                  .data.currentIndexesSession.length) {
                            dataPageProvider.addCurrentIndexesSession(
                                dataPageProvider.data.allSessionList[index].id);
                            GetData().getAllSession(context);
                          }
                        },
                      ),
                      absorbing: dataPageProvider.data.key);
                }),
          )
        ]));
  }
}
