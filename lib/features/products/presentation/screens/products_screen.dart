import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_state.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/products_list.dart';
import '../widgets/error_view.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: Column(
        children: [
          const SearchBarWidget(),
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProductLoaded) {
                  return ProductsList(products: state.filteredProducts);
                } else if (state is ProductError) {
                  return ErrorView(message: state.message);
                }
                return const Center(child: Text('No data.'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
