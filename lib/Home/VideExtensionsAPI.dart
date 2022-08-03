// To parse this JSON data, do
//
//     final videoExtensionsApi = videoExtensionsApiFromJson(jsonString);

import 'dart:convert';

VideoExtensionsApi videoExtensionsApiFromJson(String str) => VideoExtensionsApi.fromJson(json.decode(str));

String videoExtensionsApiToJson(VideoExtensionsApi data) => json.encode(data.toJson());

class VideoExtensionsApi {
    VideoExtensionsApi({
        required this.code,
        required this.message,
        required this.count,
        required this.data,
    });

    String code;
    String message;
    String count;
    Data data;

    factory VideoExtensionsApi.fromJson(Map<String, dynamic> json) => VideoExtensionsApi(
        code: json["code"],
        message: json["message"],
        count: json["count"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "count": count,
        "data": data.toJson(),
    };
}

class Data {
    Data({
        required this.imageExtensions,
        required this.videoExtensions,
    });

    List<String> imageExtensions;
    List<String> videoExtensions;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        imageExtensions: List<String>.from(json["ImageExtensions"].map((x) => x)),
        videoExtensions: List<String>.from(json["VideoExtensions"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "ImageExtensions": List<dynamic>.from(imageExtensions.map((x) => x)),
        "VideoExtensions": List<dynamic>.from(videoExtensions.map((x) => x)),
    };
}
