import 'package:flutter/material.dart';
import '../helpers/shared_preferences_helper.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  String? errorMessage;
  final ApiService _apiService = ApiService();

  Future<void> login(String username, String password) async {
    try {
      errorMessage = null;
      final response = await _apiService.post('/login', {
        'username': username,
        'password': password,
      });

      if (response.containsKey('access_token') &&
          response.containsKey('user_id')) {
        final String token = response['access_token'];
        final int userId = response['user_id'];

        // Simpan token dan user_id ke SharedPreferences
        await SharedPreferencesHelper.saveAccessToken(token);
        await SharedPreferencesHelper.saveUserId(userId);

        // Navigate to the main screen
        notifyListeners();
      } else {
        throw Exception(response['detail']);
      }
    } catch (e) {
      errorMessage = " ${e.toString()}";
      notifyListeners();
    }
  }
}
