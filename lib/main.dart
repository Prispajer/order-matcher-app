import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/products/data/datasources/product_remote_datasource.dart';
import 'features/products/data/repositories/product_repository_impl.dart';
import 'features/products/domain/repositories/product_repository.dart';
import 'features/products/presentation/bloc/product_bloc.dart';
import 'features/products/presentation/bloc/product_event.dart';
import 'features/products/presentation/screens/products_screen.dart';

void main() {
  final ProductRepository repo = ProductRepositoryImpl(
    ProductRemoteDatasource(http.Client()),
  );

  runApp(MyApp(repo));
}

class MyApp extends StatelessWidget {
  final ProductRepository repo;

  const MyApp(this.repo, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Order Matcher',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: BlocProvider(
        create: (_) => ProductBloc(repo)..add(FetchProducts()),
        child: const ProductsScreen(),
      ),
    );
  }
}
