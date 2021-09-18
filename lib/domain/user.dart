class User {
  String login;
  String password;
  String token;

  User({this.login, this.password, this.token});

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
        login: responseData['login'],
        password: responseData['password'],
        token: responseData['token'],
    );
  }
}
