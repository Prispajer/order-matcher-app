import '../entities/order_item.dart';

abstract class OrderRepository {
  Future<List<OrderItem>> analyzeOrder(
    String inputText,
    List<String> productTitles,
  );
}
