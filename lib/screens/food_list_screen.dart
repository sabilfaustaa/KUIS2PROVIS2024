import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/food_list_provider.dart';
import 'food_detail_screen.dart';

class FoodListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FoodListProvider()..fetchFoods(),
      child: Scaffold(
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
          child: Consumer<FoodListProvider>(
            builder: (context, foodListProvider, child) {
              if (foodListProvider.errorMessage != null) {
                return Center(
                  child: Text(foodListProvider.errorMessage!),
                );
              }

              if (foodListProvider.foods.isEmpty) {
                return Center(child: CircularProgressIndicator());
              }

              return Column(
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
                      _buildInfoIcon(
                          Icons.star, "4.5", "200 ratings", Colors.orange),
                      _buildInfoIcon(
                          Icons.location_pin, "4.5km", "in 30 min", Colors.red),
                      _buildInfoIcon(Icons.attach_money, "Rp.", "20 - 100rb",
                          Colors.green),
                      _buildInfoIcon(
                          Icons.timer, "Open", "200m left", Colors.red),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text("Best Seller",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  // Food List
                  Expanded(
                    child: GridView.builder(
                      itemCount: foodListProvider.foods.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemBuilder: (context, index) {
                        final food = foodListProvider.foods[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    FoodDetailScreen(food: food),
                              ),
                            );
                          },
                          child: _buildFoodItem(context, food),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
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

  Widget _buildFoodItem(context, Map<String, dynamic> food) {
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
                '${food["img_name"]}',
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
                Text("Rp. ${food["price"]}"),
                SizedBox(height: 8),
                // Add Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodDetailScreen(food: food),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    padding: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text("Lihat", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
