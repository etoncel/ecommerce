import 'package:ecommerce_sample/src/presentation/ui_models/product_ui_model.dart';
import 'package:ecommerce_sample_design_system/ecommerce_sample_design_system.dart';
import 'package:flutter/material.dart';

/// Template widget for displaying products filtered by category.
/// Uses existing design system components for consistent UI.
class CategoryProductsTemplate extends StatelessWidget {
  /// The name of the category being displayed
  final String categoryName;

  /// List of products to display
  final List<ProductUiModel> products;

  /// Whether the products are currently loading
  final bool isLoading;

  /// Error message to display if an error occurred
  final String? errorMessage;

  const CategoryProductsTemplate({
    super.key,
    required this.categoryName,
    required this.products,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: '$categoryName Products',
        leading: AppIcon(iconData: AppIcons.arrowBack),
        onTapLeadingButton: () => Navigator.pop(context),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.spaceL),
          child: AppText(
            text: 'Error: $errorMessage',
            style: AppTextStyles.headline2,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.spaceL),
          child: AppText(
            text: 'No products found in this category',
            style: AppTextStyles.headline2,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Container(
      constraints: const BoxConstraints(maxWidth: 1200),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.spaceL),
        child: VerticalProductList(
          title: '$categoryName Products',
          productCards: products.map((product) {
            return ProductCard(
              imageUrl: product.image,
              title: product.title,
              subtitle: '\$${product.price.toStringAsFixed(2)}',
              cardOrientation: Axis.horizontal,
              rating: product.rating.rate,
            );
          }).toList(),
        ),
      ),
    );
  }
}
