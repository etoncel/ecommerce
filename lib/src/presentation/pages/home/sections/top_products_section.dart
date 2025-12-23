import 'package:ecommerce_sample/src/presentation/bloc/product/product_bloc.dart';
import 'package:ecommerce_sample/src/presentation/bloc/product/product_state.dart';
import 'package:ecommerce_sample_design_system/ecommerce_sample_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopProductsSection extends StatelessWidget {
  const TopProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductInitial) {
          return Placeholder();
        }
        if (state is ProductLoading) {
          return LinearProgressIndicator();
        }

        if (state is AllProductsLoaded) {
          return HorizontalProductList(
            productCards: state.products
                .where((product) => product.rating.rate >= 4.0)
                .map(
                  (product) => ProductCard(
                    imageUrl: product.image,
                    title: product.title,
                    subtitle: "${product.price}",
                    rating: product.rating.rate,
                  ),
                )
                .toList(),
            title: "Productos Destacados",
          );
        }

        if (state is ProductError) {
          return Text(state.message);
        }

        return SizedBox();
      },
    );
  }
}
