// To parse this JSON data, do
//
//     final usersListResponse = usersListResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat_app_provider/presentation/models/models.dart';

UsersListResponse usersListResponseFromJson(String str) =>
    UsersListResponse.fromJson(json.decode(str));

String usersListResponseToJson(UsersListResponse data) =>
    json.encode(data.toJson());

class UsersListResponse {
  final bool ok;
  final List<User> usuarios;

  UsersListResponse({
    required this.ok,
    required this.usuarios,
  });

  factory UsersListResponse.fromJson(Map<String, dynamic> json) =>
      UsersListResponse(
        ok: json["ok"],
        usuarios:
            List<User>.from(json["usuarios"].map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ok": ok,
        "usuarios": List<dynamic>.from(usuarios.map((x) => x.toJson())),
      };
}
