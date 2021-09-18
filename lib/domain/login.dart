class Login {
  final int result;
  final String token;

  Login(this.result, this.token);

  Login.fromJson(Map<String, dynamic> json)
      : result = json["ResultCode"],
        token = json["token"];

  Map<String, dynamic> toJson() => {
        'ResultCode': result,
        'token': token,
      };
}
