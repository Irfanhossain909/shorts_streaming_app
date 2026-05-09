import 'dart:io' show Platform;

/// Normalizes API `provider` (e.g. google vs apple) when both store IDs can match.
_StoreKind _parseSubscriptionProvider(String? p) {
  if (p == null || p.trim().isEmpty) return _StoreKind.unknown;
  final s = p.toLowerCase().trim();
  if (s.contains('google') || s == 'android' || s.contains('play store')) {
    return _StoreKind.google;
  }
  if (s.contains('apple') || s == 'ios' || s.contains('app_store')) {
    return _StoreKind.apple;
  }
  return _StoreKind.unknown;
}

enum _StoreKind { google, apple, unknown }

extension SubscriptionDataStoreProductId on SubscriptionData {
  /// Store SKU for this row: follows `provider`, then [isGoogle], then OS fallback.
  String? get storeProductId {
    switch (_parseSubscriptionProvider(provider)) {
      case _StoreKind.google:
        return googleProductId;
      case _StoreKind.apple:
        return appleProductId;
      case _StoreKind.unknown:
        if (isGoogle == true) return googleProductId;
        if (isGoogle == false) return appleProductId;
        return Platform.isIOS ? appleProductId : googleProductId;
    }
  }

  /// True when this plan row belongs to the store (Play vs App Store) on this device.
  bool get matchesRunningAppStore {
    switch (_parseSubscriptionProvider(provider)) {
      case _StoreKind.google:
        return Platform.isAndroid;
      case _StoreKind.apple:
        return Platform.isIOS;
      case _StoreKind.unknown:
        if (isGoogle == true) return Platform.isAndroid;
        if (isGoogle == false) return Platform.isIOS;
        final id = Platform.isIOS ? appleProductId : googleProductId;
        return id != null && id.isNotEmpty;
    }
  }
}

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
