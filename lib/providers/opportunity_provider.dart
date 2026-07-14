import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/opportunity_model.dart';

class OpportunityProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<OpportunityModel>> get openOpportunitiesStream {
    return _db
        .collection('opportunities')
        .where('open', isEqualTo: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => OpportunityModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Stream<List<OpportunityModel>> byStartupStream(String startupId) {
    return _db
        .collection('opportunities')
        .where('startupId', isEqualTo: startupId)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => OpportunityModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> postOpportunity(OpportunityModel opportunity) async {
    await _db.collection('opportunities').add(opportunity.toMap());
  }

  Future<void> closeOpportunity(String opportunityId) async {
    await _db
        .collection('opportunities')
        .doc(opportunityId)
        .update({'open': false});
  }

  // DELETE an opportunity permanently
  Future<void> deleteOpportunity(String opportunityId) async {
    await _db.collection('opportunities').doc(opportunityId).delete();
  }
}