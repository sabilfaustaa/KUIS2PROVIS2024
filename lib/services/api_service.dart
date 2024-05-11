import 'dart:convert';
import 'package:http/http.dart' as http;
import '../helpers/shared_preferences_helper.dart';

class ApiService {
  static const baseUrl = "http://146.190.109.66:8000";

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data,
      {String? token}) async {
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> get(String endpoint, {String? token}) async {
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    final response =
        await http.get(Uri.parse('$baseUrl$endpoint'), headers: headers);
    return jsonDecode(response.body);
  }

  Future<List<Map<String, dynamic>>> getItems(
      {int skip = 0, int limit = 100}) async {
    final token = await SharedPreferencesHelper.getAccessToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      Uri.parse('$baseUrl/items?skip=$skip&limit=$limit'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception(
          "Gagal ambil data tems. Status code: ${response.statusCode}");
    }
  }

  Future<Map<String, dynamic>> addItemToCart(
      int itemId, int userId, int quantity) async {
    final token = await SharedPreferencesHelper.getAccessToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final response = await http.post(
      Uri.parse('$baseUrl/carts/'),
      headers: headers,
      body: jsonEncode({
        'item_id': itemId,
        'user_id': userId,
        'quantity': quantity,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          "Gagal tambah data item ke keranjang. Status code: ${response.statusCode}");
    }
  }

  Future<List<Map<String, dynamic>>> fetchCartItems(int userId,
      {int skip = 0, int limit = 100}) async {
    final token = await SharedPreferencesHelper.getAccessToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      Uri.parse('$baseUrl/carts/$userId?skip=$skip&limit=$limit'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception("Gagal load data keranjang");
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllItems() async {
    return await getItems();
  }

  Future<bool> deleteCartItem(int cartId) async {
    final token = await SharedPreferencesHelper.getAccessToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final response = await http.delete(
      Uri.parse('$baseUrl/carts/$cartId'),
      headers: headers,
    );

    return response.statusCode == 200;
  }

  Future<bool> clearCartItems(int userId) async {
    final token = await SharedPreferencesHelper.getAccessToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final response = await http.delete(
      Uri.parse('$baseUrl/clear_whole_carts_by_userid/$userId'),
      headers: headers,
    );

    return response.statusCode == 200;
  }

  Future<Map<String, dynamic>> setStatusHarapBayar(int userId) async {
    final token = await SharedPreferencesHelper.getAccessToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final response = await http.post(
      Uri.parse('$baseUrl/set_status_harap_bayar/$userId'),
      headers: headers,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          "Gagal set status harap bayar. Status code: ${response.statusCode}");
    }
  }

  Future<Map<String, dynamic>> getStatus(int userId) async {
    final token = await SharedPreferencesHelper.getAccessToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final response = await http.get(
      Uri.parse('$baseUrl/get_status/$userId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          "Gagal ambil status terkini. Status code: ${response.statusCode}");
    }
  }
}
