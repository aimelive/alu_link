import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/startup_model.dart';

class StartupProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Live stream of all startups
  Stream<List<StartupModel>> get startupsStream {
    return _db.collection('startups').snapshots().map(
          (snap) => snap.docs
              .map((doc) => StartupModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  // Create a new startup profile
  Future<void> createStartup(StartupModel startup) async {
    await _db.collection('startups').add(startup.toMap());
  }

  // Admin flips verified to true
  Future<void> verifyStartup(String startupId) async {
    await _db.collection('startups').doc(startupId).update({'verified': true});
  }

  // Get one student's startup (if they own one)
  Stream<List<StartupModel>> myStartupStream(String ownerId) {
    return _db
        .collection('startups')
        .where('ownerId', isEqualTo: ownerId)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => StartupModel.fromMap(doc.data(), doc.id))
            .toList());
  }
}