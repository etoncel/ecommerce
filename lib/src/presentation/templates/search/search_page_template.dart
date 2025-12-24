import 'package:ecommerce_sample_design_system/ecommerce_sample_design_system.dart';
import 'package:flutter/material.dart';

/// Plantilla que muestra una pantalla de resultados
/// del componente barra de búsqueda
class SearchPageTemplate extends StatelessWidget {
  /// Texto que se ha ingresado en el buscador. Se utiliza
  /// para iniciar la búsqueda] de productos
  final String searchText;
  const SearchPageTemplate({super.key, required this.searchText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomAppBar(showSearchBar: true),
              AppSpacing.verticalL,
              Expanded(
                child: SingleChildScrollView(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 2,
                        child: SizedBox(
                          width: double.infinity,
                          height: 400,
                          child: AppText(
                            text: "Categories",
                            style: AppTextStyles.headline2,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 6,
                        child: VerticalProductList(
                          title: "Lista",
                          productCards: List.generate(20, (index) {
                            return ProductCard(
                              imageUrl: '',
                              title: 'Prod $index',
                              subtitle: 'subtitle',
                              cardOrientation: Axis.horizontal,
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
