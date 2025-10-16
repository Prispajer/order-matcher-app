import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_matcher_app/features/order/presentation/bloc/order_bloc.dart';
import 'package:order_matcher_app/features/order/presentation/bloc/order_event.dart';
import 'package:order_matcher_app/features/order/presentation/bloc/order_state.dart';
import 'package:order_matcher_app/features/products/data/models/product_model.dart';
import '../../../products/domain/entities/product.dart';
import '../../domain/entities/order_item.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Paste your order text here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                context.read<OrderBloc>().add(AnalyzeOrder(controller.text));
              },
              child: const Text('Analyze'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<OrderBloc, OrderState>(
                builder: (context, state) {
                  if (state is OrderLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is OrderError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (state is OrderSuccess) {
                    return _buildTable(state.items, state.products);
                  }
                  return const Center(
                    child: Text('Paste your order and click "Analyze".'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTable(List<OrderItem> items, List<Product> products) {
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
