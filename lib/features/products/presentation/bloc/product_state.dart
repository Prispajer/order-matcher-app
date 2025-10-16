import 'package:order_matcher_app/features/products/domain/entities/product.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final List<Product> filteredProducts;

  ProductLoaded({required this.products, required this.filteredProducts});
}
