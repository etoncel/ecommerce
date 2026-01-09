import 'package:ecommerce_sample/src/presentation/templates/search/search_page_template_desktop.dart';
import 'package:ecommerce_sample/src/presentation/templates/search/search_page_template_mobile.dart';
import 'package:ecommerce_sample/src/presentation/ui_models/category_quantity_ui_model.dart';
import 'package:ecommerce_sample/src/presentation/ui_models/product_ui_model.dart';
import 'package:ecommerce_sample_design_system/ecommerce_sample_design_system.dart';
import 'package:flutter/material.dart';

/// Responsive coordinator template that automatically switches between mobile and desktop layouts
/// based on screen size. Detects screen width using ResponsiveBreakpoints utility and renders
/// the appropriate template while maintaining all search state and filter selections.
class SearchPageTemplate extends StatelessWidget {
  /// Controlador para la barra de búsqueda.
  final TextEditingController searchController;

  /// Callback que se ejecuta cuando el texto en la barra de búsqueda es enviado.
  final ValueChanged<String> onSearchSubmitted;

  /// Título para la lista de productos.
  final String productListTitle;

  /// Lista de Productos
  final List<ProductUiModel> products;

  /// Lista de categorias con cantidades
  final List<CategoryQuantityUiModel> categories;

  /// Indicador de si se está cargando la data.
  final bool isLoading;

  /// Mensaje de error a mostrar, si existe alguno.
  final String? errorMessage;

  /// Mensaje a mostrar cuando no se encuentran productos.
  final String? noProductsMessage;

  /// Cadena que indica el valor del filtro aplicado que se debe mostrar
  ///
  /// Puede ser nulo.
  final String? selectedFilter;

  /// Función de devolución de llamada que se llama cuando se toca un elemento
  /// de lista de filtro. Ejemplo: Lista de categorías.
  final Function(int)? onFilterSelected;

  /// Función de devolución de llamada que se llama cuando se toca un elemento
  /// de filtro aplicado para cancelarlo.
  final VoidCallback? onFilterUnselected;

  const SearchPageTemplate({
    super.key,
    required this.searchController,
    required this.onSearchSubmitted,
    required this.productListTitle,
    required this.products,
    required this.categories,
    this.selectedFilter,
    this.isLoading = false,
    this.errorMessage,
    this.noProductsMessage,
    this.onFilterSelected,
    this.onFilterUnselected,
  });

  @override
  Widget build(BuildContext context) {
    if (ResponsiveBreakpoints.isMobile(context)) {
      return SearchPageTemplateMobile(
        searchController: searchController,
        onSearchSubmitted: onSearchSubmitted,
        productListTitle: productListTitle,
        products: products,
        categories: categories,
        selectedFilter: selectedFilter,
        isLoading: isLoading,
        errorMessage: errorMessage,
        noProductsMessage: noProductsMessage,
        onFilterSelected: onFilterSelected,
        onFilterUnselected: onFilterUnselected,
      );
    } else {
      return SearchPageTemplateDesktop(
        searchController: searchController,
        onSearchSubmitted: onSearchSubmitted,
        productListTitle: productListTitle,
        products: products,
        categories: categories,
        selectedFilter: selectedFilter,
        isLoading: isLoading,
        errorMessage: errorMessage,
        noProductsMessage: noProductsMessage,
        onFilterSelected: onFilterSelected,
        onFilterUnselected: onFilterUnselected,
      );
    }
  }
}
