import 'dart:convert';

import 'package:drift_dynamics/database/round.dart';
import 'package:drift_dynamics/database/session.dart';
import 'package:drift_dynamics/database/session_list.dart';
import 'package:flutter/material.dart';

class Data {
  Round selectedRound =
  Round.fromMap(json.decode('{"id":-1,"name":"2018 RDS GP Round 1"}'));
  List<Round> allRounds;
  List<SessionList> allSessionList = [SessionList()];
  List<int> currentIndexesSession;
  List<Session> currentSessions;
  List colors = [
    Colors.red,
    // Colors.blue,
    Colors.amberAccent,
    // Colors.cyanAccent,
    Colors.purple,
    // Colors.lightGreen,
    Colors.deepOrangeAccent,
    // Colors.purpleAccent
  ];
  double maxTime = 0;
  bool key = false;


  Data(
      {this.selectedRound,
      this.allRounds,
      this.allSessionList,
      this.currentSessions,
      this.currentIndexesSession,
      this.maxTime});

  setSelectedRound(Round round){
    selectedRound = round;
  }

  setAllRounds(List<Round> rounds){
    allRounds = rounds;
  }

  setAllSessionList(List<SessionList> sessionList) {
    allSessionList = sessionList;
  }

  setCurrentIndexesSession(List<int> indexes){
    currentIndexesSession = indexes;
  }

  setCurrentSessions(List<Session> sessions){
    currentSessions = sessions;
  }

  setMaxTime(double num){
    maxTime = num;
  }

  addAllRounds(Round round){
    allRounds.add(round);
  }

  addAllSessionList(SessionList sessionList) {
    allSessionList.add(sessionList);
  }

  addCurrentIndexesSession(int index){
    currentIndexesSession.add(index);
  }

  addCurrentSessions(Session session){
    currentSessions.add(session);
  }

  removeAtCurrentIndexesSession(int index){
    currentIndexesSession.removeAt(index);
  }

  removeAtCurrentSessions(int index){
    currentSessions.removeAt(index);
  }

  setKey(bool _key){
    key = _key;
  }
}
