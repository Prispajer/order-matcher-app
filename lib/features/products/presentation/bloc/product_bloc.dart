import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_matcher_app/features/products/domain/repositories/product_repository.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  ProductBloc(this.repository) : super(ProductInitial()) {
    on<FetchProducts>(_onFetchProducts);
    on<SearchProducts>(_onSearchProducts);
  }

  Future<void> _onFetchProducts(
    FetchProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await repository.getProducts();
      emit(ProductLoaded(products: products, filteredProducts: products));
    } catch (e) {
      emit(ProductError('Failed to fetch products'));
    }
  }

  void _onSearchProducts(SearchProducts event, Emitter<ProductState> emit) {
    if (state is ProductLoaded) {
      final current = state as ProductLoaded;

      if (event.query.isEmpty) {
        emit(
          ProductLoaded(
            products: current.products,
            filteredProducts: current.products,
          ),
        );
      } else {
        final filtered = current.products
            .where(
              (p) => p.title.toLowerCase().contains(event.query.toLowerCase()),
            )
            .toList();

        emit(
          ProductLoaded(products: current.products, filteredProducts: filtered),
        );
      }
    }
  }
}
