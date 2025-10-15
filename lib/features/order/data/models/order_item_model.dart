import '../../domain/entities/order_item.dart';

class OrderItemModel extends OrderItem {
  OrderItemModel({
    required super.name,
    required super.quantity,
    super.unitPrice,
    super.matched = false,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'quantity': quantity};
  }
}
