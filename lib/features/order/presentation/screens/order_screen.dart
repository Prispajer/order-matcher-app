import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_state.dart';
import '../bloc/order_event.dart';
import '../widgets/order_input.dart';
import '../widgets/order_result.dart';

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
            OrderInput(
              controller: controller,
              onAnalyze: () {
                context.read<OrderBloc>().add(AnalyzeOrder(controller.text));
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<OrderBloc, OrderState>(
                builder: (context, state) {
                  return OrderResult(state: state);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
