class Info {
  final int result;
  final List<dynamic> items;

  Info(this.result, this.items);

  Info.fromJson(Map<String, dynamic> json)
      : result = json["ResultCode"],
        items = json["Items"];

  Map<String, dynamic> toJson() => {
        'ResultCode': result,
        'token': items,
      };
}
