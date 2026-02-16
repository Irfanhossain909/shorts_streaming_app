class SubscriptionModel {
  bool? success;
  String? message;
  int? statusCode;
  List<SubscriptionData>? data;
  Meta? meta;

  SubscriptionModel({
    this.success,
    this.message,
    this.statusCode,
    this.data,
    this.meta,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      success: json['success'],
      message: json['message'],
      statusCode: json['statusCode'],
      data: json['data'] != null
          ? (json['data'] as List)
                .map((item) => SubscriptionData.fromJson(item))
                .toList()
          : null,
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'statusCode': statusCode,
      'data': data?.map((item) => item.toJson()).toList(),
      'meta': meta?.toJson(),
    };
  }
}

class SubscriptionData {
  String? id;
  String? name;
  String? description;
  double? price;
  String? duration;
  String? paymentType;
  bool? isGoogle;
  String? googleProductId;
  String? appleProductId;
  String? status;
  String? provider;
  bool? isDeleted;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  SubscriptionData({
    this.id,
    this.name,
    this.description,
    this.price,
    this.duration,
    this.paymentType,
    this.isGoogle,
    this.googleProductId,
    this.appleProductId,
    this.status,
    this.provider,
    this.isDeleted,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory SubscriptionData.fromJson(Map<String, dynamic> json) {
    return SubscriptionData(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      price: json['price']?.toDouble(),
      duration: json['duration'],
      paymentType: json['paymentType'],
      isGoogle: json['isGoogle'],
      googleProductId: json['googleProductId'],
      appleProductId: json['appleProductId'],
      status: json['status'],
      provider: json['provider'],
      isDeleted: json['isDeleted'],
      deletedAt: json['deletedAt'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'price': price,
      'duration': duration,
      'paymentType': paymentType,
      'isGoogle': isGoogle,
      'googleProductId': googleProductId,
      'appleProductId': appleProductId,
      'status': status,
      'provider': provider,
      'isDeleted': isDeleted,
      'deletedAt': deletedAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class Meta {
  int? page;
  int? limit;
  int? total;
  int? totalPage;

  Meta({this.page, this.limit, this.total, this.totalPage});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      page: json['page'],
      limit: json['limit'],
      total: json['total'],
      totalPage: json['totalPage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'total': total,
      'totalPage': totalPage,
    };
  }
}
