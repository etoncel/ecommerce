import 'package:ecommerce_sample_design_system/ecommerce_sample_design_system.dart';
import 'package:flutter/material.dart';

/// Plantilla que muestra una pantalla de resultados
/// del componente barra de búsqueda
class SearchPageTemplate extends StatelessWidget {
  static const categories = [
    "men's clothing",
    "jewerly",
    "electronics",
    "women's clothing",
  ];

  /// Texto que se ha ingresado en el buscador. Se utiliza
  /// para iniciar la búsqueda] de productos
  final String searchText;
  const SearchPageTemplate({super.key, required this.searchText});

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
                    constraints: BoxConstraints(maxWidth: 1200),
                    child: CustomAppBar(showSearchBar: true),
                  ),
                ),
              ],
            ),
            AppSpacing.verticalL,
            Expanded(
              child: Container(
                constraints: BoxConstraints(maxWidth: 1200),
                child: SingleChildScrollView(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 2,
                        child: SizedBox(
                          width: double.infinity,

                          child: Column(
                            children: [
                              AppText(
                                text: "Categories",
                                style: AppTextStyles.headline2,
                              ),
                              ...[
                                SizedBox(
                                  height: 400,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: categories.length,
                                    itemBuilder: (context, index) {
                                      return AppText(
                                        text: categories[index],
                                        style: AppTextStyles.caption,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ],
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
            ),
          ],
        ),
      ),
    );
  }
}
