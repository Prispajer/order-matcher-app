class OrderItem {
  final String name;
  final int quantity;
  final double? unitPrice;
  final bool matched;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.matched,
  });

  double get total => (unitPrice ?? 0) * quantity;
}
