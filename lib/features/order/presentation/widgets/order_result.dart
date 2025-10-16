import 'package:flutter/material.dart';
import '../bloc/order_state.dart';
import 'order_table.dart';

class OrderResult extends StatelessWidget {
  final OrderState state;

  const OrderResult({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state is OrderLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is OrderError) {
      final error = state as OrderError;
      return Center(
        child: Text(error.message, style: const TextStyle(color: Colors.red)),
      );
    } else if (state is OrderSuccess) {
      final success = state as OrderSuccess;
      return OrderTable(items: success.items, products: success.products);
    }
    return const Center(child: Text('Paste your order and click "Analyze".'));
  }
}
