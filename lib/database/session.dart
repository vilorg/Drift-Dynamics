import 'dart:convert';

Session clientFromJson(String str) {
  final jsonData = json.decode(str);
  return Session.fromMap(jsonData);
}

String clientToJson(Session data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Session {
  String track;
  String curTime;
  int sessionId;
  String pilot;
  String speed;
  String speedAvg;
  String angle;
  double offset;
  String time;
  String zero;
  List session;

  Session(
      {this.track,
      this.curTime,
      this.sessionId,
      this.pilot,
      this.speed,
      this.speedAvg,
      this.angle,
      this.offset,
      this.time,
      this.zero,
      this.session});

  factory Session.fromMap(Map<String, dynamic> json) => new Session(
      track: json["Track"],
      curTime: json["current_time"],
      sessionId: json["session_id_1"],
      pilot: json["pilot_1"],
      speed: json["speed_1"],
      speedAvg: json["speed_avg_1"],
      angle: json["angle_1"],
      offset: json["offset_1"],
      time: json["time_1"],
      zero: json["zero_1"],
      session: json["session_1"]);

  Map<String, dynamic> toMap() => {
        "Track": track,
        "current_time": curTime,
        "session_id_1": sessionId,
        "pilot_1": pilot,
        "speed_1": speed,
        "speed_avg_1": speedAvg,
        "angle_1": angle,
        "offset_1": offset,
        "time_1": time,
        "zero_1": zero,
        "session_1": session,
      };
}
