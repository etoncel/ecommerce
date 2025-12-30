import 'dart:async';

import 'package:ecommerce_package_sample/ecommerce_package_sample.dart';
import 'package:ecommerce_sample/src/presentation/ui_models/product_ui_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'category_products_event.dart';
part 'category_products_state.dart';

class CategoryProductsBloc
    extends Bloc<CategoryProductsEvent, CategoryProductsState> {
  final GetAllProductsUseCase getAllProductsUseCase;

  CategoryProductsBloc({
    required this.getAllProductsUseCase,
    CategoryProductsState initialState = const CategoryProductsInitial(),
  }) : super(initialState) {
    on<LoadCategoryProducts>(_onLoadCategoryProducts);
  }

  /// Handles the [LoadCategoryProducts] event to fetch and filter products by category
  Future<void> _onLoadCategoryProducts(
    LoadCategoryProducts event,
    Emitter<CategoryProductsState> emit,
  ) async {
    emit(const CategoryProductsLoading());

    final result = await getAllProductsUseCase();

    result.fold((error) => emit(CategoryProductsError(error.toString())), (
      productEntities,
    ) {
      final allProducts = productEntities
          .map((product) => ProductUiModel.fromEntity(product))
          .toList();

      // Filter products by category
      final filteredProducts = allProducts
          .where((product) => product.category == event.categoryName)
          .toList();

      emit(
        CategoryProductsLoaded(
          products: filteredProducts,
          categoryName: event.categoryName,
        ),
      );
    });
  }
}
