import 'dart:convert';

Pilot clientFromJson(String str) {
  final jsonData = json.decode(str);
  return Pilot.fromMap(jsonData);
}

String clientToJson(Pilot data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Pilot {
  int id;
  String name;

  Pilot({
    this.id,
    this.name
  });

  factory Pilot.fromMap(Map<String, dynamic> json) => new Pilot(
      id: json["id"],
      name: json["name"]
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name
  };
}