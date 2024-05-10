import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class FoodDetailScreen extends StatefulWidget {
  final Map<String, dynamic> food;

  FoodDetailScreen({required this.food});

  @override
  _FoodDetailScreenState createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  int _quantity = 1;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 0) _quantity--;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                '${widget.food['img_name']}',
                fit: BoxFit.cover,
                height: 250,
              ),
            ),
            SizedBox(height: 16),
            Text(
              widget.food['title'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              widget.food['description'],
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 16),
            Text(
              "Rp. ${widget.food['price']}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.favorite_border, color: Colors.red),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.share, color: Colors.grey[600]),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove, color: Colors.green[600]),
                  onPressed: _decrementQuantity,
                ),
                Text(
                  '$_quantity',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.green[600]),
                  onPressed: _incrementQuantity,
                ),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () async {
                await cartProvider.addToCart(
                  widget.food['id'],
                  widget.food['title'],
                  widget.food['price'].toDouble(),
                  widget.food['img_name'],
                  _quantity,
                );

                if (cartProvider.errorMessage == null) {
                  Navigator.pushNamed(context, '/cart');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(cartProvider.errorMessage!),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Add to cart",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
