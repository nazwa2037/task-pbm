import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';

class AuthService {
  static const String baseUrl = 'https://task.itprojects.web.id';

  static const String _tokenKey = 'auth_token';
  static const String _nameKey = 'user_name';
  static const String _usernameKey = 'user_username';

  Future<UserModel> login(String nim, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/login');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'username': nim,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      final user = UserModel.fromJson(data['data']);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, user.token);
      await prefs.setString(_nameKey, user.name);
      await prefs.setString(_usernameKey, user.username);
      return user;
    } else {
      throw Exception(data['message'] ?? 'Login gagal');
    }
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_nameKey);
    await prefs.remove(_usernameKey);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    return token != null && token.isNotEmpty;
  }
}
