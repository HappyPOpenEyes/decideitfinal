// To parse this JSON data, do
//
//     final contact = contactFromJson(jsonString);

import 'dart:convert';

List<String> contactdetailsFromJson(String str) =>
    List<String>.from(json.decode(str).map((x) => x));

String contactdeatilsToJson(List<String> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x)));
