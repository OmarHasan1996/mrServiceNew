// To parse this JSON data, do
//
//     final loginData = loginDataFromJson(jsonString);

import 'dart:convert';

LoginData loginDataFromJson(String str) => LoginData.fromJson(json.decode(str));

String loginDataToJson(LoginData data) => json.encode(data.toJson());

class LoginData {
  bool status;
  Content? content;
  String errorDes;
  int errorCode;

  LoginData({
    required this.status,
    required this.content,
    required this.errorDes,
    required this.errorCode,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
    status: json["status"],
    content: json["content"] == null ? null : Content.fromJson(json["content"]),
    errorDes: json["error_des"],
    errorCode: json["error_code"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "content": content == null ? null : content!.toJson(),
    "error_des": errorDes,
    "error_code": errorCode,
  };
}

class Content {
  String id;
  String? email;
  String? name;
  String? token;
  String? fbKey;

  Content({
    required this.id,
    required this.email,
    required this.name,
    required this.token,
    required this.fbKey,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    id: json["Id"]??json["id"],
    email: json["Email"]??'',
    name: json["Name"]??'',
    token: json["Token"]??'',
    fbKey: json["FBKey"]??'',
  );

  Map<String, dynamic>? toJson() => {
    "Id": id,
    "Email": email??'',
    "Name": name??'',
    "Token": token??'',
    "FBKey": fbKey??'',
  };
}
