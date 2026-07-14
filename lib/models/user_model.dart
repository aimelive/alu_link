class UserModel {
  final String uid;
  final String name;
  final String email;
  final String role; // 'student', 'startup', or 'admin'
  final List<String> skills;
  final String? bio;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    this.skills = const [],
    this.bio,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'student',
      skills: List<String>.from(map['skills'] ?? []),
      bio: map['bio'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'skills': skills,
      'bio': bio,
    };
  }

  // Make a copy with some fields changed (used when updating skills)
  UserModel copyWith({List<String>? skills, String? bio}) {
    return UserModel(
      uid: uid,
      name: name,
      email: email,
      role: role,
      skills: skills ?? this.skills,
      bio: bio ?? this.bio,
    );
  }
}