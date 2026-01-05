import 'package:ecommerce_sample/src/presentation/bloc/categories_section/categories_section_bloc.dart';
import 'package:ecommerce_sample/src/presentation/bloc/categories_section/categories_section_state.dart';
import 'package:ecommerce_sample/src/presentation/pages/category_products/category_products_page.dart';
import 'package:ecommerce_sample_design_system/ecommerce_sample_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesSectionBloc, CategoriesSectionState>(
      builder: (context, state) {
        if (state is CategoriesSectionInitial) {
          return Placeholder();
        }
        if (state is CategoriesSectionLoading) {
          return LinearProgressIndicator();
        }

        if (state is CategoriesSectionLoaded) {
          return SingleHorizontalList(
            items: state.categories
                .map(
                  (category) => SingleListItemData(
                    imageUrl: category.image,
                    itemName: category.name,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              CategoryProductsPage(categoryName: category.name),
                        ),
                      );
                    },
                  ),
                )
                .toList(),
            title: "Categorías",
          );
        }

        if (state is CategoriesSectionError) {
          return Text(state.message);
        }

        return SizedBox();
      },
    );
  }
}
