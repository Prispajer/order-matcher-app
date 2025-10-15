import '../../domain/entities/order_item.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_ai_datasource.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderAiDatasource datasource;

  OrderRepositoryImpl(this.datasource);

  @override
  Future<List<OrderItem>> analyzeOrder(
    String inputText,
    List<String> productTitles,
  ) {
    return datasource.analyzeOrder(inputText, productTitles);
  }
}
