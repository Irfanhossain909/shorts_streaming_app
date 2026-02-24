import 'dart:convert';

class NotificationModel {
  bool? success;
  String? message;
  int? statusCode;
  NotificationModelData? data;
  Meta? meta;

  NotificationModel({
    this.success,
    this.message,
    this.statusCode,
    this.data,
    this.meta,
  });

  factory NotificationModel.fromRawJson(String str) =>
      NotificationModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        success: json["success"],
        message: json["message"],
        statusCode: json["statusCode"],
        data: json["data"] == null ? null : NotificationModelData.fromJson(json["data"]),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "statusCode": statusCode,
    "data": data?.toJson(),
    "meta": meta?.toJson(),
  };
}

class NotificationModelData {
  List<Result>? result;
  int? unreadCount;

  NotificationModelData({this.result, this.unreadCount});

  factory NotificationModelData.fromRawJson(String str) => NotificationModelData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationModelData.fromJson(Map<String, dynamic> json) => NotificationModelData(
    result: json["result"] == null
        ? []
        : List<Result>.from(json["result"]!.map((x) => Result.fromJson(x))),
    unreadCount: json["unreadCount"],
  );

  Map<String, dynamic> toJson() => {
    "result": result == null
        ? []
        : List<dynamic>.from(result!.map((x) => x.toJson())),
    "unreadCount": unreadCount,
  };
}

class Result {
  String? id;
  String? title;
  String? message;
  bool? read;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;

  Result({
    this.id,
    this.title,
    this.message,
    this.read,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["_id"],
    title: json["title"],
    message: json["message"],
    
    read: json["read"],
    type: json["type"],
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "message": message,
    "read": read,
    "type": type,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}

class Receiver {
  String? id;
  String? name;
  String? email;
  String? image;

  Receiver({this.id, this.name, this.email, this.image});

  factory Receiver.fromRawJson(String str) =>
      Receiver.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Receiver.fromJson(Map<String, dynamic> json) => Receiver(
    id: json["_id"],
    name: json["name"],
    email: json["email"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "email": email,
    "image": image,
  };
}

class Meta {
  int? page;
  int? limit;
  int? total;
  int? totalPage;

  Meta({this.page, this.limit, this.total, this.totalPage});

  factory Meta.fromRawJson(String str) => Meta.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    page: json["page"],
    limit: json["limit"],
    total: json["total"],
    totalPage: json["totalPage"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "limit": limit,
    "total": total,
    "totalPage": totalPage,
  };
}
