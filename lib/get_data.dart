// import 'dart:convert';
// import 'dart:io';
//
// import 'package:drift_dynamics/providers/user_provider.dart';
// import 'package:drift_dynamics/util/app_url.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;
// import 'database/round.dart';
// import 'database/session.dart';
// import 'database/session_list.dart';
// import 'domain/user.dart';
//
// class GetData {
//   BuildContext context;
//   GetData(BuildContext context){
//     this.context = context;
//   }
//   void getRounds() async {
//     User user = Provider.of<UserProvider>(context, listen: false).user;
//     var response = await http.post(
//       "http://drift-dynamics.com/get_rounds/",
//       headers: {
//         "Content-Type": "application/x-www-form-urlencoded",
//       },
//       body: "token=" + user.token,
//     );
//     assert(response.statusCode == HttpStatus.ok);
//     List res = json.decode(response.body)["Items"];
//     allRounds = [];
//     for (var item in res) {
//       Round round = new Round.fromMap(item);
//       allRounds.add(round);
//     }
//   }
//
//   void getAllSessionList() async {
//     User user = Provider.of<UserProvider>(context, listen: false).user;
//     var response = await http.post(
//       AppUrl.getSessionList,
//       headers: {
//         "Content-Type": "application/x-www-form-urlencoded",
//       },
//       body: "token=" + user.token + "&round_id=" + selectedRound.id.toString(),
//     );
//     assert(response.statusCode == HttpStatus.ok);
//     List res = json.decode(response.body)["Items"];
//     setState(() {
//       allSessionList = [];
//     });
//     for (var item in res) {
//       SessionList sessionList = new SessionList.fromMap(item);
//       setState(() {
//         allSessionList.add(sessionList);
//       });
//     }
//   }
//
//   void getAllSession() async {
//     User user = Provider.of<UserProvider>(context, listen: false).user;
//     allSession = [];
//     for (int index in indexSessionList) {
//       var response = await http.post(
//         AppUrl.getSession,
//         headers: {
//           "Content-Type": "application/x-www-form-urlencoded",
//         },
//         body: "token=" + user.token + "&session_id=" + index.toString(),
//       );
//       assert(response.statusCode == HttpStatus.ok);
//       Session session = Session.fromMap(jsonDecode(response.body));
//       setState(() {
//         allSession.add(session);
//       });
//     }
//   }
// }
