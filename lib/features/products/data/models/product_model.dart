import '../../domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({required super.id, required super.title, required super.price});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'price': price};
  }
}
