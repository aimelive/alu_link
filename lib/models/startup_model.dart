class StartupModel {
  final String id;
  final String ownerId; 
  final String name;
  final String description;
  final bool verified; 
  final String? logoUrl;

  StartupModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.description,
    this.verified = false,
    this.logoUrl,
  });

  factory StartupModel.fromMap(Map<String, dynamic> map, String id) {
    return StartupModel(
      id: id,
      ownerId: map['ownerId'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      verified: map['verified'] ?? false,
      logoUrl: map['logoUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'name': name,
      'description': description,
      'verified': verified,
      'logoUrl': logoUrl,
    };
  }
}