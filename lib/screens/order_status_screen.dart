import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_status_provider.dart';
import '../providers/cart_provider.dart';
import '../models/order_status.dart';

class OrderStatusScreen extends StatelessWidget {
  final List<Map<String, String>> statusSteps = [
    {"status": "checkout", "label": "Checkout"},
    {"status": "payment", "label": "Payment"},
    {"status": "accepted", "label": "Restaurant Accepted"},
    {"status": "rejected", "label": "Restaurant Rejected"},
    {"status": "delivering", "label": "Delivering"},
    {"status": "completed", "label": "Completed"},
  ];

  @override
  Widget build(BuildContext context) {
    final orderStatusProvider = Provider.of<OrderStatusProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    final currentStatus = orderStatusProvider.currentStatus;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Order Status",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildStatusStep(currentStatus),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                final nextStatus = _getNextStatus(currentStatus.status);
                if (nextStatus != null) {
                  final nextDescription = _getStatusDescription(nextStatus);
                  orderStatusProvider.updateStatus(nextStatus, nextDescription);
                } else {
                  orderStatusProvider.resetOrder();
                  cartProvider.clearCart();
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
                "Refresh Status",
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

  Widget _buildStatusStep(OrderStatus currentStatus) {
    return Column(
      children: statusSteps.map((step) {
        bool isActive = currentStatus.status == step["status"];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: isActive ? Colors.green[600] : Colors.grey[300],
            child: Icon(
              isActive ? Icons.check : Icons.radio_button_unchecked,
              color: Colors.white,
            ),
          ),
          title: Text(step["label"]!),
          subtitle: Text(
            isActive ? currentStatus.description : "",
            style: TextStyle(color: Colors.grey[600]),
          ),
        );
      }).toList(),
    );
  }

  String? _getNextStatus(String currentStatus) {
    final currentIndex =
        statusSteps.indexWhere((step) => step["status"] == currentStatus);
    if (currentIndex >= 0 && currentIndex < statusSteps.length - 1) {
      return statusSteps[currentIndex + 1]["status"];
    }
    return null;
  }

  String _getStatusDescription(String status) {
    switch (status) {
      case "payment":
        return "Payment completed";
      case "accepted":
        return "Restaurant accepted the order";
      case "rejected":
        return "Restaurant rejected the order";
      case "delivering":
        return "Driver is delivering the order";
      case "completed":
        return "Order completed";
      default:
        return "";
    }
  }
}
