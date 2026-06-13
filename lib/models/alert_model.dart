// lib/models/alert_model.dart
class AlertModel {
  final String id;
  final String type;
  final String description;
  final String timestamp;
  final String location;
  final bool verified;
  final int trustVotes;
  final String reporter;

  AlertModel({
    required this.id,
    required this.type,
    required this.description,
    required this.timestamp,
    required this.location,
    required this.verified,
    required this.trustVotes,
    required this.reporter,
  });

  AlertModel copyWith({
    String? id,
    String? type,
    String? description,
    String? timestamp,
    String? location,
    bool? verified,
    int? trustVotes,
    String? reporter,
  }) {
    return AlertModel(
      id: id ?? this.id,
      type: type ?? this.type,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
      location: location ?? this.location,
      verified: verified ?? this.verified,
      trustVotes: trustVotes ?? this.trustVotes,
      reporter: reporter ?? this.reporter,
    );
  }
}