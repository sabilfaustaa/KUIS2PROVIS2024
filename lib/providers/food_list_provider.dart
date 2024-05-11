import 'package:flutter/material.dart';
import '../services/api_service.dart';

class FoodListProvider with ChangeNotifier {
  List<Map<String, dynamic>> _foods = [];
  String? errorMessage;

  ApiService _apiService = ApiService();

  List<Map<String, dynamic>> get foods => _foods;

  Future<void> fetchFoods({String keyword = ''}) async {
    try {
      _foods = await _apiService.getItems(keyword: keyword);
      notifyListeners(); // Memastikan ini dipanggil setelah data diupdate
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners(); // Juga dipanggil saat ada error
    }
  }
}
