// To parse this JSON data, do
//
//     final postOptions = postOptionsFromJson(jsonString);

import 'dart:convert';

List<PostOptions> postOptionsFromJson(String str) => List<PostOptions>.from(
    json.decode(str).map((x) => PostOptions.fromJson(x)));

String postOptionsToJson(List<PostOptions> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PostOptions {
  PostOptions({
    required this.optionValue,
    required this.isCorrectOption,
    required this.isActive,
  });

  String optionValue;
  int isCorrectOption;
  int isActive;

  factory PostOptions.fromJson(Map<String, dynamic> json) => PostOptions(
        optionValue: json["OptionValue"],
        isCorrectOption: json["IsCorrectOption"],
        isActive: json["IsActive"],
      );

  Map<String, dynamic> toJson() => {
        "OptionValue": optionValue,
        "IsCorrectOption": isCorrectOption,
        "IsActive": isActive,
      };
}
