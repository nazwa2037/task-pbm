import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import 'auth_service.dart';

class ProductService {
  static const String baseUrl = 'https://task.itprojects.web.id';

  Future<Map<String, String>> _getHeaders() async {
    final token = await AuthService.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<ProductModel>> getProducts() async {
    final url = Uri.parse('$baseUrl/api/products');
    final headers = await _getHeaders();

    final response = await http.get(url, headers: headers);
    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      final List productsJson = data['data']['products'];
      return productsJson.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      throw Exception(data['message'] ?? 'Gagal memuat produk');
    }
  }

  Future<ProductModel> addProduct({
    required String name,
    required int price,
    required String description,
  }) async {
    final url = Uri.parse('$baseUrl/api/products');
    final headers = await _getHeaders();

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({
        'name': name,
        'price': price,
        'description': description,
      }),
    );

    final data = jsonDecode(response.body);

    if ((response.statusCode == 200 || response.statusCode == 201) &&
        data['success'] == true) {
      return ProductModel.fromJson(data['data']['product']);
    } else {
      throw Exception(data['message'] ?? 'Gagal menambahkan produk');
    }
  }

  Future<void> deleteProduct(int id) async {
    final url = Uri.parse('$baseUrl/api/products/$id');
    final headers = await _getHeaders();

    final response = await http.delete(url, headers: headers);
    final data = jsonDecode(response.body);

    if (response.statusCode != 200 || data['success'] != true) {
      throw Exception(data['message'] ?? 'Gagal menghapus produk');
    }
  }

  Future<void> submitTugas({
    required String name,
    required int price,
    required String description,
    required String githubUrl,
  }) async {
    final url = Uri.parse('$baseUrl/api/products/submit');
    final headers = await _getHeaders();

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({
        'name': name,
        'price': price,
        'description': description,
        'github_url': githubUrl,
      }),
    );

    final data = jsonDecode(response.body);

    if ((response.statusCode == 200 || response.statusCode == 201) &&
        data['success'] == true) {
      return;
    } else {
      throw Exception(data['message'] ?? 'Gagal submit tugas');
    }
  }
}
