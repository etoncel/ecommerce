import 'dart:convert';

import 'package:ecommerce_sample/src/core/error/server_exception.dart';
import 'package:ecommerce_sample/src/data/datasources/product_remote_datasource.dart';
import 'package:ecommerce_sample/src/data/models/product_model.dart';
import 'package:http/http.dart' as http;

class ProductRemoteDatasourceImpl implements ProductRemoteDatasource {
  final http.Client client;

  ProductRemoteDatasourceImpl({required this.client});

  static const String baseUrl = 'https://fakestoreapi.com';

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final response = await client.get(
      Uri.parse('$baseUrl/products'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw ServerException(
        message: 'Failed to get products: ${response.statusCode}',
      );
    }
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    final response = await client.get(
      Uri.parse('$baseUrl/products/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      return ProductModel.fromJson(jsonMap);
    } else if (response.statusCode == 404) {
      throw ServerException(message: 'Product with ID $id not found.');
    } else {
      throw ServerException(
        message: 'Failed to get product: ${response.statusCode}',
      );
    }
  }

  @override
  Future<ProductModel> addProduct(ProductModel product) async {
    final response = await client.post(
      Uri.parse('$baseUrl/products'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );

    if (response.statusCode == 200) {
      // FakeStoreAPI returns the added product directly on success, but often with a new ID
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      return ProductModel.fromJson(jsonMap);
    } else {
      throw ServerException(
        message: 'Failed to add product: ${response.statusCode}',
      );
    }
  }
}
