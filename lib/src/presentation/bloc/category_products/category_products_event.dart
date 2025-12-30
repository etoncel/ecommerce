part of 'category_products_bloc.dart';

abstract class CategoryProductsEvent {
  const CategoryProductsEvent();
}

class LoadCategoryProducts extends CategoryProductsEvent {
  final String categoryName;

  const LoadCategoryProducts(this.categoryName);
}
