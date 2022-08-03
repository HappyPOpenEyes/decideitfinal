// To parse this JSON data, do
//
//     final planData = planDataFromJson(jsonString);

import 'dart:convert';

PlanData planDataFromJson(String str) => PlanData.fromJson(json.decode(str));

String planDataToJson(PlanData data) => json.encode(data.toJson());

class PlanData {
    PlanData({
        required this.code,
        required this.message,
        required this.count,
        required this.data,
    });

    String code;
    String message;
    int count;
    List<Datum> data;

    factory PlanData.fromJson(Map<String, dynamic> json) => PlanData(
        code: json["code"],
        message: json["message"],
        count: json["count"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "count": count,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
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
        required this.subscriptionsCount,
    });

    String id;
    String? stripeProduct;
    String? stripePlan;
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
    int subscriptionsCount;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        stripeProduct: json["stripe_product"],
        stripePlan: json["stripe_plan"],
        name: json["name"],
        amount: json["amount"],
        questionLimitation: json["question_limitation"],
        communityQuestionLimitation: json["community_question_limitation"],
        numberOfDays: json["number_of_days"],
        communityQuestionNumberOfDays: json["community_question_number_of_days"],
        numberOfResponses: json["number_of_responses"],
        communityQuestionNumberOfResponses: json["community_question_number_of_responses"],
        questionValidity: json["question_validity"],
        communityQuestionValidity: json["community_question_validity"],
        numberOfInvitations: json["number_of_invitations"],
        communityQuestionNumberOfInvitations: json["community_question_number_of_invitations"],
        numberOfCommunities: json["number_of_communities"],
        communityQuestionNumberOfCommunities: json["community_question_number_of_communities"],
        description: json["description"],
        isActive: json["is_active"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        subscriptionsCount: json["subscriptions_count"],
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
        "community_question_number_of_responses": communityQuestionNumberOfResponses,
        "question_validity": questionValidity,
        "community_question_validity": communityQuestionValidity,
        "number_of_invitations": numberOfInvitations,
        "community_question_number_of_invitations": communityQuestionNumberOfInvitations,
        "number_of_communities": numberOfCommunities,
        "community_question_number_of_communities": communityQuestionNumberOfCommunities,
        "description": description,
        "is_active": isActive,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "subscriptions_count": subscriptionsCount,
    };
}
