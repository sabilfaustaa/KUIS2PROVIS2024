import 'package:flutter/material.dart';

class FoodListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> foods = [
    {
      "title": "Sushi Mentai",
      "description": "Japanese, Rice",
      "price": 59000,
      "img_name": "assets/images/sushi.png",
      "id": 1
    },
    {
      "title": "Chicken Teriyaki",
      "description": "Japanese, Rice",
      "price": 39000,
      "img_name": "assets/images/chicken_teriyaki.png",
      "id": 2
    },
    {
      "title": "Mixed Bowl",
      "description": "Various, Noodle",
      "price": 45000,
      "img_name": "assets/images/mixed_bowl.png",
      "id": 3
    },
    {
      "title": "Fusion Ramen",
      "description": "Japanese, Noodle",
      "price": 59000,
      "img_name": "assets/images/fusion_ramen.png",
      "id": 4
    },
    {
      "title": "Sushi Mentai",
      "description": "Japanese, Rice",
      "price": 59000,
      "img_name": "assets/images/sushi.png",
      "id": 1
    },
    {
      "title": "Chicken Teriyaki",
      "description": "Japanese, Rice",
      "price": 39000,
      "img_name": "assets/images/chicken_teriyaki.png",
      "id": 2
    },
    {
      "title": "Mixed Bowl",
      "description": "Various, Noodle",
      "price": 45000,
      "img_name": "assets/images/mixed_bowl.png",
      "id": 3
    },
    {
      "title": "Fusion Ramen",
      "description": "Japanese, Noodle",
      "price": 59000,
      "img_name": "assets/images/fusion_ramen.png",
      "id": 4
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Search functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // Share functionality
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Text(
              "BarayaFood Big Diskonn!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.thumb_up, color: Colors.orange),
                SizedBox(width: 4),
                Text("Super Partner"),
                SizedBox(width: 8),
                Text("Korean Food"),
                Spacer(),
                CircleAvatar(
                  backgroundColor: Colors.red[100],
                  child: Icon(Icons.restaurant_menu, color: Colors.red),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Rating and Distance Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoIcon(Icons.star, "4.5", "200 ratings", Colors.orange),
                _buildInfoIcon(
                    Icons.location_pin, "4.5km", "in 30 min", Colors.red),
                _buildInfoIcon(
                    Icons.attach_money, "Rp.", "20 - 100rb", Colors.green),
                _buildInfoIcon(Icons.timer, "Open", "200m left", Colors.red),
              ],
            ),
            SizedBox(height: 24),
            Text("Best Seller",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            // Food List
            Expanded(
              child: GridView.builder(
                itemCount: foods.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  final food = foods[index];
                  return _buildFoodItem(food);
                },
              ),
            ),
          ],
        ),
      ),
      // Floating Action Button for Menu
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/cart');
        },
        label: Text("Keranjang"),
        icon: Icon(Icons.shopping_cart),
        backgroundColor: Colors.orange[200],
      ),
    );
  }

  Widget _buildInfoIcon(
      IconData icon, String primary, String secondary, Color color) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: color),
            SizedBox(width: 4),
            Text(primary, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        Text(secondary, style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildFoodItem(Map<String, dynamic> food) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Food Image
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                food["img_name"],
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Food Title
                Text(food["title"],
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                // Food Price
                Text("${food["price"]}"),
                SizedBox(height: 8),
                // Add Button
                ElevatedButton(
                  onPressed: () {
                    // Add to cart functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    padding: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text("Add", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}