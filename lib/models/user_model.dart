class UserModel {
  final int id;
  final String? name;
  final String email;
  final int? communityId;
  final int? reputationCount;

  UserModel({
    required this.id,
    this.name,
    required this.email,
    this.communityId,
    this.reputationCount
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String?,
      email: json['email'] as String,
      communityId: json['community_id'] as int?,
      reputationCount: json['reputation_count'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'community_id': communityId,
      'reputation_count': reputationCount,
    };
  }
}
