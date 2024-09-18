// To parse this JSON data, do
//
//     final publicProfile = publicProfileFromJson(jsonString);

import 'dart:convert';

PublicProfile publicProfileFromJson(String str) => PublicProfile.fromJson(json.decode(str));

String publicProfileToJson(PublicProfile data) => json.encode(data.toJson());

class PublicProfile {
    PublicProfile({
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
        this.profileImageUrl,
        required this.userProfile,
        this.forgetPasswordCode,
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
        required this.activeQuestionsCount,
        required this.commentsCount,
    });

    String id;
    String rolesId;
    int socialNetworkId;
    String accountType;
    String firstName;
    String lastName;
    String email;
    int countryCodeId;
    dynamic mobile;
    String userName;
    String randomName;
    String password;
    String? profileImageUrl;
    String? userProfile;
    dynamic forgetPasswordCode;
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
    int activeQuestionsCount;
    int commentsCount;

    factory PublicProfile.fromJson(Map<String, dynamic> json) => PublicProfile(
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
        activeQuestionsCount: json["active_questions_count"],
        commentsCount: json["comments_count"],
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
        "active_questions_count": activeQuestionsCount,
        "comments_count": commentsCount,
    };
}
