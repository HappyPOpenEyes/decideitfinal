// To parse this JSON data, do
//
//     final draftQuestionApi = draftQuestionApiFromJson(jsonString);

import 'dart:convert';

DraftQuestionApi draftQuestionApiFromJson(String str) =>
    DraftQuestionApi.fromJson(json.decode(str));

String draftQuestionApiToJson(DraftQuestionApi data) =>
    json.encode(data.toJson());

class DraftQuestionApi {
  DraftQuestionApi({
    required this.code,
    required this.message,
    required this.count,
    required this.data,
  });

  int code;
  String message;
  String count;
  DatumDraft data;

  factory DraftQuestionApi.fromJson(Map<String, dynamic> json) =>
      DraftQuestionApi(
        code: json["code"],
        message: json["message"],
        count: json["count"],
        data: DatumDraft.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "count": count,
        "data": data.toJson(),
      };
}

class DatumDraft {
  DatumDraft({
    required this.id,
    required this.userId,
    required this.questionTypeId,
    required this.questionText,
    this.imageVideoUrl,
    required this.answerOnlyToMe,
    required this.inviteesOnlyToMe,
    required this.sendAnonymously,
    required this.anonymousResponse,
    required this.inviteeCanInviteOthers,
    required this.tinyUrl,
    required this.views,
    required this.weightageAverage,
    required this.expiredOn,
    required this.questionStatusId,
    required this.isActive,
    required this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.invitee,
    required this.community,
    required this.option,
  });

  String id;
  String userId;
  String questionTypeId;
  String questionText;
  dynamic imageVideoUrl;
  String answerOnlyToMe;
  String inviteesOnlyToMe;
  String sendAnonymously;
  String anonymousResponse;
  String inviteeCanInviteOthers;
  String tinyUrl;
  int views;
  int weightageAverage;
  DateTime expiredOn;
  String questionStatusId;
  int isActive;
  String createdBy;
  dynamic updatedBy;
  DateTime createdAt;
  DateTime updatedAt;
  List<dynamic> invitee;
  List<Communities> community;
  List<Options> option;

  factory DatumDraft.fromJson(Map<String, dynamic> json) => DatumDraft(
      id: json["id"],
      userId: json["user_id"],
      questionTypeId: json["question_type_id"],
      questionText: json["question_text"],
      imageVideoUrl: json["image_video_url"],
      answerOnlyToMe: json["answer_only_to_me"],
      inviteesOnlyToMe: json["invitees_only_to_me"],
      sendAnonymously: json["send_anonymously"],
      anonymousResponse: json["anonymous_response"],
      inviteeCanInviteOthers: json["invitee_can_invite_others"],
      tinyUrl: json["tiny_url"],
      views: json["views"],
      weightageAverage: json["weightage_average"],
      expiredOn: DateTime.parse(json["ExpiredOn"]),
      questionStatusId: json["question_status_id"],
      isActive: json["is_active"],
      createdBy: json["created_by"],
      updatedBy: json["updated_by"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      invitee: List<dynamic>.from(json["invitee"].map((x) => x)),
      community: List<Communities>.from(
          json["community"].map((x) => Communities.fromJson(x))),
      option:
          List<Options>.from(json["option"].map((x) => Options.fromJson(x))));

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "question_type_id": questionTypeId,
        "question_text": questionText,
        "image_video_url": imageVideoUrl,
        "answer_only_to_me": answerOnlyToMe,
        "invitees_only_to_me": inviteesOnlyToMe,
        "send_anonymously": sendAnonymously,
        "anonymous_response": anonymousResponse,
        "invitee_can_invite_others": inviteeCanInviteOthers,
        "tiny_url": tinyUrl,
        "views": views,
        "weightage_average": weightageAverage,
        "ExpiredOn": expiredOn.toIso8601String(),
        "question_status_id": questionStatusId,
        "is_active": isActive,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "invitee": List<dynamic>.from(invitee.map((x) => x)),
        "community": List<dynamic>.from(community.map((x) => x.toJson())),
        "option": List<dynamic>.from(option.map((x) => x)),
      };
}

class Communities {
  Communities({
    required this.id,
    required this.questionId,
    required this.communityId,
    required this.isActive,
    required this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String questionId;
  String communityId;
  int isActive;
  String createdBy;
  dynamic updatedBy;
  DateTime createdAt;
  DateTime updatedAt;

  factory Communities.fromJson(Map<String, dynamic> json) => Communities(
        id: json["id"],
        questionId: json["question_id"],
        communityId: json["community_id"],
        isActive: json["is_active"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question_id": questionId,
        "community_id": communityId,
        "is_active": isActive,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Options {
  Options({
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

  factory Options.fromJson(Map<String, dynamic> json) => Options(
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
