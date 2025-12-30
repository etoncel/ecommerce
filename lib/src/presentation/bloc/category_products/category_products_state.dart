part of 'category_products_bloc.dart';

abstract class CategoryProductsState {
  const CategoryProductsState();
}

class CategoryProductsInitial extends CategoryProductsState {
  const CategoryProductsInitial();
}

class CategoryProductsLoading extends CategoryProductsState {
  const CategoryProductsLoading();
}

class CategoryProductsLoaded extends CategoryProductsState {
  final List<ProductUiModel> products;
  final String categoryName;

  const CategoryProductsLoaded({
    required this.products,
    required this.categoryName,
  });
}

class CategoryProductsError extends CategoryProductsState {
  final String message;

  const CategoryProductsError(this.message);
}
