import 'package:ecommerce_package_sample/ecommerce_package_sample.dart';
import 'package:ecommerce_sample/src/presentation/ui_models/product_ui_model.dart';
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
    result.fold((error) => emit(SearchError(error.toString())), (
      productsEntities,
    ) {
      final products = productsEntities
          .map((product) => ProductUiModel.fromEntity(product))
          .toList();
      final filteredProducts = products
          .where(
            (product) =>
                product.title.toLowerCase().contains(event.query.toLowerCase()),
          )
          .toList();

      // Calcular la cantidad de productos por categoría de los productos FILTRADOS
      final categoryQuantities = <String, int>{};
      for (var product in filteredProducts) {
        categoryQuantities[product.category] =
            (categoryQuantities[product.category] ?? 0) + 1;
      }

      emit(
        SearchLoaded(
          allProducts: products,
          displayProducts: filteredProducts,
          categoryQuantities: categoryQuantities,
          searchQuery: event.query,
        ),
      );
    });
  }
}
