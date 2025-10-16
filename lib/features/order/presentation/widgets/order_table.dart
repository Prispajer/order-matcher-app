import 'package:flutter/material.dart';
import '../../../products/data/models/product_model.dart';
import '../../../products/domain/entities/product.dart';
import '../../domain/entities/order_item.dart';

class OrderTable extends StatelessWidget {
  final List<OrderItem> items;
  final List<Product> products;

  const OrderTable({super.key, required this.items, required this.products});

  @override
  Widget build(BuildContext context) {
    double total = 0;

    final matchedItems = items.where((item) {
      return products.any(
        (p) => p.title.toLowerCase().contains(item.product.toLowerCase()),
      );
    }).toList();

    if (matchedItems.isEmpty) {
      return const Center(
        child: Text(
          'No products could be matched. Please check your order text for accuracy.',
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    final rows = items.map((item) {
      final match = products.firstWhere(
        (p) => p.title.toLowerCase().contains(item.product.toLowerCase()),
        orElse: () => ProductModel(id: -1, title: 'Unmatched', price: 0),
      );

      final matched = match.id != -1;
      final sum = matched ? item.quantity * match.price : 0;
      if (matched) total += sum;

      return DataRow(
        cells: [
          DataCell(
            Text(item.product[0].toUpperCase() + item.product.substring(1)),
          ),
          DataCell(Text(matched ? '${item.quantity}' : '-')),
          DataCell(Text(matched ? '${match.price} PLN' : '-')),
          DataCell(Text(matched ? '$sum PLN' : '-')),
        ],
      );
    }).toList();

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Product')),
              DataColumn(label: Text('Quantity')),
              DataColumn(label: Text('Unit Price')),
              DataColumn(label: Text('Total')),
            ],
            rows: rows,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Total amount: ${total.toStringAsFixed(2)} PLN',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
