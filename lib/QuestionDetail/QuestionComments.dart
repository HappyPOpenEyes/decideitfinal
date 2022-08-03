// To parse this JSON data, do
//
//     final questionComments = questionCommentsFromJson(jsonString);

import 'dart:convert';

QuestionComments questionCommentsFromJson(String str) =>
    QuestionComments.fromJson(json.decode(str));

String questionCommentsToJson(QuestionComments data) =>
    json.encode(data.toJson());

class QuestionComments {
  QuestionComments({
    required this.questionComments,
    required this.userOptions,
  });

  List<QuestionComment> questionComments;
  List<UserOption>? userOptions;

  factory QuestionComments.fromJson(Map<String, dynamic> json) =>
      QuestionComments(
        questionComments: List<QuestionComment>.from(
            json["questionComments"].map((x) => QuestionComment.fromJson(x))),
        userOptions: json["userOptions"].length == 0
            ? null
            : List<UserOption>.from(json["userOptions"].map((x) => UserOption.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "questionComments":
            List<dynamic>.from(questionComments.map((x) => x.toJson())),
        "userOptions": List<dynamic>.from(userOptions!.map((x) => x)),
      };
}

class QuestionComment {
  QuestionComment({
    required this.id,
    required this.questionId,
    this.questionInviteeId,
    required this.sendAnonymously,
    required this.userOptionId,
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
    this.isLike,
    required this.displayName,
  });

  String id;
  String questionId;
  dynamic questionInviteeId;
  String sendAnonymously;
  String? userOptionId;
  String sortOrder;
  dynamic answerText;
  int isTrue;
  int isActive;
  String createdBy;
  String updatedBy;
  DateTime createdAt;
  DateTime updatedAt;
  User user;
  dynamic userId;
  String firstName;
  String lastName;
  String userName;
  String? profileImageUrl;
  String userOptions;
  List<ChartDatum>? chartData;
  String postedTime;
  String questionTypeId;
  int likesCount;
  dynamic isLike;
  String displayName;

  factory QuestionComment.fromJson(Map<String, dynamic> json) =>
      QuestionComment(
        id: json["id"],
        questionId: json["question_id"],
        questionInviteeId: json["question_invitee_id"],
        sendAnonymously: json["send_anonymously"],
        userOptionId: json["user_option_id"],
        sortOrder: json["sort_order"],
        answerText: json["answer_text"],
        isTrue: json["is_true"],
        isActive: json["is_active"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: User.fromJson(json["user"]),
        userId: json["user_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        userName: json["user_name"],
        profileImageUrl: json["profile_image_url"],
        userOptions: json["user_options"],
        chartData: json["chart_data"] == null || json["chart_data"] == ""
            ? null
            : List<ChartDatum>.from(
                json["chart_data"].map((x) => ChartDatum.fromJson(x))),
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
        "send_anonymously": sendAnonymously,
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
        "chart_data": List<dynamic>.from(chartData!.map((x) => x.toJson())),
        "posted_time": postedTime,
        "question_type_id": questionTypeId,
        "likesCount": likesCount,
        "is_like": isLike,
        "display_name": displayName,
      };
}

class ChartDatum {
  ChartDatum({
    required this.country,
    required this.visits,
  });

  String country;
  int visits;

  factory ChartDatum.fromJson(Map<String, dynamic> json) => ChartDatum(
        country: json["country"],
        visits: json["visits"],
      );

  Map<String, dynamic> toJson() => {
        "country": country,
        "visits": visits,
      };
}

class User {
  User({
    required this.id,
    required this.rolesId,
    required this.socialNetworkId,
    required this.accountType,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.countryCodeId,
    this.mobile,
    required this.userName,
    required this.randomName,
    required this.password,
    required this.profileImageUrl,
    this.userProfile,
    required this.forgetPasswordCode,
    required this.forceChangePassword,
    required this.displayName,
    required this.isInternalUser,
    required this.starsWeightage,
    required this.respondersWeightage,
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
  int? countryCodeId;
  dynamic mobile;
  String userName;
  String randomName;
  String? password;
  String? profileImageUrl;
  dynamic userProfile;
  String? forgetPasswordCode;
  int forceChangePassword;
  int displayName;
  int isInternalUser;
  String starsWeightage;
  String respondersWeightage;
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

  factory User.fromJson(Map<String, dynamic> json) => User(
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
        starsWeightage: json["stars_weightage"],
        respondersWeightage: json["responders_weightage"],
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
        "stars_weightage": starsWeightage,
        "responders_weightage": respondersWeightage,
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

class UserOption {
  UserOption({
    required this.id,
    required this.questionId,
    required this.value,
    required this.isActive,
    required this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.sortOrder,
    this.answerText,
  });

  String id;
  String questionId;
  String value;
  int isActive;
  String createdBy;
  dynamic updatedBy;
  DateTime createdAt;
  DateTime updatedAt;
  String sortOrder;
  dynamic answerText;

  factory UserOption.fromJson(Map<String, dynamic> json) => UserOption(
        id: json["id"],
        questionId: json["question_id"],
        value: json["value"],
        isActive: json["is_active"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        sortOrder: json["sort_order"],
        answerText: json["answer_text"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question_id": questionId,
        "value": value,
        "is_active": isActive,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "sort_order": sortOrder,
        "answer_text": answerText,
      };
}
