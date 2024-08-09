import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monny/api/balance.dart';
import 'package:monny/screens/busket.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      // Save the scroll position if needed
    });
  }

  Future<void> _refresh() async {
    // Запрашиваем обновление данных
    await ref.refresh(productProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final productAsyncValue = ref.watch(productProvider);
    final cartState = ref.watch(cartProvider);
    final cartNotifier = ref.watch(cartProvider.notifier);

    return Scaffold(
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            children: [
              const Text(
                'Tap to search',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                ),
              ),
              Consumer(
                builder: (context, ref, _) {
                  final searchController = TextEditingController();
                  return TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search by title',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      ref.read(searchTextProvider.notifier).state = value;
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('Product List'),
        actions: [
          Consumer(
            builder: (context, ref, _) {
              final sortOption = ref.watch(sortOptionProvider);
              return DropdownButton<String>(
                value: sortOption,
                items: const [
                  DropdownMenuItem(
                    value: 'price',
                    child: Text('Sort by Price'),
                  ),
                  DropdownMenuItem(
                    value: 'rate',
                    child: Text('Sort by Rate'),
                  ),
                ],
                onChanged: (value) {
                  ref.read(sortOptionProvider.notifier).state = value!;
                },
              );
            },
          ),
          Consumer(
            builder: (context, ref, _) {
              final isSortedAscending = ref.watch(isSortedAscendingProvider);
              return IconButton(
                icon: Icon(isSortedAscending
                    ? Icons.arrow_upward
                    : Icons.arrow_downward),
                onPressed: () {
                  ref.read(isSortedAscendingProvider.notifier).state =
                      !isSortedAscending;
                },
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text('Balance: \$${cartState.balance.toStringAsFixed(2)}'),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: productAsyncValue.when(
          data: (products) {
            return Consumer(
              builder: (context, ref, _) {
                final sortOption = ref.watch(sortOptionProvider);
                final isSortedAscending = ref.watch(isSortedAscendingProvider);
                final searchText = ref.watch(searchTextProvider);

                if (sortOption == 'price') {
                  products.sort((a, b) => isSortedAscending
                      ? a.price.compareTo(b.price)
                      : b.price.compareTo(a.price));
                } else if (sortOption == 'rate') {
                  products.sort((a, b) => isSortedAscending
                      ? a.rate.compareTo(b.rate)
                      : b.rate.compareTo(a.rate));
                }

                final filteredProducts = searchText.isEmpty
                    ? products
                    : products
                        .where((product) => product.title
                            .toLowerCase()
                            .contains(searchText.toLowerCase()))
                        .toList();

                return GridView.builder(
                  controller: _scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2 / 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return Card(
                      elevation: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Image.network(
                              product.image,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.title,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                Text(
                                  'Rate: ${product.rate.toString()}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    cartNotifier.addToCart(product);
                                  },
                                  child: const Text('Buy'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }
}

final sortOptionProvider = StateProvider<String>((ref) => 'price');
final isSortedAscendingProvider = StateProvider<bool>((ref) => true);
final searchTextProvider = StateProvider<String>((ref) => '');
