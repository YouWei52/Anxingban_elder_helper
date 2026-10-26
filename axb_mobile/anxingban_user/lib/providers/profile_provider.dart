import 'package:flutter/material.dart';

import '../../data/models/profile.dart';
import '../../data/repositories/profile_repository.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileRepository _profileRepository;

  List<Profile> _profiles = [];
  Profile? _selectedProfile;
  bool _isLoading = false;
  String? _error;

  ProfileProvider(this._profileRepository);

  List<Profile> get profiles => _profiles;
  Profile? get selectedProfile => _selectedProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProfiles() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _profiles = await _profileRepository.getProfiles();
      if (_profiles.isNotEmpty && _selectedProfile == null) {
        _selectedProfile = _profiles.first;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectProfile(Profile profile) {
    _selectedProfile = profile;
    notifyListeners();
  }

  Future<bool> createProfile({
    required int elderId,
    required int userId,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final profile = await _profileRepository.createProfile(
        elderId: elderId,
        userId: userId,
      );
      _profiles.add(profile);
      _selectedProfile = profile;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProfile(int profileId) async {
    try {
      await _profileRepository.deleteProfile(profileId);
      _profiles.removeWhere((p) => p.id == profileId);
      if (_selectedProfile?.id == profileId) {
        _selectedProfile = _profiles.isNotEmpty ? _profiles.first : null;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
