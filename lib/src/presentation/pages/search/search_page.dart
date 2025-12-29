import 'package:ecommerce_sample/src/presentation/bloc/search/search_bloc.dart';
import 'package:ecommerce_sample/src/presentation/templates/search/search_page_template.dart';
import 'package:ecommerce_package_sample/ecommerce_package_sample.dart';
import 'package:ecommerce_sample/src/presentation/ui_models/category_quantity_ui_model.dart';
import 'package:ecommerce_sample/src/presentation/ui_models/product_ui_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatelessWidget {
  final String searchText;
  const SearchPage({super.key, required this.searchText});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SearchBloc(getAllProductsUseCase: ServiceLocator.instance.get())
            ..add(SearchProducts(searchText)),
      child: _SearchPageView(initialSearchText: searchText),
    );
  }
}

class _SearchPageView extends StatefulWidget {
  final String initialSearchText;
  const _SearchPageView({required this.initialSearchText});

  @override
  State<_SearchPageView> createState() => _SearchPageViewState();
}

class _SearchPageViewState extends State<_SearchPageView> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialSearchText);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        bool isLoading = state is SearchLoading;
        String? errorMessage;
        String? noProductsMessage;
        List<ProductUiModel> products = [];
        String title = "Productos";
        List<CategoryQuantityUiModel> categories = [];

        if (state is SearchError) {
          errorMessage = state.message;
        } else if (state is SearchLoaded) {
          title = "Resultados de búsqueda";
          if (state.displayProducts.isEmpty) {
            noProductsMessage = state.searchQuery.isNotEmpty
                ? "No se encontraron productos para '${state.searchQuery}'"
                : "No hay productos disponibles.";
          }
          products = state.displayProducts;

          categories = state.categoryQuantities;
        }

        return SearchPageTemplate(
          searchController: _searchController,
          onSearchSubmitted: (query) {
            context.read<SearchBloc>().add(SearchProducts(query));
          },
          isLoading: isLoading,
          errorMessage: errorMessage,
          noProductsMessage: noProductsMessage,
          productListTitle: title,
          products: products,
          categories: categories,
        );
      },
    );
  }
}
