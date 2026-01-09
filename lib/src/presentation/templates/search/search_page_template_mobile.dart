import 'package:ecommerce_sample/src/presentation/ui_models/category_quantity_ui_model.dart';
import 'package:ecommerce_sample/src/presentation/ui_models/product_ui_model.dart';
import 'package:ecommerce_sample_design_system/ecommerce_sample_design_system.dart';
import 'package:flutter/material.dart';

/// Mobile template for search page that displays products with a filter button
/// that opens a modal for category selection.
///
/// This template provides a single-column layout optimized for mobile screens
/// with full-width product display and modal-based category filtering.
class SearchPageTemplateMobile extends StatelessWidget {
  /// Controller for the search bar
  final TextEditingController searchController;

  /// Callback function called when search is submitted
  final ValueChanged<String> onSearchSubmitted;

  /// Title for the product list
  final String productListTitle;

  /// List of products to display
  final List<ProductUiModel> products;

  /// List of categories with quantities for filtering
  final List<CategoryQuantityUiModel> categories;

  /// Currently selected filter category name, null if no filter selected
  final String? selectedFilter;

  /// Whether the page is currently loading
  final bool isLoading;

  /// Error message to display, if any
  final String? errorMessage;

  /// Message to display when no products are found
  final String? noProductsMessage;

  /// Callback function called when a filter is selected
  /// Returns the index of the selected category
  final Function(int)? onFilterSelected;

  /// Callback function called when the current filter should be cleared
  final VoidCallback? onFilterUnselected;

  /// Creates a SearchPageTemplateMobile widget
  const SearchPageTemplateMobile({
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          children: [
            // App bar with search functionality
            _buildAppBar(),

            // Filter button for mobile category selection
            _buildFilterButton(),

            // Main content area with full-width product list
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  /// Builds the app bar with search functionality
  Widget _buildAppBar() {
    return Stack(
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
    );
  }

  /// Builds the filter button that opens the category modal or clears active filter
  Widget _buildFilterButton() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.spaceM,
        vertical: AppSpacing.spaceS,
      ),
      child: Row(
        children: [
          Builder(
            builder: (context) => FilterButton(
              selectedFilter: selectedFilter,
              onTap: () {
                // If filter is active, clear it; otherwise open modal
                if (selectedFilter != null && selectedFilter!.isNotEmpty) {
                  onFilterUnselected?.call();
                } else {
                  _showFilterModal(context);
                }
              },
              hasActiveFilter:
                  selectedFilter != null && selectedFilter!.isNotEmpty,
            ),
          ),
        ],
      ),
    );
  }

  /// Shows the filter modal with category options
  void _showFilterModal(BuildContext context) {
    FilterModal.show(
      context: context,
      indicators: categories
          .map(
            (cat) => QuantityIndicator(name: cat.name, quantity: cat.quantity),
          )
          .toList(),
      selectedFilter: selectedFilter,
      onIndicatorSelected: onFilterSelected,
      onFilterUnselected: onFilterUnselected,
    );
  }

  /// Builds the main content area with product list or loading/error states
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

    return SingleChildScrollView(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.spaceM),
          child: VerticalProductList(
            title: productListTitle,
            productCards: products.map((product) {
              return ProductCard(
                imageUrl: product.image,
                title: product.title,
                subtitle: "${product.price}",
                cardOrientation: Axis.horizontal,
                rating: product.rating.rate,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
