class OpportunityModel {
  final String id;
  final String startupId;
  final String startupName; // denormalized for quick display
  final String title;
  final String description;
  final String category; // ALU department/branch
  final List<String> requiredSkills;
  final bool open; // false once filled/closed

  OpportunityModel({
    required this.id,
    required this.startupId,
    required this.startupName,
    required this.title,
    required this.description,
    this.category = 'Other',
    this.requiredSkills = const [],
    this.open = true,
  });

  factory OpportunityModel.fromMap(Map<String, dynamic> map, String id) {
    return OpportunityModel(
      id: id,
      startupId: map['startupId'] ?? '',
      startupName: map['startupName'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? 'Other',
      requiredSkills: List<String>.from(map['requiredSkills'] ?? []),
      open: map['open'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'startupId': startupId,
      'startupName': startupName,
      'title': title,
      'description': description,
      'category': category,
      'requiredSkills': requiredSkills,
      'open': open,
    };
  }
}