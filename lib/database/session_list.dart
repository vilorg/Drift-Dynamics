import 'dart:convert';

SessionList clientFromJson(String str) {
  final jsonData = json.decode(str);
  return SessionList.fromMap(jsonData);
}

String clientToJson(SessionList data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class SessionList {
  String tag;
  String pilot;
  String raceDT;
  String track;
  int id;

  SessionList({this.tag, this.pilot, this.raceDT, this.track, this.id});

  factory SessionList.fromMap(Map<String, dynamic> json) => new SessionList(
        tag: json["tag"],
        pilot: json["pilot"],
        raceDT: json["RaceDT"],
        track: json["track"],
        id: json["id"],
      );

  Map<String, dynamic> toMap() =>
      {"Tag": tag, "Pilot": pilot, "RaceDT": raceDT, "Track": track, "ID": id};
}
