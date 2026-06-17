class CommunityModel {
  final int id;
  final String name;
  final String location;
  final String longitude;
  final String latitude;

  CommunityModel({
    required this.id,
    required this.name,
    required this.location,
    required this.longitude,
    required this.latitude,
  });

  factory CommunityModel.fromJson(Map<String, dynamic> json){
    return CommunityModel(
      id: json['id'],
      name: json['name'] ?? '',
      location: json['location']?.toString() ?? '',
      longitude: json['longitude']?.toString() ?? '0.0',
      latitude: json['latitude']?.toString() ?? '0.0',
    );
  }
}
