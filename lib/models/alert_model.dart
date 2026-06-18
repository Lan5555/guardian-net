class AlertModel {
  final int? id;
  final String? subject;
  final String? title;
  final String? message;
  final String? location;
  final int communityId;
  final String reporter;
  final int reportedId;
  final DateTime? createdAt;

  AlertModel({
    this.id,
    this.subject,
    this.title,
    this.message,
    this.location,
    required this.communityId,
    required this.reporter,
    required this.reportedId,
    this.createdAt,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'] as int?,
      subject: json['subject'] as String?,
      title: json['title'] as String?,
      message: json['message'] as String?,
      location: json['location'] as String?,
      communityId: (json['community_id'] ?? 0) as int,
      reporter: (json['reporter'] ?? 'Anonymous') as String,
      reportedId: (json['reported_id'] ?? 0) as int,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'title': title,
      'message': message,
      'location': location,
      'community_id': communityId,
      'reporter': reporter,
      'reported_id': reportedId,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
