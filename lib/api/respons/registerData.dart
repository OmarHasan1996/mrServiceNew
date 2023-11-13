// To parse this JSON data, do
//
//     final registerData = registerDataFromJson(jsonString);

import 'dart:convert';

RegisterData registerDataFromJson(String str) => RegisterData.fromJson(json.decode(str));

String registerDataToJson(RegisterData data) => json.encode(data.toJson());

class RegisterData {
  List<Datum> data;
  int total;
  dynamic aggregateResults;
  dynamic errors;

  RegisterData({
    required this.data,
    required this.total,
    required this.aggregateResults,
    required this.errors,
  });

  factory RegisterData.fromJson(Map<String, dynamic> json) => RegisterData(
    data: List<Datum>.from(json["Data"].map((x) => Datum.fromJson(x))),
    total: json["Total"],
    aggregateResults: json["AggregateResults"],
    errors: json["Errors"],
  );

  Map<String, dynamic> toJson() => {
    "Data": List<dynamic>.from(data.map((x) => x.toJson())),
    "Total": total,
    "AggregateResults": aggregateResults,
    "Errors": errors,
  };
}

class Datum {
  String id;
  String name;
  String lastName;
  String mobile;
  String email;
  String password;
  String verificationCode;
  bool isVerified;
  int type;
  dynamic dob;
  dynamic imagePath;
  dynamic file;
  dynamic eventDate;
  dynamic fbKey;
  dynamic lang;
  List<dynamic> groupUsers;

  Datum({
    required this.id,
    required this.name,
    required this.lastName,
    required this.mobile,
    required this.email,
    required this.password,
    required this.verificationCode,
    required this.isVerified,
    required this.type,
    required this.dob,
    required this.imagePath,
    required this.file,
    required this.eventDate,
    required this.fbKey,
    required this.lang,
    required this.groupUsers,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["Id"],
    name: json["Name"],
    lastName: json["LastName"],
    mobile: json["Mobile"],
    email: json["Email"],
    password: json["Password"],
    verificationCode: json["VerificationCode"],
    isVerified: json["IsVerified"],
    type: json["Type"],
    dob: json["Dob"],
    imagePath: json["ImagePath"],
    file: json["File"],
    eventDate: json["EventDate"],
    fbKey: json["FBKey"],
    lang: json["Lang"],
    groupUsers: List<dynamic>.from(json["GroupUsers"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Name": name,
    "LastName": lastName,
    "Mobile": mobile,
    "Email": email,
    "Password": password,
    "VerificationCode": verificationCode,
    "IsVerified": isVerified,
    "Type": type,
    "Dob": dob,
    "ImagePath": imagePath,
    "File": file,
    "EventDate": eventDate,
    "FBKey": fbKey,
    "Lang": lang,
    "GroupUsers": List<dynamic>.from(groupUsers.map((x) => x)),
  };
}
