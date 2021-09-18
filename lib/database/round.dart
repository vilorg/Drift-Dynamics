import 'dart:convert';


Round clientFromJson(String str) {
  final jsonData = json.decode(str);
  return Round.fromMap(jsonData);
}

String clientToJson(Round data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Round {
  int id;
  String name;

  Round({
    this.id,
    this.name
  });

  factory Round.fromMap(Map<String, dynamic> json) => new Round(
    id: json["id"],
    name: json["name"]
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name
  };
}