// To parse this JSON data, do
//
//     final postQuestionImageResponse = postQuestionImageResponseFromJson(jsonString);

import 'dart:convert';

PostQuestionImageResponse postQuestionImageResponseFromJson(String str) => PostQuestionImageResponse.fromJson(json.decode(str));

String postQuestionImageResponseToJson(PostQuestionImageResponse data) => json.encode(data.toJson());

class PostQuestionImageResponse {
    PostQuestionImageResponse({
        required this.path,
        required this.name,
        required this.cdnImageUpload,
    });

    String path;
    String name;
    String cdnImageUpload;

    factory PostQuestionImageResponse.fromJson(Map<String, dynamic> json) => PostQuestionImageResponse(
        path: json["path"],
        name: json["name"],
        cdnImageUpload: json["cdn_image_upload"],
    );

    Map<String, dynamic> toJson() => {
        "path": path,
        "name": name,
        "cdn_image_upload": cdnImageUpload,
    };
}
