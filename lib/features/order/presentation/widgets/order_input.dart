import 'package:flutter/material.dart';

class OrderInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onAnalyze;

  const OrderInput({
    super.key,
    required this.controller,
    required this.onAnalyze,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
        ElevatedButton(onPressed: onAnalyze, child: const Text('Analyze')),
      ],
    );
  }
}
