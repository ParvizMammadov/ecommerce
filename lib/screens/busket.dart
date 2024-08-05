import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monny/api/balance.dart';
import 'package:monny/firebase/auth.dart';
import 'package:monny/api/models.dart';
import 'package:monny/screens/Signin_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final cartStateNotifier = ref.watch(cartProvider.notifier);

    final Map<Product, int> productCounts = {};
    double totalCost = 0.0;
    String _error = 'ok';

    for (var product in cartState.cart) {
      if (productCounts.containsKey(product)) {
        productCounts[product] = productCounts[product]! + 1;
      } else {
        productCounts[product] = 1;
      }
      totalCost += product.price;
    }
    Future<void> signOut() async {
      await AuthService().signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SigninScreen()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: signOut, icon: const Icon(Icons.logout))
        ],
        title: const Text('My Basket'),
      ),
      body: cartState.cart.isEmpty
          ? const Center(
              child: Text('Your Basket is empty'),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: productCounts.keys.length,
                    itemBuilder: (context, index) {
                      final product = productCounts.keys.elementAt(index);
                      final count = productCounts[product]!;

                      return Card(
                        elevation: 5,
                        child: ListTile(
                          leading: Image.network(product.image),
                          title: Text(product.title),
                          subtitle: Text('Quantity: $count'),
                          trailing: IconButton(
                            onPressed: () =>
                                cartStateNotifier.removeFromCart(product),
                            icon: const Icon(Icons.remove),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Receipt',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 40,
                            fontWeight: FontWeight.w800),
                      ),
                      Text('Total items: ${cartState.cart.length}'),
                      Text('Total cost: ${totalCost.toStringAsFixed(2)}'),
                      Text(
                          'Remaining balance: ${cartState.balance.toStringAsFixed(2)}'),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
