// To parse this JSON data, do
//
//     final userApi = userApiFromJson(jsonString);

import 'dart:convert';

UserApi userApiFromJson(String str) => UserApi.fromJson(json.decode(str));

String userApiToJson(UserApi data) => json.encode(data.toJson());

class UserApi {
  UserApi({
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
    required this.plan,
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
  String password;
  String? profileImageUrl;
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
  String stripeId;
  String? cardBrand;
  String? cardLastFour;
  dynamic trialEndsAt;
  Plan? plan;

  factory UserApi.fromJson(Map<String, dynamic> json) => UserApi(
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
        password: json["password"],
        profileImageUrl: json["profile_image_url"],
        userProfile: json["user_profile"],
        forgetPasswordCode: json["forget_password_code"],
        forceChangePassword: json["force_change_password"],
        displayName: json["display_name"],
        isInternalUser: json["is_internal_user"],
        userStatusId: json["user_status_id"],
        isChecked: json["is_checked"],
        isProfilePrivate: json["is_profile_private"],
        isActive: json["is_active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        stripeId: json["stripe_id"],
        cardBrand: json["card_brand"],
        cardLastFour: json["card_last_four"],
        trialEndsAt: json["trial_ends_at"],
        plan: json["plan"] == null ? null : Plan.fromJson(json["plan"]),
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
        "plan":  plan!.toJson(),
      };
}

class Plan {
  Plan({
    required this.id,
    required this.stripeProduct,
    required this.stripePlan,
    required this.name,
    required this.amount,
    required this.questionLimitation,
    required this.communityQuestionLimitation,
    required this.numberOfDays,
    required this.communityQuestionNumberOfDays,
    required this.numberOfResponses,
    required this.communityQuestionNumberOfResponses,
    required this.questionValidity,
    required this.communityQuestionValidity,
    required this.numberOfInvitations,
    required this.communityQuestionNumberOfInvitations,
    required this.numberOfCommunities,
    required this.communityQuestionNumberOfCommunities,
    required this.description,
    required this.isActive,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String stripeProduct;
  String stripePlan;
  String name;
  String amount;
  int questionLimitation;
  int communityQuestionLimitation;
  int numberOfDays;
  int communityQuestionNumberOfDays;
  int numberOfResponses;
  int communityQuestionNumberOfResponses;
  int questionValidity;
  int communityQuestionValidity;
  int numberOfInvitations;
  int communityQuestionNumberOfInvitations;
  int numberOfCommunities;
  int communityQuestionNumberOfCommunities;
  String description;
  int isActive;
  String createdBy;
  String updatedBy;
  DateTime createdAt;
  DateTime updatedAt;

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
        id: json["id"],
        stripeProduct: json["stripe_product"],
        stripePlan: json["stripe_plan"],
        name: json["name"],
        amount: json["amount"],
        questionLimitation: json["question_limitation"],
        communityQuestionLimitation: json["community_question_limitation"],
        numberOfDays: json["number_of_days"],
        communityQuestionNumberOfDays:
            json["community_question_number_of_days"],
        numberOfResponses: json["number_of_responses"],
        communityQuestionNumberOfResponses:
            json["community_question_number_of_responses"],
        questionValidity: json["question_validity"],
        communityQuestionValidity: json["community_question_validity"],
        numberOfInvitations: json["number_of_invitations"],
        communityQuestionNumberOfInvitations:
            json["community_question_number_of_invitations"],
        numberOfCommunities: json["number_of_communities"],
        communityQuestionNumberOfCommunities:
            json["community_question_number_of_communities"],
        description: json["description"],
        isActive: json["is_active"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "stripe_product": stripeProduct,
        "stripe_plan": stripePlan,
        "name": name,
        "amount": amount,
        "question_limitation": questionLimitation,
        "community_question_limitation": communityQuestionLimitation,
        "number_of_days": numberOfDays,
        "community_question_number_of_days": communityQuestionNumberOfDays,
        "number_of_responses": numberOfResponses,
        "community_question_number_of_responses":
            communityQuestionNumberOfResponses,
        "question_validity": questionValidity,
        "community_question_validity": communityQuestionValidity,
        "number_of_invitations": numberOfInvitations,
        "community_question_number_of_invitations":
            communityQuestionNumberOfInvitations,
        "number_of_communities": numberOfCommunities,
        "community_question_number_of_communities":
            communityQuestionNumberOfCommunities,
        "description": description,
        "is_active": isActive,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
