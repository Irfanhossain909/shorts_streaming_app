class ReminderResponse {
  final bool success;
  final String message;
  final int statusCode;
  final List<Reminder> data;
  final Meta meta;

  ReminderResponse({
    required this.success,
    required this.message,
    required this.statusCode,
    required this.data,
    required this.meta,
  });

  factory ReminderResponse.fromJson(Map<String, dynamic> json) {
    return ReminderResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => Reminder.fromJson(e))
          .toList(),
      meta: Meta.fromJson(json['meta'] ?? {}),
    );
  }
}

class Reminder {
  final String id;
  final String userId;
  final String? thumbnail;
  final String name;
  final String description;
  final DateTime reminderTime;
  final String status;

  Reminder({
    required this.id,
    required this.userId,
    this.thumbnail,
    required this.name,
    required this.description,
    required this.reminderTime,
    required this.status,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      thumbnail: json['thumbnail'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      reminderTime:
          DateTime.tryParse(json['reminderTime'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? '',
    );
  }
}

class Meta {
  final int page;
  final int limit;
  final int total;
  final int totalPage;

  Meta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      page: json['page'] ?? 0,
      limit: json['limit'] ?? 0,
      total: json['total'] ?? 0,
      totalPage: json['totalPage'] ?? 0,
    );
  }
}
