import 'dart:convert';

class ProfileModel {
    bool? success;
    String? message;
    int? statusCode;
    ProfileModelData? data;

    ProfileModel({
        this.success,
        this.message,
        this.statusCode,
        this.data,
    });

    factory ProfileModel.fromRawJson(String str) => ProfileModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        success: json["success"],
        message: json["message"],
        statusCode: json["statusCode"],
        data: json["data"] == null ? null : ProfileModelData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "statusCode": statusCode,
        "data": data?.toJson(),
    };
}

class ProfileModelData {
    OnlineStatus? onlineStatus;
    bool? isSubscribed;
    String? id;
    String? name;
    String? role;
    String? email;
    String? image;
    String? status;
    bool? verified;
    bool? isDeleted;
    String? stripeCustomerId;
    List<dynamic>? pageAccess;
    DateTime? createdAt;
    DateTime? updatedAt;
    int? v;

    ProfileModelData({
        this.onlineStatus,
        this.isSubscribed,
        this.id,
        this.name,
        this.role,
        this.email,
        this.image,
        this.status,
        this.verified,
        this.isDeleted,
        this.stripeCustomerId,
        this.pageAccess,
        this.createdAt,
        this.updatedAt,
        this.v,
    });

    factory ProfileModelData.fromRawJson(String str) => ProfileModelData.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ProfileModelData.fromJson(Map<String, dynamic> json) => ProfileModelData(
        onlineStatus: json["onlineStatus"] == null ? null : OnlineStatus.fromJson(json["onlineStatus"]),
        isSubscribed: json["isSubscribed"],
        id: json["_id"],
        name: json["name"],
        role: json["role"],
        email: json["email"],
        image: json["image"],
        status: json["status"],
        verified: json["verified"],
        isDeleted: json["isDeleted"],
        stripeCustomerId: json["stripeCustomerId"],
        pageAccess: json["pageAccess"] == null ? [] : List<dynamic>.from(json["pageAccess"]!.map((x) => x)),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "onlineStatus": onlineStatus?.toJson(),
        "isSubscribed": isSubscribed,
        "_id": id,
        "name": name,
        "role": role,
        "email": email,
        "image": image,
        "status": status,
        "verified": verified,
        "isDeleted": isDeleted,
        "stripeCustomerId": stripeCustomerId,
        "pageAccess": pageAccess == null ? [] : List<dynamic>.from(pageAccess!.map((x) => x)),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
    };
}

class OnlineStatus {
    bool? isOnline;
    DateTime? lastSeen;
    DateTime? lastHeartbeat;

    OnlineStatus({
        this.isOnline,
        this.lastSeen,
        this.lastHeartbeat,
    });

    factory OnlineStatus.fromRawJson(String str) => OnlineStatus.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory OnlineStatus.fromJson(Map<String, dynamic> json) => OnlineStatus(
        isOnline: json["isOnline"],
        lastSeen: json["lastSeen"] == null ? null : DateTime.parse(json["lastSeen"]),
        lastHeartbeat: json["lastHeartbeat"] == null ? null : DateTime.parse(json["lastHeartbeat"]),
    );

    Map<String, dynamic> toJson() => {
        "isOnline": isOnline,
        "lastSeen": lastSeen?.toIso8601String(),
        "lastHeartbeat": lastHeartbeat?.toIso8601String(),
    };
}
