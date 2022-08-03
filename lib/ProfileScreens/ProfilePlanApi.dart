// To parse this JSON data, do
//
//     final profilePlanApi = profilePlanApiFromJson(jsonString);

import 'dart:convert';

ProfilePlanApi profilePlanApiFromJson(String str) =>
    ProfilePlanApi.fromJson(json.decode(str));

String profilePlanApiToJson(ProfilePlanApi data) => json.encode(data.toJson());

class ProfilePlanApi {
  ProfilePlanApi({
    required this.userPlans,
    required this.questions,
    required this.planDowngradeStatus,
  });

  UserPlans userPlans;
  int questions;
  PlanDowngradeStatus? planDowngradeStatus;

  factory ProfilePlanApi.fromJson(Map<String, dynamic> json) => ProfilePlanApi(
        userPlans: UserPlans.fromJson(json["user_plans"]),
        questions: json["questions"],
        planDowngradeStatus: json["plan_downgrade_status"] == null
            ? null
            : PlanDowngradeStatus.fromJson(json["plan_downgrade_status"]),
      );

  Map<String, dynamic> toJson() => {
        "user_plans": userPlans.toJson(),
        "questions": questions,
        "plan_downgrade_status": planDowngradeStatus!.toJson(),
      };
}

class PlanDowngradeStatus {
  PlanDowngradeStatus({
    required this.id,
    required this.userId,
    required this.planId,
    required this.name,
    required this.stripeId,
    required this.stripeStatus,
    required this.stripePlan,
    required this.quantity,
    this.trialEndsAt,
    this.endsAt,
    required this.upDownStatus,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.downStatus,
    required this.plan,
  });

  int id;
  String userId;
  String planId;
  String name;
  String? stripeId;
  String? stripeStatus;
  String? stripePlan;
  int? quantity;
  dynamic trialEndsAt;
  dynamic endsAt;
  int upDownStatus;
  int isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? downStatus;
  Plan? plan;

  factory PlanDowngradeStatus.fromJson(Map<String, dynamic> json) =>
      PlanDowngradeStatus(
        id: json["id"],
        userId: json["user_id"],
        planId: json["plan_id"],
        name: json["name"],
        stripeId: json["stripe_id"],
        stripeStatus: json["stripe_status"],
        stripePlan: json["stripe_plan"],
        quantity: json["quantity"],
        trialEndsAt: json["trial_ends_at"],
        endsAt: json["ends_at"],
        upDownStatus: json["up_down_status"],
        isActive: json["is_active"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        downStatus: json["down_status"],
        plan: Plan.fromJson(json["plan"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "plan_id": planId,
        "name": name,
        "stripe_id": stripeId,
        "stripe_status": stripeStatus,
        "stripe_plan": stripePlan,
        "quantity": quantity,
        "trial_ends_at": trialEndsAt,
        "ends_at": endsAt,
        "up_down_status": upDownStatus,
        "is_active": isActive,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "down_status": downStatus,
        "plan": plan!.toJson(),
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

class UserPlans {
  UserPlans({
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
    required this.randomName,
    required this.password,
    required this.profileImageUrl,
    required this.userProfile,
    required this.isProfilePrivate,
    required this.transactions,
    required this.subscriptionHistory,
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
  String randomName;
  String password;
  String profileImageUrl;
  String? userProfile;
  int isProfilePrivate;
  List<Transaction> transactions;
  List<PlanDowngradeStatus> subscriptionHistory;

  factory UserPlans.fromJson(Map<String, dynamic> json) => UserPlans(
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
        isProfilePrivate: json["is_profile_private"],
        transactions: List<Transaction>.from(
            json["transactions"].map((x) => Transaction.fromJson(x))),
        subscriptionHistory: List<PlanDowngradeStatus>.from(
            json["subscription_history"]
                .map((x) => PlanDowngradeStatus.fromJson(x))),
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
        "is_profile_private": isProfilePrivate,
        "transactions": List<dynamic>.from(transactions.map((x) => x.toJson())),
        "subscription_history":
            List<dynamic>.from(subscriptionHistory.map((x) => x.toJson())),
      };
}

class Transaction {
  Transaction({
    required this.id,
    required this.invoiceId,
    required this.planId,
    required this.userId,
    this.paymentTransactionId,
    required this.amount,
    required this.paymentStatusId,
    required this.isPaid,
    required this.isActive,
    required this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.paymentDate,
    required this.nextPaymentDate,
    required this.plan,
  });

  String id;
  String invoiceId;
  String planId;
  String userId;
  dynamic paymentTransactionId;
  String amount;
  String paymentStatusId;
  int isPaid;
  int isActive;
  String createdBy;
  dynamic updatedBy;
  DateTime createdAt;
  DateTime updatedAt;
  String paymentDate;
  String nextPaymentDate;
  Plan plan;

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json["id"],
        invoiceId: json["invoice_id"],
        planId: json["plan_id"],
        userId: json["user_id"],
        paymentTransactionId: json["payment_transaction_id"],
        amount: json["amount"],
        paymentStatusId: json["payment_status_id"],
        isPaid: json["is_paid"],
        isActive: json["is_active"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        paymentDate: json["payment_date"],
        nextPaymentDate: json["next_payment_date"],
        plan: Plan.fromJson(json["plan"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "invoice_id": invoiceId,
        "plan_id": planId,
        "user_id": userId,
        "payment_transaction_id": paymentTransactionId,
        "amount": amount,
        "payment_status_id": paymentStatusId,
        "is_paid": isPaid,
        "is_active": isActive,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "payment_date": paymentDate,
        "next_payment_date": nextPaymentDate,
        "plan": plan.toJson(),
      };
}
