import '../../../products/domain/entities/product.dart';
import '../../domain/entities/order_item.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderSuccess extends OrderState {
  final List<OrderItem> items;
  final List<Product> products;

  OrderSuccess(this.items, this.products);
}

class OrderError extends OrderState {
  final String message;

  OrderError(this.message);
}
