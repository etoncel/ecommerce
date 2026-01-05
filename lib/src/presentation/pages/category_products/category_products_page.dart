import 'package:ecommerce_package_sample/ecommerce_package_sample.dart';
import 'package:ecommerce_sample/src/presentation/bloc/category_products/category_products_bloc.dart';
import 'package:ecommerce_sample/src/presentation/templates/category_products/category_products_template.dart';
import 'package:ecommerce_sample/src/presentation/ui_models/product_ui_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Page widget that displays products filtered by category.
/// Provides CategoryProductsBloc and integrates with CategoryProductsTemplate.
class CategoryProductsPage extends StatelessWidget {
  /// The name of the category to display products for
  final String categoryName;

  const CategoryProductsPage({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryProductsBloc(
        getAllProductsUseCase: ServiceLocator.instance.get(),
      )..add(LoadCategoryProducts(categoryName)),
      child: _CategoryProductsPageView(categoryName: categoryName),
    );
  }
}

class _CategoryProductsPageView extends StatelessWidget {
  final String categoryName;

  const _CategoryProductsPageView({required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryProductsBloc, CategoryProductsState>(
      builder: (context, state) {
        bool isLoading = false;
        String? errorMessage;
        List<ProductUiModel> products = [];

        if (state is CategoryProductsLoading) {
          isLoading = true;
        } else if (state is CategoryProductsError) {
          errorMessage = state.message;
        } else if (state is CategoryProductsLoaded) {
          products = state.products;
        }

        return CategoryProductsTemplate(
          categoryName: categoryName,
          products: products,
          isLoading: isLoading,
          errorMessage: errorMessage,
        );
      },
    );
  }
}
