import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/cart.dart';

class CartScreen extends StatelessWidget {
  final double deliveryFee = 5000;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final double subtotal = cartProvider.subtotal;
    final double total = subtotal + deliveryFee;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Keranjang",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () => _confirmClearCart(context, cartProvider),
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: cartProvider.fetchCartItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: Consumer<CartProvider>(
                    builder: (context, cartProvider, _) {
                      if (cartProvider.cartItems.isEmpty) {
                        return Center(
                          child: Text("Keranjang kosong"),
                        );
                      }

                      return ListView.builder(
                        itemCount: cartProvider.cartItems.length,
                        itemBuilder: (context, index) {
                          final cartItem = cartProvider.cartItems[index];
                          return _buildCartItem(
                              context, cartItem, cartProvider);
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Subtotal"),
                    Text("\Rp. ${subtotal.toStringAsFixed(2)}"),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Delivery"),
                    Text("\Rp. ${deliveryFee.toStringAsFixed(2)}"),
                  ],
                ),
                Divider(thickness: 1, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("\Rp. ${total.toStringAsFixed(2)}",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/checkout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen[600],
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Bayar",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCartItem(
      BuildContext context, Cart cartItem, CartProvider cartProvider) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Food Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                '${cartItem.imgName}',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16),
            // Food Title and Price
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cartItem.title,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text("\Rp. ${cartItem.price.toStringAsFixed(2)}"),
                ],
              ),
            ),
            // Quantity Controls
            Row(
              children: [
                Text("Qty: ${cartItem.quantity}",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red[300]),
                  onPressed: () =>
                      _confirmDeleteItem(context, cartItem.id, cartProvider),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteItem(
      BuildContext context, int cartId, CartProvider cartProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Hapus Item"),
          content: Text(
              "Apakah Anda yakin ingin menghapus item ini dari keranjang?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Tidak"),
            ),
            TextButton(
              onPressed: () async {
                await cartProvider.deleteCartItem(cartId);
                Navigator.of(context).pop();
              },
              child: Text("Ya"),
            ),
          ],
        );
      },
    );
  }

  void _confirmClearCart(BuildContext context, CartProvider cartProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Hapus Semua Item"),
          content: Text(
              "Apakah Anda yakin ingin menghapus semua item dari keranjang?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Tidak"),
            ),
            TextButton(
              onPressed: () async {
                await cartProvider.clearCart();
                Navigator.of(context).pop();
              },
              child: Text("Ya"),
            ),
          ],
        );
      },
    );
  }
}
