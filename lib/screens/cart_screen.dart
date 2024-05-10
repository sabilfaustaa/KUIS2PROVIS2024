import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  final double deliveryFee = 3.5;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final double subtotal = cartProvider.subtotal;
    final double total = subtotal + deliveryFee;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Cart",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: cartProvider.Carts.length,
            //     itemBuilder: (context, index) {
            //       final Cart = cartProvider.Carts[index];
            //       return _buildCart(context, Cart, cartProvider);
            //     },
            //   ),
            // ),
            SizedBox(height: 16),
            // Subtotal, Delivery, Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Subtotal"),
                Text("\$${subtotal.toStringAsFixed(2)}"),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Delivery"),
                Text("\$${deliveryFee.toStringAsFixed(2)}"),
              ],
            ),
            Divider(thickness: 1, height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("\$${total.toStringAsFixed(2)}",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 16),
            // Checkout Button
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/food_list');
              },
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
      ),
    );
  }

  Widget _buildCart(
      BuildContext context, Cart Cart, CartProvider cartProvider) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Food Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                Cart.imgName,
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
                  Text(Cart.title,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text("\$${Cart.price.toStringAsFixed(2)}"),
                ],
              ),
            ),
            // Quantity Controls
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove, color: Colors.green[600]),
                  onPressed: () {
                    cartProvider.removeItem(Cart);
                  },
                ),
                Text("${Cart.quantity}",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.green[600]),
                  onPressed: () {
                    cartProvider.addItem(Cart);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
