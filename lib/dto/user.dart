class User {
  int id;
  String name;
  String username;
  String? password;
  String? token;

  User(
    this.id,
    this.name,
    this.username,
    this.password,
  );

  User.fromJson(dynamic json)
      : id = json['id'],
        name = json['name'] ?? '',
        username = json['username'],
        password = null,
        token = json['token'];

  dynamic toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'password': password,
      'token': token,
    };
  }
}
