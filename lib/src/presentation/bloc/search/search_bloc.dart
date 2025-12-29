import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:ecommerce_package_sample/ecommerce_package_sample.dart';
import 'package:ecommerce_sample/src/presentation/ui_models/category_quantity_ui_model.dart';
import 'package:ecommerce_sample/src/presentation/ui_models/product_ui_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final GetAllProductsUseCase getAllProductsUseCase;

  SearchBloc({
    required this.getAllProductsUseCase,
    SearchState initialState = const SearchInitial(),
  }) : super(initialState) {
    on<SearchProducts>(_onSearchProducts);
    on<SearchCategorySelected>(_onCategorySelected);
    on<SearchCategoryUnSelected>(_onCategoryUnSelected);
  }

  /// Obtiene los products del cache si existen. En caso
  /// contrario consume el servicio
  Future<Either<Failure, List<ProductUiModel>>> _getCurrentProducts() async {
    if (state is SearchLoaded &&
        (state as SearchLoaded).allProducts.isNotEmpty) {
      return Right((state as SearchLoaded).allProducts);
    } else {
      final result = await getAllProductsUseCase();
      return result.fold((error) => Left(error), (productEntities) {
        final products = productEntities
            .map((product) => ProductUiModel.fromEntity(product))
            .toList();
        return Right((products));
      });
    }
  }

  /// Maneja el evento [SearchProducts] para filtrar los productos cargados
  /// en base a un texto de búsqueda.
  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<SearchState> emit,
  ) async {
    final result = await _getCurrentProducts();
    result.fold((error) => emit(SearchError(error.toString())), (products) {
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

      final List<CategoryQuantityUiModel> categoryQuantityList = [];

      for (var category in categoryQuantities.entries.toList()) {
        categoryQuantityList.add(
          CategoryQuantityUiModel(name: category.key, quantity: category.value),
        );
      }

      emit(
        SearchLoaded(
          allProducts: products,
          displayProducts: filteredProducts,
          categoryQuantities: categoryQuantityList,
          searchQuery: event.query,
        ),
      );
    });
  }

  /// Maneja el evento [SearchCategorySelected] para filtrar los products según
  /// la categoría seleccionada
  Future<void> _onCategorySelected(
    SearchCategorySelected event,
    Emitter<SearchState> emit,
  ) async {
    final category = event.selectedCategory;

    if (state is SearchLoaded) {
      final currentState = state as SearchLoaded;
      final filteredProducts = currentState.displayProducts
          .where((product) => product.category == category)
          .toList();
      emit(
        currentState.copyWith(
          displayProducts: filteredProducts,
          selectedCategory: category,
        ),
      );
    }
  }

  Future<void> _onCategoryUnSelected(
    SearchCategoryUnSelected event,
    Emitter<SearchState> emit,
  ) async {
    if (state is SearchLoaded) {
      final currentState = state as SearchLoaded;
      _onSearchProducts(SearchProducts(currentState.searchQuery), emit);
    }
  }
}
