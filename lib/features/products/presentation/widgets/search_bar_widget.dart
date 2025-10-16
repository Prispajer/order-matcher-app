import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'Search products...',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
        ),
        onChanged: (value) {
          context.read<ProductBloc>().add(SearchProducts(value));
        },
      ),
    );
  }
}
