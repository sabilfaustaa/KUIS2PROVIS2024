import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../services/api_service.dart';

class CartProvider with ChangeNotifier {
  List<Cart> _cartItems = [];
  final ApiService _apiService = ApiService();

  List<Cart> get cartItems => _cartItems;

  double get subtotal =>
      _cartItems.fold(0, (total, item) => total + item.totalPrice);

  void addItem(Cart item) {
    // Simpan data di server
    _apiService.post('/carts/', {
      'title': item.title,
      'price': item.price,
      'img_name': item.imgName,
      'quantity': item.quantity,
    });

    // Update local state
    int index = _cartItems.indexWhere((cartItem) => cartItem.id == item.id);
    if (index >= 0) {
      _cartItems[index].quantity++;
    } else {
      _cartItems.add(item);
    }
    notifyListeners();
  }

  void removeItem(Cart item) {
    // Hapus data di server
    // _apiService.delete('/carts/${item.id}');

    // Update local state
    int index = _cartItems.indexWhere((cartItem) => cartItem.id == item.id);
    if (index >= 0) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      } else {
        _cartItems.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    // Hapus semua item di server
    // _apiService.delete('/clear_whole_carts_by_userid/{user_id}');
    _cartItems = [];
    notifyListeners();
  }
}
