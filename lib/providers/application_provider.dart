import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/application_model.dart';

class ApplicationProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // A student's own applications (to track their status)
  Stream<List<ApplicationModel>> byStudentStream(String studentId) {
    return _db
        .collection('applications')
        .where('studentId', isEqualTo: studentId)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => ApplicationModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // All applications to one opportunity (what the org reviews),
  // sorted by match score highest-first
  Stream<List<ApplicationModel>> byOpportunityStream(String opportunityId) {
    return _db
        .collection('applications')
        .where('opportunityId', isEqualTo: opportunityId)
        .snapshots()
        .map((snap) {
      final list = snap.docs
          .map((doc) => ApplicationModel.fromMap(doc.data(), doc.id))
          .toList();
      list.sort((a, b) => b.matchScore.compareTo(a.matchScore));
      return list;
    });
  }

  // Student applies to an opportunity
  Future<void> apply(ApplicationModel application) async {
    await _db.collection('applications').add(application.toMap());
  }

  // Org moves an applicant through the pipeline
  Future<void> updateStatus(String applicationId, String newStatus) async {
    await _db
        .collection('applications')
        .doc(applicationId)
        .update({'status': newStatus});
  }
}