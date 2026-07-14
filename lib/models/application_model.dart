class ApplicationModel {
  final String id;
  final String opportunityId;
  final String opportunityTitle; // denormalized for display
  final String studentId;
  final String studentName; // denormalized for display
  final int matchScore; // snapshotted at submission time
  final String status; // 'applied', 'shortlisted', 'interview', 'accepted', 'rejected'
  final DateTime appliedAt;

  ApplicationModel({
    required this.id,
    required this.opportunityId,
    required this.opportunityTitle,
    required this.studentId,
    required this.studentName,
    required this.matchScore,
    this.status = 'applied',
    required this.appliedAt,
  });

  factory ApplicationModel.fromMap(Map<String, dynamic> map, String id) {
    return ApplicationModel(
      id: id,
      opportunityId: map['opportunityId'] ?? '',
      opportunityTitle: map['opportunityTitle'] ?? '',
      studentId: map['studentId'] ?? '',
      studentName: map['studentName'] ?? '',
      matchScore: map['matchScore'] ?? 0,
      status: map['status'] ?? 'applied',
      appliedAt: map['appliedAt'] != null
          ? (map['appliedAt'] as dynamic).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'opportunityId': opportunityId,
      'opportunityTitle': opportunityTitle,
      'studentId': studentId,
      'studentName': studentName,
      'matchScore': matchScore,
      'status': status,
      'appliedAt': appliedAt,
    };
  }
}