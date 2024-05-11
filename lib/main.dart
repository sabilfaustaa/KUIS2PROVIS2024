import 'package:flutter/material.dart';
import 'package:kuis2provis2024/providers/food_list_provider.dart';
import 'package:kuis2provis2024/screens/order_success.dart';
import 'providers/auth_provider.dart';
import 'screens/cart_screen.dart';
import 'screens/food_detail_screen.dart';
import 'screens/order_status_screen.dart';
import 'screens/food_list_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'providers/order_status_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => OrderStatusProvider()),
          ChangeNotifierProvider(create: (_) => FoodListProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'BarayaFood',
          theme: ThemeData(
            primarySwatch: Colors.lightGreen,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => SplashScreen(),
            '/login': (context) => LoginScreen(),
            '/register': (context) => RegisterScreen(),
            '/food_list': (context) => FoodListScreen(),
            '/food_detail': (context) => FoodDetailScreen(food: {}),
            '/cart': (context) => CartScreen(),
            '/order_status': (context) => OrderStatusScreen(),
            '/order_success': (context) => OrderSuccessScreen()
          },
        ));
  }
}
