// To parse this JSON data, do
//
//     final homeCommunity = homeCommunityFromJson(jsonString);

import 'dart:convert';

HomeCommunity homeCommunityFromJson(String str) =>
    HomeCommunity.fromJson(json.decode(str));

String homeCommunityToJson(HomeCommunity data) => json.encode(data.toJson());

class HomeCommunity {
  HomeCommunity({
    required this.code,
    required this.message,
    required this.count,
    required this.data,
  });

  String code;
  String message;
  String count;
  List<Datum> data;

  factory HomeCommunity.fromJson(Map<String, dynamic> json) => HomeCommunity(
        code: json["code"],
        message: json["message"],
        count: json["count"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "count": count,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.id,
    required this.name,
    required this.itemClass,
  });

  String id;
  String name;
  String itemClass;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        itemClass: json["itemClass"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "itemClass": itemClass,
      };
}

enum ItemClass { FIRST_LEVEL, SECOND_LEVEL }

final itemClassValues = EnumValues({
  "first-level": ItemClass.FIRST_LEVEL,
  "second-level": ItemClass.SECOND_LEVEL
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
