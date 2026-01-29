import 'dart:convert';

class LoginsliderModel {
    bool? success;
    String? message;
    int? statusCode;
    Data? data;

    LoginsliderModel({
        this.success,
        this.message,
        this.statusCode,
        this.data,
    });

    factory LoginsliderModel.fromRawJson(String str) => LoginsliderModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory LoginsliderModel.fromJson(Map<String, dynamic> json) => LoginsliderModel(
        success: json["success"],
        message: json["message"],
        statusCode: json["statusCode"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "statusCode": statusCode,
        "data": data?.toJson(),
    };
}

class Data {
    String? id;
    String? key;
    int? v;
    DateTime? createdAt;
    List<String>? images;
    String? type;
    DateTime? updatedAt;

    Data({
        this.id,
        this.key,
        this.v,
        this.createdAt,
        this.images,
        this.type,
        this.updatedAt,
    });

    factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["_id"],
        key: json["key"],
        v: json["__v"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
        type: json["type"],
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "key": key,
        "__v": v,
        "createdAt": createdAt?.toIso8601String(),
        "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "type": type,
        "updatedAt": updatedAt?.toIso8601String(),
    };
}
