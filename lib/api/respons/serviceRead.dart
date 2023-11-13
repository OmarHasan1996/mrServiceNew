// To parse this JSON data, do
//
//     final serviceRead = serviceReadFromJson(jsonString);

import 'dart:convert';

ServiceRead serviceReadFromJson(String str) => ServiceRead.fromJson(json.decode(str));

String serviceReadToJson(ServiceRead data) => json.encode(data.toJson());

class ServiceRead {
  Result result;
  String imagesMainPath;

  ServiceRead({
    required this.result,
    required this.imagesMainPath,
  });

  factory ServiceRead.fromJson(Map<String, dynamic> json) => ServiceRead(
    result: Result.fromJson(json["result"]),
    imagesMainPath: json["ImagesMainPath"],
  );

  Map<String, dynamic> toJson() => {
    "result": result.toJson(),
    "ImagesMainPath": imagesMainPath,
  };
}

class Result {
  List<ServiceDatum> data;
  int total;
  dynamic aggregateResults;
  dynamic errors;

  Result({
    required this.data,
    required this.total,
    required this.aggregateResults,
    required this.errors,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    data: List<ServiceDatum>.from(json["Data"].map((x) => ServiceDatum.fromJson(x))),
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

class ServiceDatum {
  int id;
  String name;
  String imagePath;
  Desc desc;
  int? serviceParentId;
  Service? service;
  bool isMain;
  bool isActive;
  double price;

  ServiceDatum({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.desc,
    required this.serviceParentId,
    required this.service,
    required this.isMain,
    required this.isActive,
    required this.price,
  });

  factory ServiceDatum.fromJson(Map<String, dynamic> json) => ServiceDatum(
    id: json["Id"],
    name: json["Name"],
    imagePath: json["ImagePath"],
    desc: Desc.fromJson(json["Desc"]),
    serviceParentId: json["ServiceParentId"],
    service: json["Service"] == null ? null : Service.fromJson(json["Service"]),
    isMain: json["IsMain"],
    isActive: json["IsActive"],
    price: json["Price"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Name": name,
    "ImagePath": imagePath,
    "Desc": desc.toJson(),
    "ServiceParentId": serviceParentId,
    "Service": service?.toJson(),
    "IsMain": isMain,
    "IsActive": isActive,
    "Price": price,
  };
}

class Desc {
  List<Header> headers;

  Desc({
    required this.headers,
  });

  factory Desc.fromJson(Map<String, dynamic> json) => Desc(
    headers: List<Header>.from(json["Headers"].map((x) => Header.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Headers": List<dynamic>.from(headers.map((x) => x.toJson())),
  };
}

class Header {
  Key key;
  List<Value> value;

  Header({
    required this.key,
    required this.value,
  });

  factory Header.fromJson(Map<String, dynamic> json) => Header(
    key: keyValues.map[json["Key"]]!,
    value: List<Value>.from(json["Value"].map((x) => valueValues.map[x]!)),
  );

  Map<String, dynamic> toJson() => {
    "Key": keyValues.reverse[key],
    "Value": List<dynamic>.from(value.map((x) => valueValues.reverse[x])),
  };
}

enum Key {
  CONTENT_TYPE
}

final keyValues = EnumValues({
  "Content-Type": Key.CONTENT_TYPE
});

enum Value {
  TEXT_PLAIN_CHARSET_UTF_8
}

final valueValues = EnumValues({
  "text/plain; charset=utf-8": Value.TEXT_PLAIN_CHARSET_UTF_8
});

class Service {
  int id;
  String name;
  String imagePath;
  dynamic file;
  String? desc;
  dynamic unit;
  int? serviceParentId;
  bool isMain;
  int price;
  bool isActive;
  dynamic service;
  dynamic inverseServiceParent;
  List<dynamic> orderServices;

  Service({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.file,
    required this.desc,
    required this.unit,
    required this.serviceParentId,
    required this.isMain,
    required this.price,
    required this.isActive,
    required this.service,
    required this.inverseServiceParent,
    required this.orderServices,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json["Id"],
    name: json["Name"],
    imagePath: json["ImagePath"],
    file: json["File"],
    desc: json["Desc"],
    unit: json["Unit"],
    serviceParentId: json["ServiceParentId"],
    isMain: json["IsMain"],
    price: json["Price"],
    isActive: json["IsActive"],
    service: json["Service"],
    inverseServiceParent: json["InverseServiceParent"],
    orderServices: List<dynamic>.from(json["OrderServices"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Name": name,
    "ImagePath": imagePath,
    "File": file,
    "Desc": desc,
    "Unit": unit,
    "ServiceParentId": serviceParentId,
    "IsMain": isMain,
    "Price": price,
    "IsActive": isActive,
    "Service": service,
    "InverseServiceParent": inverseServiceParent,
    "OrderServices": List<dynamic>.from(orderServices.map((x) => x)),
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
