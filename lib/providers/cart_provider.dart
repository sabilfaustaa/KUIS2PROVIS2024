import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../helpers/shared_preferences_helper.dart';
import '../models/cart.dart';

class CartProvider with ChangeNotifier {
  List<Cart> _cartItems = [];
  final ApiService _apiService = ApiService();
  String? errorMessage;
  List<Cart> get cartItems => _cartItems;

  double get subtotal =>
      _cartItems.fold(0, (total, item) => total + item.totalPrice);

  Future<void> addToCart(int itemId, String title, double price, String imgName,
      int quantity) async {
    try {
      errorMessage = null;
      final userId = await SharedPreferencesHelper.getUserId();
      if (userId == null) throw Exception("User not logged in");

      final response =
          await _apiService.addItemToCart(itemId, userId, quantity);

      final cartItem = Cart(
        id: response['id'],
        title: title,
        price: price,
        imgName: imgName,
        quantity: response['quantity'],
      );

      _cartItems.add(cartItem);
      notifyListeners();
    } catch (e) {
      errorMessage = "Failed to add item to cart: ${e.toString()}";
      notifyListeners();
    }
  }

  Future<void> fetchCartItems() async {
    int? userId = await SharedPreferencesHelper.getUserId();
    if (userId != null) {
      try {
        final cartItemsData = await _apiService.fetchCartItems(userId);
        final allItems = await _apiService.fetchAllItems();

        final cartItems = cartItemsData.map((item) {
          final itemDetails = allItems.firstWhere(
              (detail) => detail['id'] == item['item_id'],
              orElse: () => {});

          return Cart(
            id: item['id'],
            title: itemDetails['title'] ?? 'Unknown Item',
            price: itemDetails['price']?.toDouble() ?? 0.0,
            imgName: itemDetails['img_name'] ?? '',
            quantity: item['quantity'],
          );
        }).toList();

        _cartItems = cartItems;
        notifyListeners();
      } catch (e) {
        errorMessage = "Failed to fetch cart items: ${e.toString()}";
        notifyListeners();
      }
    }
  }

  Future<void> deleteCartItem(int cartId) async {
    if (await _apiService.deleteCartItem(cartId)) {
      _cartItems.removeWhere((item) => item.id == cartId);
      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    int? userId = await SharedPreferencesHelper.getUserId();
    if (userId != null && await _apiService.clearCartItems(userId)) {
      _cartItems.clear();
      notifyListeners();
    }
  }

  Future<void> setStatusHarapBayar() async {
    int? userId = await SharedPreferencesHelper.getUserId();
    if (userId != null) {
      try {
        final response = await _apiService.setStatusHarapBayar(userId);

        _cartItems.clear();
        notifyListeners();
      } catch (e) {
        errorMessage = "Failed to set status harap bayar: ${e.toString()}";
        notifyListeners();
      }
    }
  }
}
