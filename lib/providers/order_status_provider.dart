import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../providers/cart_provider.dart';
import '../helpers/shared_preferences_helper.dart';

class OrderStatusProvider with ChangeNotifier {
  String? status;
  String? timestamp;
  String? errorMessage;
  final ApiService _apiService = ApiService();

  Future<void> fetchStatus() async {
    int? userId = await SharedPreferencesHelper.getUserId();
    if (userId != null) {
      try {
        final response = await _apiService.getStatus(userId);
        status = response['status']['status'];
        timestamp = response['status']['timestamp'];
        notifyListeners();
      } catch (e) {
        errorMessage = "Gagal fetch status: ${e.toString()}";
        notifyListeners();
      }
    }
  }

  Future<void> updateStatus(String endpoint) async {
    int? userId = await SharedPreferencesHelper.getUserId();
    if (userId != null) {
      try {
        final response = await _apiService.post(endpoint, {},
            token: await SharedPreferencesHelper.getAccessToken());
        if (response['status'] == 'pesanan_diantar' ||
            response['status'] == 'pesanan_selesai') {
          timestamp = response['timestamp'];
        }
        await fetchStatus();
      } catch (e) {
        errorMessage = "Gagal update status: ${e.toString()}";
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
        errorMessage = "Gagal pembayaran: ${e.toString()}";
        notifyListeners();
      }
    }
  }

  Future<void> clearCart(CartProvider cartProvider) async {
    cartProvider.clearCart();
  }
}
