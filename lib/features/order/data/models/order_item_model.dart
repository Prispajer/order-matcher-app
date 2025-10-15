import '../../domain/entities/order_item.dart';

class OrderItemModel extends OrderItem {
  const OrderItemModel({required super.product, required super.quantity});

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(product: json['product'], quantity: json['quantity']);
  }
}
