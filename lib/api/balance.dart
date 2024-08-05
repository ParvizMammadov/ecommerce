import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monny/api/api_services.dart';
import 'package:monny/api/models.dart';

final productProvider = FutureProvider<List<Product>>((ref) async {
  final apiService = ApiService();
  return await apiService.fetchProducts();
});

final cartProvider = StateNotifierProvider<CartStateNotifier, CartState>((ref) {
  return CartStateNotifier();
});

class CartState {
  final List<Product> cart;
  final double balance;

  CartState({this.cart = const [], this.balance = 100000000.0});

  CartState copyWith({List<Product>? cart, double? balance}) {
    return CartState(
      cart: cart ?? this.cart,
      balance: balance ?? this.balance,
    );
  }
}

class CartStateNotifier extends StateNotifier<CartState> {
  CartStateNotifier() : super(CartState());

  void addToCart(Product product) {
    if (state.balance >= product.price) {
      state = state.copyWith(
        cart: [...state.cart, product],
        balance: state.balance - product.price,
      );
    }
  }

  void removeFromCart(Product product) {
    final index = state.cart.indexWhere((item) => item == product);

    if (index != -1) {
      final updatedCart = List<Product>.from(state.cart)..removeAt(index);

      state = state.copyWith(
        cart: updatedCart,
        balance: state.balance + product.price,
      );
    }
  }
}
