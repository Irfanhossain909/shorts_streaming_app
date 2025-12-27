class FaqsResponseModel {
  final bool success;
  final String message;
  final int statusCode;
  final List<FaqsModel>? data;

  FaqsResponseModel({
    required this.success,
    required this.message,
    required this.statusCode,
    required this.data,
  });

  factory FaqsResponseModel.fromJson(Map<String, dynamic> json) {
    return FaqsResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? 0,
      data: json['data']?.map((e) => FaqsModel.fromJson(e))?.toList() ?? [],
    );
  }
}

class FaqsModel {
  final String? id;
  final String? question;
  final String? answer;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? version;

  FaqsModel({
    this.id,
    this.question,
    this.answer,
    this.createdAt,
    this.updatedAt,
    this.version,
  });

  factory FaqsModel.fromJson(Map<String, dynamic> json) {
    return FaqsModel(
      id: json['_id'] ?? '',
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      version: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'question': question,
      'answer': answer,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': version,
    };
  }
}
