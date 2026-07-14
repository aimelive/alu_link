import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Current signed-in user, or null
  User? get currentUser => _auth.currentUser;

  // Stream that fires whenever login state changes
  Stream<User?> get authState => _auth.authStateChanges();

  // SIGN UP: create the auth account, then save their profile to Firestore
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    final user = UserModel(
      uid: cred.user!.uid,
      name: name.trim(),
      email: email.trim(),
      role: role,
    );

    await _db.collection('users').doc(user.uid).set(user.toMap());
    return user;
  }

  // LOG IN: sign in, then fetch their profile from Firestore
  Future<UserModel> logIn({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    final doc = await _db.collection('users').doc(cred.user!.uid).get();
    return UserModel.fromMap(doc.data()!, cred.user!.uid);
  }

  // UPDATE the user's profile (skills, bio) in Firestore
  Future<void> updateProfile(UserModel user) async {
    await _db.collection('users').doc(user.uid).update(user.toMap());
  }

  // LOG OUT
  Future<void> logOut() async {
    await _auth.signOut();
  }
}