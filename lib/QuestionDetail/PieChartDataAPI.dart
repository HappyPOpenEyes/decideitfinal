// To parse this JSON data, do
//
//     final pieChartData = pieChartDataFromJson(jsonString);

import 'dart:convert';

PieChartData pieChartDataFromJson(String str) =>
    PieChartData.fromJson(json.decode(str));

String pieChartDataToJson(PieChartData data) => json.encode(data.toJson());

class PieChartData {
  PieChartData({
    required this.questionComments,
    required this.userOptions,
  });

  List<QuestionCommentss> questionComments;
  List<dynamic> userOptions;

  factory PieChartData.fromJson(Map<String, dynamic> json) => PieChartData(
        questionComments: List<QuestionCommentss>.from(
            json["questionComments"].map((x) => QuestionCommentss.fromJson(x))),
        userOptions: List<dynamic>.from(json["userOptions"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "questionComments":
            List<dynamic>.from(questionComments.map((x) => x.toJson())),
        "userOptions": List<dynamic>.from(userOptions.map((x) => x)),
      };
}

class QuestionCommentss {
  QuestionCommentss({
    required this.id,
    required this.questionId,
    this.questionInviteeId,
    this.userOptionId,
    required this.sortOrder,
    this.answerText,
    required this.isTrue,
    required this.isActive,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    this.userId,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.profileImageUrl,
    required this.userOptions,
    required this.chartData,
    required this.postedTime,
    required this.questionTypeId,
    required this.likesCount,
    required this.isLike,
    required this.displayName,
  });

  String id;
  String questionId;
  dynamic questionInviteeId;
  dynamic userOptionId;
  String sortOrder;
  dynamic answerText;
  int isTrue;
  int isActive;
  String createdBy;
  String updatedBy;
  DateTime createdAt;
  DateTime updatedAt;
  Userss user;
  dynamic userId;
  String firstName;
  String lastName;
  String userName;
  String profileImageUrl;
  String userOptions;
  List<ChartData> chartData;
  String postedTime;
  String questionTypeId;
  String displayName;
  int likesCount;
  String? isLike;

  factory QuestionCommentss.fromJson(Map<String, dynamic> json) =>
      QuestionCommentss(
        id: json["id"],
        questionId: json["question_id"],
        questionInviteeId: json["question_invitee_id"],
        userOptionId: json["user_option_id"],
        sortOrder: json["sort_order"],
        answerText: json["answer_text"],
        isTrue: json["is_true"],
        isActive: json["is_active"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: Userss.fromJson(json["user"]),
        userId: json["user_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        userName: json["user_name"],
        profileImageUrl: json["profile_image_url"],
        userOptions: json["user_options"],
        chartData: List<ChartData>.from(
            json["chart_data"].map((x) => ChartData.fromJson(x))),
        postedTime: json["posted_time"],
        questionTypeId: json["question_type_id"],
        likesCount: json["likesCount"],
        isLike: json["is_like"],
        displayName: json["display_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question_id": questionId,
        "question_invitee_id": questionInviteeId,
        "user_option_id": userOptionId,
        "sort_order": sortOrder,
        "answer_text": answerText,
        "is_true": isTrue,
        "is_active": isActive,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "user": user.toJson(),
        "user_id": userId,
        "first_name": firstName,
        "last_name": lastName,
        "user_name": userName,
        "profile_image_url": profileImageUrl,
        "user_options": userOptions,
        "chart_data": List<dynamic>.from(chartData.map((x) => x.toJson())),
        "posted_time": postedTime,
        "question_type_id": questionTypeId,
        "display_name": displayName,
      };
}

class ChartData {
  ChartData({
    required this.country,
    this.litres,
  });

  String country;
  var litres;

  factory ChartData.fromJson(Map<String, dynamic> json) => ChartData(
        country: json["country"],
        litres: json["litres"],
      );

  Map<String, dynamic> toJson() => {
        "country": country,
        "litres": litres,
      };
}

class Userss {
  Userss({
    required this.id,
    required this.rolesId,
    required this.socialNetworkId,
    required this.accountType,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.countryCodeId,
    this.mobile,
    required this.userName,
    this.randomName,
    required this.password,
    required this.profileImageUrl,
    this.userProfile,
    this.forgetPasswordCode,
    required this.forceChangePassword,
    required this.displayName,
    required this.isInternalUser,
    required this.userStatusId,
    required this.isProfilePrivate,
    required this.isChecked,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.stripeId,
    required this.cardBrand,
    required this.cardLastFour,
    this.trialEndsAt,
  });

  String id;
  String rolesId;
  int socialNetworkId;
  String accountType;
  String firstName;
  String lastName;
  String email;
  dynamic countryCodeId;
  dynamic mobile;
  String userName;
  dynamic randomName;
  String password;
  String profileImageUrl;
  dynamic userProfile;
  dynamic forgetPasswordCode;
  int forceChangePassword;
  int displayName;
  int isInternalUser;
  String userStatusId;
  int isProfilePrivate;
  int isChecked;
  int isActive;
  DateTime createdAt;
  DateTime updatedAt;
  String? stripeId;
  String? cardBrand;
  String? cardLastFour;
  dynamic trialEndsAt;

  factory Userss.fromJson(Map<String, dynamic> json) => Userss(
        id: json["id"],
        rolesId: json["roles_id"],
        socialNetworkId: json["social_network_id"],
        accountType: json["account_type"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        countryCodeId: json["country_code_id"],
        mobile: json["mobile"],
        userName: json["user_name"],
        randomName: json["random_name"],
        password: json["password"],
        profileImageUrl: json["profile_image_url"],
        userProfile: json["user_profile"],
        forgetPasswordCode: json["forget_password_code"],
        forceChangePassword: json["force_change_password"],
        displayName: json["display_name"],
        isInternalUser: json["is_internal_user"],
        userStatusId: json["user_status_id"],
        isProfilePrivate: json["is_profile_private"],
        isChecked: json["is_checked"],
        isActive: json["is_active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        stripeId: json["stripe_id"],
        cardBrand: json["card_brand"],
        cardLastFour: json["card_last_four"],
        trialEndsAt: json["trial_ends_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "roles_id": rolesId,
        "social_network_id": socialNetworkId,
        "account_type": accountType,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "country_code_id": countryCodeId,
        "mobile": mobile,
        "user_name": userName,
        "random_name": randomName,
        "password": password,
        "profile_image_url": profileImageUrl,
        "user_profile": userProfile,
        "forget_password_code": forgetPasswordCode,
        "force_change_password": forceChangePassword,
        "display_name": displayName,
        "is_internal_user": isInternalUser,
        "user_status_id": userStatusId,
        "is_profile_private": isProfilePrivate,
        "is_checked": isChecked,
        "is_active": isActive,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "stripe_id": stripeId,
        "card_brand": cardBrand,
        "card_last_four": cardLastFour,
        "trial_ends_at": trialEndsAt,
      };
}
