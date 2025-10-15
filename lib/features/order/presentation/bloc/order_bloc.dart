import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_matcher_app/features/products/domain/entities/product.dart';
import '../../../products/presentation/bloc/product_bloc.dart';
import '../../../products/presentation/bloc/product_state.dart';
import '../../domain/repositories/order_repository.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository repository;
  final ProductBloc productBloc;

  OrderBloc(this.repository, this.productBloc) : super(OrderInitial()) {
    on<AnalyzeOrder>((event, emit) async {
      emit(OrderLoading());
      try {
        final List<Product> products = (productBloc.state is ProductLoaded)
            ? (productBloc.state as ProductLoaded).products
            : <Product>[];

        final productTitles = products.map((p) => p.title).toList();

        final items = await repository.analyzeOrder(event.input, productTitles);

        emit(OrderSuccess(items, products));
      } catch (e) {
        emit(OrderError('Failed to analyze order: ${e.toString()}'));
      }
    });
  }
}
