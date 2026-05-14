// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ApiService {
  final String baseUrl =
      "https://task.itprojects.web.id";

  Future<String?> login(
    String username,
    String password,
  ) async {
    final url =
        Uri.parse('$baseUrl/api/auth/login');

    final response = await http.post(
      url,
      headers: {
        'Content-Type':
            'application/json',
        'Accept':
            'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data =
          jsonDecode(response.body);

      String token =
          data['data']['token'];

      return token;
    } else {
      print(
          'Login gagal: ${response.body}');
      return null;
    }
  }

  Future<List<Product>>
      getProducts(String token) async {
    final url =
        Uri.parse('$baseUrl/api/products');

    final response = await http.get(
      url,
      headers: {
        'Accept':
            'application/json',
        'Authorization':
            'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data =
          jsonDecode(response.body);

      List listData = [];

      if (data['data'] is List) {
        listData = data['data'];
      } else if (data['data']
              ['products'] !=
          null) {
        listData =
            data['data']['products'];
      }

      return listData
          .map(
            (item) =>
                Product
                    .fromJson(item),
          )
          .toList();
    } else {
      print(response.body);
      return [];
    }
  }

  Future<bool> addProduct(
    String token,
    String name,
    int price,
    String description,
  ) async {
    final url =
        Uri.parse('$baseUrl/api/products');

    final response = await http.post(
      url,
      headers: {
        'Content-Type':
            'application/json',
        'Accept':
            'application/json',
        'Authorization':
            'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'price': price,
        'description':
            description,
      }),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return true;
    } else {
      print(response.body);
      return false;
    }
  }

  Future<bool> deleteProduct(
    String token,
    int id,
  ) async {
    final url = Uri.parse(
      '$baseUrl/api/products/$id',
    );

    final response =
        await http.delete(
      url,
      headers: {
        'Accept':
            'application/json',
        'Authorization':
            'Bearer $token',
      },
    );

    if (response.statusCode == 200 ||
        response.statusCode == 204) {
      return true;
    } else {
      print(response.body);
      return false;
    }
  }

  Future<bool> submitTugas(
    String token,
    String name,
    int price,
    String description,
    String githubUrl,
  ) async {
    final url = Uri.parse(
      '$baseUrl/api/products/submit',
    );

    final response = await http.post(
      url,
      headers: {
        'Content-Type':
            'application/json',
        'Accept':
            'application/json',
        'Authorization':
            'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'price': price,
        'description':
            description,
        'github_url':
            githubUrl,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print(response.body);
      return false;
    }
  }
}