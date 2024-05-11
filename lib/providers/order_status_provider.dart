import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../helpers/shared_preferences_helper.dart';

class OrderStatusProvider with ChangeNotifier {
  String? status;
  String? errorMessage;
  final ApiService _apiService = ApiService();

  Future<void> fetchStatus() async {
    int? userId = await SharedPreferencesHelper.getUserId();
    if (userId != null) {
      try {
        final response = await _apiService.getStatus(userId);
        status = response['status']['status'];
        notifyListeners();
      } catch (e) {
        errorMessage = "Failed to fetch status: ${e.toString()}";
        notifyListeners();
      }
    }
  }

  Future<void> updateStatus(String endpoint) async {
    int? userId = await SharedPreferencesHelper.getUserId();
    if (userId != null) {
      try {
        await _apiService.post(endpoint, {},
            token: await SharedPreferencesHelper.getAccessToken());
        await fetchStatus();
      } catch (e) {
        errorMessage = "Failed to update status: ${e.toString()}";
        notifyListeners();
      }
    }
  }

  Future<void> pembayaran() async {
    int? userId = await SharedPreferencesHelper.getUserId();
    if (userId != null) {
      try {
        await _apiService.post('/pembayaran/$userId', {},
            token: await SharedPreferencesHelper.getAccessToken());
        await fetchStatus();
      } catch (e) {
        errorMessage = "Failed to make payment: ${e.toString()}";
        notifyListeners();
      }
    }
  }
}
