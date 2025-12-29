import 'package:ecommerce_sample/src/presentation/ui_models/category_quantity_ui_model.dart';
import 'package:ecommerce_sample/src/presentation/ui_models/product_ui_model.dart';
import 'package:ecommerce_sample_design_system/ecommerce_sample_design_system.dart';
import 'package:flutter/material.dart';

/// Plantilla que muestra una pantalla de resultados
/// del componente barra de búsqueda. Es un widget sin estado que
/// recibe todos los datos y callbacks necesarios para renderizar la UI.
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

  /// Función de devolución de llamada que se llama cuando se toca un elemento
  /// de lista de filtro. Ejemplo: Lista de categorías.
  final VoidCallback? onFilterSelected;

  const SearchPageTemplate({
    super.key,
    required this.searchController,
    required this.onSearchSubmitted,
    required this.productListTitle,
    required this.products,
    required this.categories,
    this.isLoading = false,
    this.errorMessage,
    this.noProductsMessage,
    this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          children: [
            Stack(
              alignment: AlignmentGeometry.center,
              children: [
                Container(color: AppColors.background),
                Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: CustomAppBar(
                      showSearchBar: true,
                      searchController: searchController,
                      onSubmitted: onSearchSubmitted,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.verticalL,
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: SingleChildScrollView(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 2,
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const AppText(
                                text: "Categories",
                                style: AppTextStyles.headline2,
                              ),
                              AppSpacing.verticalM,
                              QuantityIndicatorList(
                                indicators: categories
                                    .map(
                                      (cat) => QuantityIndicator(
                                        name: cat.name,
                                        quantity: cat.quantity,
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(flex: 6, child: _buildContent()),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (errorMessage != null) {
      return Center(
        child: AppText(
          text: "Error: $errorMessage",
          style: AppTextStyles.headline1,
        ),
      );
    }
    if (noProductsMessage != null) {
      return Center(
        child: AppText(
          text: noProductsMessage!,
          style: AppTextStyles.headline1,
        ),
      );
    }
    return VerticalProductList(
      title: productListTitle,
      productCards: products.map((product) {
        return ProductCard(
          imageUrl: product.image,
          title: product.title,
          subtitle: "${product.price}",
          cardOrientation: Axis.horizontal,
          rating: product.rating.rate,
          onTap: onFilterSelected,
        );
      }).toList(),
    );
  }
}
