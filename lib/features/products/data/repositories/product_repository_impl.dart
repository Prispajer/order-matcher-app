import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource datasource;
  List<Product>? _cache;

  ProductRepositoryImpl(this.datasource);

  @override
  Future<List<Product>> getProducts() async {
    _cache ??= await datasource.fetchProducts();
    return _cache!;
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    final products = _cache ??= await datasource.fetchProducts();
    return products
        .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
