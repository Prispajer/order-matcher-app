import 'package:http/http.dart' as http;
import 'features/products/data/datasources/product_remote_datasource.dart';

void main() async {
  final datasource = ProductRemoteDatasource(http.Client());

  try {
    final products = await datasource.fetchProducts();
    print('Pobrano ${products.length} produktów');
    print(
      'Pierwszy produkt: ${products.first.title} - ${products.first.price}',
    );
  } catch (e) {
    print('Błąd: $e');
  }
}
