import 'dart:convert';

ValidateLogin validateLoginFromJson(String str) => ValidateLogin.fromJson(json.decode(str));

String validateLoginToJson(ValidateLogin data) => json.encode(data.toJson());

class ValidateLogin {
  ValidateLogin({
    required this.code,
    required this.message,
  });

  int code;
  String message;

  factory ValidateLogin.fromJson(Map<String, dynamic> json) => ValidateLogin(
    code: json["code"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
  };
}
