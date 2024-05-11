import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_status_provider.dart';
// import '../providers/cart_provider.dart';
import '../helpers/shared_preferences_helper.dart';

class OrderStatusScreen extends StatelessWidget {
  final List<Map<String, String>> statusSteps = [
    {"status": "checkout", "label": "Checkout"},
    {"status": "belum_bayar", "label": "Belum Bayar"},
    {"status": "sudah_bayar", "label": "Sudah Bayar"},
    {"status": "pesanan_diterima", "label": "Penjual Terima"},
    {"status": "pesanan_ditolak", "label": "Penjual Tolak"},
    {"status": "pesanaan_diantar", "label": "Diantar"},
    {"status": "pesanan_selesai", "label": "Diterima"},
  ];

  @override
  Widget build(BuildContext context) {
    final orderStatusProvider =
        Provider.of<OrderStatusProvider>(context, listen: false);
    // final cartProvider = Provider.of<CartProvider>(context);

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
      body: FutureBuilder<void>(
        future: orderStatusProvider.fetchStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return Consumer<OrderStatusProvider>(
            builder: (context, provider, _) {
              if (provider.errorMessage != null) {
                return Center(child: Text(provider.errorMessage!));
              }

              final currentStatus = provider.status;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildStatusSteps(currentStatus),
                    Spacer(),
                    if (currentStatus == "belum_bayar") ...[
                      ElevatedButton(
                        onPressed: () async {
                          await provider.pembayaran();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Pembayaran berhasil!"),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[600],
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Bayar",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ] else if (currentStatus == "sudah_bayar") ...[
                      ElevatedButton(
                        onPressed: () async {
                          await provider.updateStatus(
                              '/set_status_penjual_terima/${await SharedPreferencesHelper.getUserId()}');

                          // cartProvider.clearCart();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Pesanan diterima!"),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[600],
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Terima Pesanan",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          await provider.updateStatus(
                              '/set_status_pesanan_ditolak/${await SharedPreferencesHelper.getUserId()}');
                          // cartProvider.clearCart();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Pesanan ditolak."),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[600],
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Tolak Pesanan",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ] else if (orderStatusProvider.status ==
                        "pesanan_ditolak") ...[
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.pushNamed(context, "/food_list");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[600],
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Kembali ke Beranda",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ] else if (orderStatusProvider.status ==
                        "pesanan_diterima") ...[
                      ElevatedButton(
                        onPressed: () async {
                          await provider.updateStatus(
                              '/set_status_diantar/${await SharedPreferencesHelper.getUserId()}');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Pesanan dalam perjalanan."),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[600],
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Antar Pesanan",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ] else if (orderStatusProvider.status ==
                        "pesanaan_diantar") ...[
                      ElevatedButton(
                        onPressed: () async {
                          await provider.updateStatus(
                              '/set_status_diterima/${await SharedPreferencesHelper.getUserId()}');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Pesanan selesai."),
                            ),
                          );

                          Navigator.pushNamed(context, "/order_success");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[600],
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Pesanan Selesai",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatusSteps(String? currentStatus) {
    return Column(
      children: statusSteps.map((step) {
        bool isActive = currentStatus == step["status"];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: isActive ? Colors.green[600] : Colors.grey[300],
            child: Icon(
              isActive ? Icons.check : Icons.radio_button_unchecked,
              color: Colors.white,
            ),
          ),
          title: Text(step["label"]!),
        );
      }).toList(),
    );
  }
}
