// To parse this JSON data, do
//
//     final getDiStars = getDiStarsFromJson(jsonString);

import 'dart:convert';

GetDiStars getDiStarsFromJson(String str) =>
    GetDiStars.fromJson(json.decode(str));

String getDiStarsToJson(GetDiStars data) => json.encode(data.toJson());

class GetDiStars {
  GetDiStars({
    required this.data,
  });

  List<Datum> data;

  factory GetDiStars.fromJson(Map<String, dynamic> json) => GetDiStars(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.id,
    required this.rolesId,
    required this.socialNetworkId,
    required this.accountType,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.countryCodeId,
    required this.mobile,
    required this.userName,
    required this.password,
    required this.profileImageUrl,
    required this.userProfile,
    this.forgetPasswordCode,
    required this.forceChangePassword,
    required this.displayName,
    required this.isInternalUser,
    required this.userStatusId,
    required this.isChecked,
   required  this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.stripeId,
    required this.cardBrand,
    required this.cardLastFour,
    this.trialEndsAt,
    required this.questionsCount,
    required this.activeQuestionsCount,
    required this.commentsCount,
  });

  String id;
  String rolesId;
  int socialNetworkId;
  String accountType;
  String? firstName;
  String? lastName;
  String? email;
  int? countryCodeId;
  String? mobile;
  String? userName;
  String? password;
  String? profileImageUrl;
  String? userProfile;
  dynamic forgetPasswordCode;
  int forceChangePassword;
  int displayName;
  int isInternalUser;
  String userStatusId;
  int isChecked;
  int isActive;
  DateTime createdAt;
  DateTime updatedAt;
  String? stripeId;
  String? cardBrand;
  String? cardLastFour;
  dynamic trialEndsAt;
  int questionsCount;
  int activeQuestionsCount;
  int commentsCount;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        rolesId: json["roles_id"],
        socialNetworkId: json["social_network_id"],
        accountType: json["account_type"],
        firstName: json["first_name"] == null ? null : json["first_name"],
        lastName: json["last_name"] == null ? null : json["last_name"],
        email: json["email"] == null ? null : json["email"],
        countryCodeId:
            json["country_code_id"] == null ? null : json["country_code_id"],
        mobile: json["mobile"] == null ? null : json["mobile"],
        userName: json["user_name"] == null ? null : json["user_name"],
        password: json["password"] == null ? null : json["password"],
        profileImageUrl: json["profile_image_url"] == null
            ? null
            : json["profile_image_url"],
        userProfile: json["user_profile"] == null ? null : json["user_profile"],
        forgetPasswordCode: json["forget_password_code"],
        forceChangePassword: json["force_change_password"],
        displayName: json["display_name"],
        isInternalUser: json["is_internal_user"],
        userStatusId: json["user_status_id"],
        isChecked: json["is_checked"],
        isActive: json["is_active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        stripeId: json["stripe_id"] == null ? null : json["stripe_id"],
        cardBrand: json["card_brand"] == null ? null : json["card_brand"],
        cardLastFour:
            json["card_last_four"] == null ? null : json["card_last_four"],
        trialEndsAt: json["trial_ends_at"],
        questionsCount: json["questions_count"],
        activeQuestionsCount: json["active_questions_count"],
        commentsCount: json["comments_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "roles_id": rolesId,
        "social_network_id": socialNetworkId,
        "account_type": accountType,
        "first_name": firstName == null ? null : firstName,
        "last_name": lastName == null ? null : lastName,
        "email": email == null ? null : email,
        "country_code_id": countryCodeId == null ? null : countryCodeId,
        "mobile": mobile == null ? null : mobile,
        "user_name": userName == null ? null : userName,
        "password": password == null ? null : password,
        "profile_image_url": profileImageUrl == null ? null : profileImageUrl,
        "user_profile": userProfile == null ? null : userProfile,
        "forget_password_code": forgetPasswordCode,
        "force_change_password": forceChangePassword,
        "display_name": displayName,
        "is_internal_user": isInternalUser,
        "user_status_id": userStatusId,
        "is_checked": isChecked,
        "is_active": isActive,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "stripe_id": stripeId == null ? null : stripeId,
        "card_brand": cardBrand == null ? null : cardBrand,
        "card_last_four": cardLastFour == null ? null : cardLastFour,
        "trial_ends_at": trialEndsAt,
        "questions_count": questionsCount,
        "active_questions_count": activeQuestionsCount,
        "comments_count": commentsCount,
      };
}
