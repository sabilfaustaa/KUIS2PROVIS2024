import 'package:flutter/material.dart';
import '../services/api_service.dart';

class FoodListProvider with ChangeNotifier {
  List<Map<String, dynamic>> _foods = [];
  final ApiService _apiService = ApiService();
  String? errorMessage;

  List<Map<String, dynamic>> get foods => _foods;

  Future<void> fetchFoods() async {
    try {
      errorMessage = null;
      _foods = await _apiService.getItems();
      notifyListeners();
    } catch (e) {
      errorMessage = "Failed to load foods: ${e.toString()}";
      notifyListeners();
    }
  }
}
