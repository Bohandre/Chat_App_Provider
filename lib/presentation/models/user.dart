import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  final String nombre;
  final String email;
  final bool online;
  final String uid;

  User({
    required this.nombre,
    required this.email,
    required this.online,
    required this.uid,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        nombre: json["nombre"],
        email: json["email"],
        online: json["online"],
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "email": email,
        "online": online,
        "uid": uid,
      };
}
