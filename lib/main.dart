import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_matcher_app/core/config/app_config_loader.dart';
import 'package:order_matcher_app/features/order/data/datasources/order_ai_datasource.dart';
import 'package:order_matcher_app/features/order/data/repositories/order_repository_impl.dart';
import 'package:order_matcher_app/features/order/presentation/bloc/order_bloc.dart';
import 'package:order_matcher_app/features/products/data/datasources/product_remote_datasource.dart';
import 'package:order_matcher_app/features/products/data/repositories/product_repository_impl.dart';
import 'package:order_matcher_app/features/products/presentation/bloc/product_bloc.dart';
import 'package:order_matcher_app/features/products/presentation/bloc/product_event.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/products/presentation/screens/products_screen.dart';
import 'features/order/presentation/screens/order_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = await AppConfigLoader.load();

  final productRepository = ProductRepositoryImpl(
    ProductRemoteDatasource(http.Client()),
  );
  final orderRepository = OrderRepositoryImpl(OrderAiDatasource(config.apiKey));
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ProductBloc>(
          create: (_) => ProductBloc(productRepository)..add(FetchProducts()),
        ),
        BlocProvider(
          create: (context) =>
              OrderBloc(orderRepository, context.read<ProductBloc>()),
        ),
      ],
      child: const OrderMatcherApp(),
    ),
  );
}

class OrderMatcherApp extends StatelessWidget {
  const OrderMatcherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Order Matcher',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/products': (context) => const ProductsScreen(),
        '/order': (context) => const OrderScreen(),
      },
    );
  }
}
