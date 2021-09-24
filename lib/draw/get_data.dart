import 'dart:convert';
import 'dart:io';

import 'package:drift_dynamics/domain/data.dart';
import 'package:drift_dynamics/providers/data_page.dart';
import 'package:drift_dynamics/providers/user_provider.dart';
import 'package:drift_dynamics/util/app_url.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../database/round.dart';
import '../database/session.dart';
import '../database/session_list.dart';
import '../domain/user.dart';

class GetData {
  void getRounds(context) async {
    DataPageProvider dataPageProvider =
        Provider.of<DataPageProvider>(context, listen: false);
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
    dataPageProvider.setAllRounds([]);
    for (var item in res) {
      Round round = new Round.fromMap(item);
      dataPageProvider.addAllRounds(round);
    }
    if (dataPageProvider.data.allSessionList == null)
      dataPageProvider.setAllSessionList([]);
    if (dataPageProvider.data.key == null) dataPageProvider.setKey(false);
  }

  void getAllSessionList(context) async {
    DataPageProvider dataPageProvider =
        Provider.of<DataPageProvider>(context, listen: false);
    User user = Provider.of<UserProvider>(context, listen: false).user;

    var response = await http.post(
      AppUrl.getSessionList,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: "token=" +
          user.token +
          "&round_id=" +
          dataPageProvider.data.selectedRound.id.toString(),
    );
    assert(response.statusCode == HttpStatus.ok);
    List res = json.decode(response.body)["Items"];
    dataPageProvider.setAllSessionList([]);
    for (var item in res) {
      SessionList sessionList = new SessionList.fromMap(item);
      dataPageProvider.addAllSessionList(sessionList);
    }
  }

  void getAllSession(context) async {
    DataPageProvider dataPageProvider =
        Provider.of<DataPageProvider>(context, listen: false);
    User user = Provider.of<UserProvider>(context, listen: false).user;
    dataPageProvider.setCurrentSessions([]);
    dataPageProvider.setMaxTime(0);
    try {
      if (dataPageProvider.data.currentIndexesSession != null) {
        for (int index in dataPageProvider.data.currentIndexesSession) {
          var response = await http.post(
            AppUrl.getSession,
            headers: {
              "Content-Type": "application/x-www-form-urlencoded",
            },
            body: "token=" + user.token + "&session_id=" + index.toString(),
          );
          assert(response.statusCode == HttpStatus.ok);
          Session session = Session.fromMap(jsonDecode(response.body));
          dataPageProvider.addCurrentSessions(session);
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
