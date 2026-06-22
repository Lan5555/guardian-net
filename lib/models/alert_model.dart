class AlertModel {
  final int? id;
  final String? subject;
  final String? title;
  final String? message;
  final String? location;
  final int communityId;
  final String reporter;
  final int reportedId;
  final bool isVerified;
  final DateTime? createdAt;

  AlertModel({
    this.id,
    this.subject,
    this.title,
    this.message,
    this.location,
    required this.communityId,
    required this.reporter,
    required this.isVerified,
    required this.reportedId,
    this.createdAt,
  });

  // Safe copying mechanism for modifying final fields
  AlertModel copyWith({
    int? id,
    String? subject,
    String? title,
    String? message,
    String? location,
    int? communityId,
    String? reporter,
    int? reportedId,
    bool? isVerified,
    DateTime? createdAt,
  }) {
    return AlertModel(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      title: title ?? this.title,
      message: message ?? this.message,
      location: location ?? this.location,
      communityId: communityId ?? this.communityId,
      reporter: reporter ?? this.reporter,
      reportedId: reportedId ?? this.reportedId,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }

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
      // Added fallback casting to prevent type errors from backend response variants
      isVerified: json['isVerified'] == true, 
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
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
      'isVerified': isVerified, // Fixed: Added missing property mapping
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
