// // user_provider.dart

// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:dio/dio.dart';
// import 'package:monny/firebase/models.dart';

// final userProvider = FutureProvider<List<Product>>((ref) async {
//   final response = await Dio().get('https://fakestoreapi.com/products');
//   if (response.statusCode == 200) {
//     return (response.data as List)
//         .map((userJson) => Product.fromJson(userJson))
//         .toList();
//   } else {
//     throw Exception('Failed to load users');
//   }
// });
