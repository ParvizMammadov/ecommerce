// lib/services/api_service.dart
import 'package:dio/dio.dart';

import 'package:monny/api/models.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await _dio.get('https://fakestoreapi.com/products');
      if (response.statusCode == 200) {
        print(response.data);
        List<Product> products = (response.data as List)
            .map((item) => Product.fromJson(item))
            .toList();
        return products;
      } else {
        throw Exception('Failed to load products');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    }
  }
}
