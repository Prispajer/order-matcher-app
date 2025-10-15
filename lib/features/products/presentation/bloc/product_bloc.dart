import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_matcher_app/features/products/domain/repositories/product_repository.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  ProductBloc(this.repository) : super(ProductInitial()) {
    on<FetchProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        final products = await repository.getProducts();
        emit(ProductLoaded(products));
      } catch (e) {
        emit(
          ProductError(
            'Failed to load products. Please check your connection.',
          ),
        );
      }
    });
  }
}
