import 'dart:convert';

LinkedinData validateLinkedinFromJson(String str) =>
    LinkedinData.fromJson(json.decode(str));

String validateLinkedinToJson(LinkedinData data) => json.encode(data.toJson());

class LinkedinData {
  LinkedinData(
      {required this.user_id,
      required  this.email, required this.name, required this.token,
      required  this.expires_in});

  String user_id;
  String email;
  String name;
  String token;
  int expires_in;

  factory LinkedinData.fromJson(Map<String, dynamic> json) => LinkedinData(
      user_id: json["user_id"],
      email: json["email"],
      name: json["name"],
      token: json["token"],
      expires_in: json["expires_in"]);

  Map<String, dynamic> toJson() => {
        "user_id": user_id,
        "email": email,
        "name": name,
        "token": token,
        "expires_in": expires_in
      };
}
