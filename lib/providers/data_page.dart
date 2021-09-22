import 'package:drift_dynamics/database/round.dart';
import 'package:drift_dynamics/database/session.dart';
import 'package:drift_dynamics/database/session_list.dart';
import 'package:drift_dynamics/domain/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DataPageProvider with ChangeNotifier {
  Data _data = new Data();

  Data get data => _data;

  void setData(Data data) {
    _data = data;
    notifyListeners();
  }

  void setSelectedRound(Round round) {
    _data.setSelectedRound(round);
    notifyListeners();
  }

  void setAllRounds(List<Round> rounds) {
    _data.setAllRounds(rounds);
    notifyListeners();
  }

  void setAllSessionList(List<SessionList> sessionList) {
    _data.setAllSessionList(sessionList);
    notifyListeners();
  }

  void setCurrentIndexesSession(List<int> indexes) {
    _data.setCurrentIndexesSession(indexes);
    notifyListeners();
  }

  void setCurrentSessions(List<Session> sessions) {
    _data.setCurrentSessions(sessions);
    notifyListeners();
  }

  void setMaxTime(double num) {
    _data.setMaxTime(num);
    notifyListeners();
  }

  void addAllRounds(Round round) {
    _data.addAllRounds(round);
    notifyListeners();
  }

  void addAllSessionList(SessionList sessionList) {
    _data.addAllSessionList(sessionList);
    notifyListeners();
  }

  addCurrentIndexesSession(int index) {
    _data.addCurrentIndexesSession(index);
    notifyListeners();
  }

  addCurrentSessions(Session session) {
    _data.addCurrentSessions(session);
    notifyListeners();
  }

  removeAtCurrentIndexesSession(int index) {
    _data.removeAtCurrentIndexesSession(index);
    notifyListeners();
  }

  removeAtCurrentSessions(int index) {
    _data.removeAtCurrentSessions(index);
    notifyListeners();
  }

  void setKey(bool _key){
    _data.setKey(_key);
    notifyListeners();
  }
}
