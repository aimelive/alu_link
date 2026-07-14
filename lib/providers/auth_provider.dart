import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _user;
  bool _loading = false;
  String? _error;

  UserModel? get user => _user;
  bool get loading => _loading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;

  // SIGN UP
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    _setLoading(true);
    try {
      _user = await _authService.signUp(
        name: name,
        email: email,
        password: password,
        role: role,
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(_friendlyError(e.toString()));
      return false;
    }
  }

  // LOG IN
  Future<bool> logIn({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      _user = await _authService.logIn(email: email, password: password);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(_friendlyError(e.toString()));
      return false;
    }
  }

  // Turn raw Firebase errors into readable messages
  String _friendlyError(String raw) {
    if (raw.contains('email-already-in-use')) {
      return 'This email is already registered. Try logging in.';
    }
    if (raw.contains('invalid-credential') ||
        raw.contains('wrong-password') ||
        raw.contains('user-not-found')) {
      return 'Wrong email or password.';
    }
    if (raw.contains('network-request-failed')) {
      return 'Network error. Check your connection.';
    }
    return 'Something went wrong. Please try again.';
  }

  // ADD a skill and save to Firestore
  Future<void> addSkill(String skill) async {
    if (_user == null || skill.trim().isEmpty) return;
    final updated = List<String>.from(_user!.skills)..add(skill.trim());
    _user = _user!.copyWith(skills: updated);
    notifyListeners();
    await _authService.updateProfile(_user!);
  }

  // REMOVE a skill and save to Firestore
  Future<void> removeSkill(String skill) async {
    if (_user == null) return;
    final updated = List<String>.from(_user!.skills)..remove(skill);
    _user = _user!.copyWith(skills: updated);
    notifyListeners();
    await _authService.updateProfile(_user!);
  }

  // UPDATE the org's bio/description and save to Firestore
  Future<void> updateBio(String bio) async {
    if (_user == null) return;
    _user = _user!.copyWith(bio: bio);
    notifyListeners();
    await _authService.updateProfile(_user!);
  }

  // LOG OUT
  Future<void> logOut() async {
    await _authService.logOut();
    _user = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _loading = value;
    _error = null;
    notifyListeners();
  }

  void _setError(String message) {
    _error = message;
    _loading = false;
    notifyListeners();
  }
}