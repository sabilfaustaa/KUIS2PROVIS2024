import 'package:flutter/material.dart';
import '../models/order_status.dart';
import '../services/api_service.dart';

class OrderStatusProvider with ChangeNotifier {
  OrderStatus _currentStatus = OrderStatus(
    status: "checkout",
    description: "Order checkout completed",
    timestamp: DateTime.now(),
  );
  final ApiService _apiService = ApiService();

  OrderStatus get currentStatus => _currentStatus;

  void updateStatus(String status, String description) {
    // Update status di server
    _apiService.post('/set_status_$status/{user_id}', {});

    _currentStatus = OrderStatus(
      status: status,
      description: description,
      timestamp: DateTime.now(),
    );
    notifyListeners();
  }

  void resetOrder() {
    _currentStatus = OrderStatus(
      status: "checkout",
      description: "Order checkout completed",
      timestamp: DateTime.now(),
    );
    notifyListeners();
  }
}
