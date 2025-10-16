import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';

class ErrorView extends StatelessWidget {
  final String message;
  const ErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              context.read<ProductBloc>().add(FetchProducts());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
