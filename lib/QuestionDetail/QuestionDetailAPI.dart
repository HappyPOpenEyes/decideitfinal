// To parse this JSON data, do
//
//     final questionDetailApi = questionDetailApiFromJson(jsonString);

import 'dart:convert';

QuestionDetailApi questionDetailApiFromJson(String str) =>
    QuestionDetailApi.fromJson(json.decode(str));

String questionDetailApiToJson(QuestionDetailApi data) =>
    json.encode(data.toJson());

class QuestionDetailApi {
  QuestionDetailApi({
    required this.id,
    required this.questionText,
    required this.questionTypeId,
    required this.imageVideoUrl,
    required this.views,
    required this.inviteeCanInviteOthers,
    required this.sendAnonymously,
    required this.inviteesOnlyToMe,
    required this.answerOnlyToMe,
    required this.fileExtention,
    required this.createdBy,
    required this.createdAt,
    required this.ownerUserId,
    required this.ownerRoleId,
    required this.plan,
    required this.userId,
    required this.user,
    required this.userName,
    required this.profileImageUrl,
    required this.commentsCount,
    required this.likesCount,
    required this.expiredOn,
    required this.expireTime,
    required this.expireTitle,
    required this.postedTime,
    required this.options,
    required this.inviteesTemp,
    required this.displayStatus,
    required this.community,
    required this.questionDetailApiUserId,
    required this.isLike,
    required this.displayName,
  });

  String id;
  String questionText;
  String questionTypeId;
  String? imageVideoUrl;
  int views;
  String inviteeCanInviteOthers;
  String sendAnonymously;
  String inviteesOnlyToMe;
  String answerOnlyToMe;
  String fileExtention;
  String createdBy;
  DateTime createdAt;
  String ownerUserId;
  String ownerRoleId;
  Plan plan;
  String userId;
  String user;
  String userName;
  String? profileImageUrl;
  int commentsCount;
  int likesCount;
  DateTime expiredOn;
  String expireTime;
  String expireTitle;
  String postedTime;
  List<Option> options;
  List<InviteesTemp> inviteesTemp;
  bool displayStatus;
  List<Community> community;
  UserId? questionDetailApiUserId;
  String? isLike;
  String displayName;

  factory QuestionDetailApi.fromJson(Map<String, dynamic> json) =>
      QuestionDetailApi(
        id: json["id"],
        questionText: json["question_text"],
        questionTypeId: json["question_type_id"],
        imageVideoUrl: json["image_video_url"],
        views: json["views"],
        inviteeCanInviteOthers: json["invitee_can_invite_others"],
        sendAnonymously: json["send_anonymously"],
        inviteesOnlyToMe: json["invitees_only_to_me"],
        answerOnlyToMe: json["answer_only_to_me"],
        fileExtention: json["file_extention"],
        createdBy: json["created_by"],
        createdAt: DateTime.parse(json["created_at"]),
        ownerUserId: json["owner_user_id"],
        ownerRoleId: json["owner_role_id"],
        plan: Plan.fromJson(json["plan"]),
        userId: json["UserId"],
        user: json["user"],
        userName: json["user_name"],
        profileImageUrl: json["profile_image_url"],
        commentsCount: json["commentsCount"],
        likesCount: json["likesCount"],
        expiredOn: DateTime.parse(json["ExpiredOn"]),
        expireTime: json["Expire_time"],
        expireTitle: json["expire_title"],
        postedTime: json["posted_time"],
        options:
            List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
        inviteesTemp: List<InviteesTemp>.from(
            json["invitees_temp"].map((x) => InviteesTemp.fromJson(x))),
        displayStatus: json["display_status"],
        community: List<Community>.from(
            json["community"].map((x) => Community.fromJson(x))),
        questionDetailApiUserId:
            json["user_id"] == null ? null : UserId.fromJson(json["user_id"]),
        isLike: json["is_like"],
        displayName: json["display_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question_text": questionText,
        "question_type_id": questionTypeId,
        "image_video_url": imageVideoUrl,
        "views": views,
        "invitee_can_invite_others": inviteeCanInviteOthers,
        "send_anonymously": sendAnonymously,
        "invitees_only_to_me": inviteesOnlyToMe,
        "answer_only_to_me": answerOnlyToMe,
        "file_extention": fileExtention,
        "created_by": createdBy,
        "created_at": createdAt.toIso8601String(),
        "owner_user_id": ownerUserId,
        "owner_role_id": ownerRoleId,
        "plan": plan.toJson(),
        "UserId": userId,
        "user": user,
        "user_name": userName,
        "profile_image_url": profileImageUrl,
        "commentsCount": commentsCount,
        "likesCount": likesCount,
        "ExpiredOn": expiredOn.toIso8601String(),
        "Expire_time": expireTime,
        "expire_title": expireTitle,
        "posted_time": postedTime,
        "options": List<dynamic>.from(options.map((x) => x.toJson())),
        "invitees_temp":
            List<dynamic>.from(inviteesTemp.map((x) => x.toJson())),
        "display_status": displayStatus,
        "community": List<dynamic>.from(community.map((x) => x.toJson())),
        "user_id": questionDetailApiUserId!.toJson(),
        "is_like": isLike,
        "display_name": displayName,
      };
}

class Community {
  Community({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory Community.fromJson(Map<String, dynamic> json) => Community(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class InviteesTemp {
  InviteesTemp({
    this.address,
    this.user,
  });

  Address? address;
  User? user;

  factory InviteesTemp.fromJson(Map<String, dynamic> json) => InviteesTemp(
        address:
            json["address"] == null ? null : Address.fromJson(json["address"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "address": address!.toJson(),
        "user": user!.toJson(),
      };
}

class Address {
  Address({
    required this.id,
    required this.contactUserId,
    required this.userId,
    required this.contactTypeId,
    required this.contactEmail,
    this.contactFirstName,
    this.contactLastName,
    required this.contactPhone,
    this.serviceProviderId,
    required this.isInvitationSent,
   required  this.isActive,
    required this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String? contactUserId;
  String userId;
  String contactTypeId;
  String? contactEmail;
  dynamic contactFirstName;
  dynamic contactLastName;
  String? contactPhone;
  dynamic serviceProviderId;
  int isInvitationSent;
  int isActive;
  String createdBy;
  dynamic updatedBy;
  DateTime createdAt;
  DateTime updatedAt;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
        contactUserId: json["contact_user_id"],
        userId: json["user_id"],
        contactTypeId: json["contact_type_id"],
        contactEmail: json["contact_email"],
        contactFirstName: json["contact_first_name"],
        contactLastName: json["contact_last_name"],
        contactPhone: json["contact_phone"],
        serviceProviderId: json["service_provider_id"],
        isInvitationSent: json["is_invitation_sent"],
        isActive: json["is_active"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "contact_user_id": contactUserId,
        "user_id": userId,
        "contact_type_id": contactTypeId,
        "contact_email": contactEmail,
        "contact_first_name": contactFirstName,
        "contact_last_name": contactLastName,
        "contact_phone": contactPhone,
        "service_provider_id": serviceProviderId,
        "is_invitation_sent": isInvitationSent,
        "is_active": isActive,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class User {
  User({
    required this.id,
    required this.rolesId,
   required  this.socialNetworkId,
    required this.accountType,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.countryCodeId,
    this.mobile,
    required this.userName,
    required this.randomName,
    required this.password,
    required this.profileImageUrl,
    required this.userProfile,
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
  String? firstName;
  String lastName;
  String email;
  dynamic countryCodeId;
  dynamic mobile;
  String userName;
  String randomName;
  String password;
  String? profileImageUrl;
  String? userProfile;
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

class Option {
  Option({
    required this.id,
    required this.questionId,
    required this.value,
    required this.isActive,
    required this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String questionId;
  String value;
  int isActive;
  String createdBy;
  dynamic updatedBy;
  DateTime createdAt;
  DateTime updatedAt;

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        id: json["id"],
        questionId: json["question_id"],
        value: json["value"],
        isActive: json["is_active"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
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
    required this.isAdmin,
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
  int isAdmin;
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
        isAdmin: json["is_admin"],
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
        "is_admin": isAdmin,
        "is_active": isActive,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class UserId {
  UserId({
    required this.id,
    this.inviteeAnswerId,
    required this.userId,
    required this.questionId,
    required this.comment,
    required this.isActive,
    required this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  dynamic inviteeAnswerId;
  String userId;
  String questionId;
  String comment;
  int isActive;
  String createdBy;
  dynamic updatedBy;
  DateTime createdAt;
  DateTime updatedAt;

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        id: json["id"],
        inviteeAnswerId: json["invitee_answer_id"],
        userId: json["user_id"],
        questionId: json["question_id"],
        comment: json["comment"],
        isActive: json["is_active"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "invitee_answer_id": inviteeAnswerId,
        "user_id": userId,
        "question_id": questionId,
        "comment": comment,
        "is_active": isActive,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
