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
          "Failed to load items. Status code: ${response.statusCode}");
    }
  }
}
