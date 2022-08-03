// To parse this JSON data, do
//
//     final imageUploadResponse = imageUploadResponseFromJson(jsonString);

import 'dart:convert';

ImageUploadResponse imageUploadResponseFromJson(String str) => ImageUploadResponse.fromJson(json.decode(str));

String imageUploadResponseToJson(ImageUploadResponse data) => json.encode(data.toJson());

class ImageUploadResponse {
    ImageUploadResponse({
        required this.cdnImageUpload,
        required this.name,
        required this.path,
    });

    String cdnImageUpload;
    String name;
    String path;

    factory ImageUploadResponse.fromJson(Map<String, dynamic> json) => ImageUploadResponse(
        cdnImageUpload: json["cdn_image_upload"],
        name: json["name"],
        path: json["path"],
    );

    Map<String, dynamic> toJson() => {
        "cdn_image_upload": cdnImageUpload,
        "name": name,
        "path": path,
    };
}
