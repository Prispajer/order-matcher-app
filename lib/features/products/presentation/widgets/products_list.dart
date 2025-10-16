import 'package:flutter/material.dart';
import 'package:order_matcher_app/features/products/domain/entities/product.dart';

class ProductsList extends StatelessWidget {
  final List<Product> products;
  const ProductsList({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(child: Text('No products available.'));
    }
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (_, i) => ListTile(
        title: Text(products[i].title),
        subtitle: Text('${products[i].price} PLN'),
      ),
    );
  }
}
