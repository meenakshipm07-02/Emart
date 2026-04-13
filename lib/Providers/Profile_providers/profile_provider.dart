import 'package:flutter/foundation.dart';
import 'package:grocery_app/API/main_api.dart';
import 'package:grocery_app/Models/Profile_Model/profile_model.dart';

class ProfileProvider with ChangeNotifier {
  final Main_Apis _apiService = Main_Apis();

  ProfileModel? _profileModel;
  bool _isLoading = false;
  String? _errorMessage;

  ProfileModel? get profileModel => _profileModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.getprofile();
      _profileModel = ProfileModel.fromJson(response);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
