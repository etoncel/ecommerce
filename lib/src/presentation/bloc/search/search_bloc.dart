import 'package:ecommerce_package_sample/ecommerce_package_sample.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final GetAllProductsUseCase getAllProductsUseCase;

  SearchBloc({required this.getAllProductsUseCase})
    : super(const SearchInitial()) {
    on<SearchProducts>(_onSearchProducts);
  }

  /// Maneja el evento [SearchProducts] para filtrar los productos cargados
  /// en base a un texto de búsqueda.
  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<SearchState> emit,
  ) async {
    final result = await getAllProductsUseCase();
    result.fold((error) => emit(SearchError(error.toString())), (products) {
      final filteredProducts = products
          .where(
            (product) =>
                product.title.toLowerCase().contains(event.query.toLowerCase()),
          )
          .toList();
      emit(
        SearchLoaded(allProducts: products, displayProducts: filteredProducts),
      );
    });
  }
}
