import 'package:ecommerce_sample/src/presentation/templates/search/search_page_template_mobile.dart';
import 'package:ecommerce_sample/src/presentation/ui_models/category_quantity_ui_model.dart';
import 'package:ecommerce_sample/src/presentation/ui_models/product_ui_model.dart';
import 'package:ecommerce_sample/src/presentation/ui_models/rating_ui_model.dart';
import 'package:ecommerce_sample_design_system/ecommerce_sample_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SearchPageTemplateMobile', () {
    late TextEditingController searchController;
    late List<ProductUiModel> mockProducts;
    late List<CategoryQuantityUiModel> mockCategories;

    setUp(() {
      searchController = TextEditingController();
      mockProducts = [
        ProductUiModel(
          id: 1,
          title: 'Product 1',
          price: 10.00,
          description: 'Description 1',
          category: 'Electronics',
          image: 'https://example.com/image1.jpg',
          rating: const RatingUiModel(rate: 4.5, count: 100),
        ),
        ProductUiModel(
          id: 2,
          title: 'Product 2',
          price: 20.00,
          description: 'Description 2',
          category: 'Clothing',
          image: 'https://example.com/image2.jpg',
          rating: const RatingUiModel(rate: 3.8, count: 50),
        ),
      ];
      mockCategories = [
        const CategoryQuantityUiModel(name: 'Electronics', quantity: 10),
        const CategoryQuantityUiModel(name: 'Clothing', quantity: 5),
        const CategoryQuantityUiModel(name: 'Books', quantity: 8),
      ];
    });

    tearDown(() {
      searchController.dispose();
    });

    testWidgets('should display basic layout structure', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SearchPageTemplateMobile(
            searchController: searchController,
            onSearchSubmitted: (_) {},
            productListTitle: 'Search Results',
            products: mockProducts,
            categories: mockCategories,
          ),
        ),
      );

      // Verify basic structure
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(CustomAppBar), findsOneWidget);
      expect(find.byType(FilterButton), findsOneWidget);
      expect(find.byType(VerticalProductList), findsOneWidget);
    });

    testWidgets('should display CustomAppBar with search functionality', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SearchPageTemplateMobile(
            searchController: searchController,
            onSearchSubmitted: (_) {},
            productListTitle: 'Search Results',
            products: mockProducts,
            categories: mockCategories,
          ),
        ),
      );

      // Verify CustomAppBar is present and configured correctly
      final customAppBar = tester.widget<CustomAppBar>(
        find.byType(CustomAppBar),
      );
      expect(customAppBar.showSearchBar, isTrue);
      expect(customAppBar.searchController, equals(searchController));
    });

    testWidgets(
      'should display FilterButton with correct state when no filter selected',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: SearchPageTemplateMobile(
              searchController: searchController,
              onSearchSubmitted: (_) {},
              productListTitle: 'Search Results',
              products: mockProducts,
              categories: mockCategories,
              selectedFilter: null,
            ),
          ),
        );

        // Verify FilterButton is present and shows default state
        final filterButton = tester.widget<FilterButton>(
          find.byType(FilterButton),
        );
        expect(filterButton.selectedFilter, isNull);
        expect(filterButton.hasActiveFilter, isFalse);
      },
    );

    testWidgets(
      'should display FilterButton with active state when filter selected',
      (tester) async {
        const selectedFilter = 'Electronics';

        await tester.pumpWidget(
          MaterialApp(
            home: SearchPageTemplateMobile(
              searchController: searchController,
              onSearchSubmitted: (_) {},
              productListTitle: 'Search Results',
              products: mockProducts,
              categories: mockCategories,
              selectedFilter: selectedFilter,
            ),
          ),
        );

        // Verify FilterButton shows active state
        final filterButton = tester.widget<FilterButton>(
          find.byType(FilterButton),
        );
        expect(filterButton.selectedFilter, equals(selectedFilter));
        expect(filterButton.hasActiveFilter, isTrue);
      },
    );

    testWidgets('should open FilterModal when FilterButton is tapped', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SearchPageTemplateMobile(
            searchController: searchController,
            onSearchSubmitted: (_) {},
            productListTitle: 'Search Results',
            products: mockProducts,
            categories: mockCategories,
            onFilterSelected: (_) {},
          ),
        ),
      );

      // Tap the FilterButton
      await tester.tap(find.byType(FilterButton));
      await tester.pumpAndSettle();

      // Verify modal is opened (FilterModal should be present in widget tree)
      expect(find.byType(FilterModal), findsOneWidget);
    });

    testWidgets('should pass correct categories to FilterModal', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SearchPageTemplateMobile(
            searchController: searchController,
            onSearchSubmitted: (_) {},
            productListTitle: 'Search Results',
            products: mockProducts,
            categories: mockCategories,
          ),
        ),
      );

      // Tap the FilterButton to open modal
      await tester.tap(find.byType(FilterButton));
      await tester.pumpAndSettle();

      // Verify FilterModal receives correct categories (converted to QuantityIndicator)
      final filterModal = tester.widget<FilterModal>(find.byType(FilterModal));
      expect(filterModal.indicators.length, equals(mockCategories.length));
      expect(filterModal.indicators[0].name, equals('Electronics'));
      expect(filterModal.indicators[0].quantity, equals(10));
    });

    testWidgets('should display products in VerticalProductList', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SearchPageTemplateMobile(
            searchController: searchController,
            onSearchSubmitted: (_) {},
            productListTitle: 'Search Results',
            products: mockProducts,
            categories: mockCategories,
          ),
        ),
      );

      // Verify VerticalProductList is present and contains products
      final verticalProductList = tester.widget<VerticalProductList>(
        find.byType(VerticalProductList),
      );
      expect(verticalProductList.title, equals('Search Results'));
      expect(
        verticalProductList.productCards.length,
        equals(mockProducts.length),
      );
    });

    testWidgets('should display loading indicator when isLoading is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SearchPageTemplateMobile(
            searchController: searchController,
            onSearchSubmitted: (_) {},
            productListTitle: 'Search Results',
            products: mockProducts,
            categories: mockCategories,
            isLoading: true,
          ),
        ),
      );

      // Verify loading indicator is shown
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(VerticalProductList), findsNothing);
    });

    testWidgets('should display error message when errorMessage is provided', (
      tester,
    ) async {
      const errorMessage = 'Network error occurred';

      await tester.pumpWidget(
        MaterialApp(
          home: SearchPageTemplateMobile(
            searchController: searchController,
            onSearchSubmitted: (_) {},
            productListTitle: 'Search Results',
            products: mockProducts,
            categories: mockCategories,
            errorMessage: errorMessage,
          ),
        ),
      );

      // Verify error message is displayed
      expect(find.text('Error: $errorMessage'), findsOneWidget);
      expect(find.byType(VerticalProductList), findsNothing);
    });

    testWidgets(
      'should display no products message when noProductsMessage is provided',
      (tester) async {
        const noProductsMessage = 'No products found';

        await tester.pumpWidget(
          MaterialApp(
            home: SearchPageTemplateMobile(
              searchController: searchController,
              onSearchSubmitted: (_) {},
              productListTitle: 'Search Results',
              products: mockProducts,
              categories: mockCategories,
              noProductsMessage: noProductsMessage,
            ),
          ),
        );

        // Verify no products message is displayed
        expect(find.text(noProductsMessage), findsOneWidget);
        expect(find.byType(VerticalProductList), findsNothing);
      },
    );

    testWidgets('should call onSearchSubmitted when search is submitted', (
      tester,
    ) async {
      String? submittedQuery;

      await tester.pumpWidget(
        MaterialApp(
          home: SearchPageTemplateMobile(
            searchController: searchController,
            onSearchSubmitted: (query) {
              submittedQuery = query;
            },
            productListTitle: 'Search Results',
            products: mockProducts,
            categories: mockCategories,
          ),
        ),
      );

      // Find the search input field and enter text
      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'test query');
      await tester.pump();

      // Find and tap the search button
      final searchButton = find.text('Search');
      await tester.tap(searchButton);
      await tester.pumpAndSettle();

      // Verify callback was called with correct query
      expect(submittedQuery, equals('test query'));
    });

    testWidgets(
      'should call onFilterSelected when filter is selected in modal',
      (tester) async {
        int? selectedIndex;

        await tester.pumpWidget(
          MaterialApp(
            home: SearchPageTemplateMobile(
              searchController: searchController,
              onSearchSubmitted: (_) {},
              productListTitle: 'Search Results',
              products: mockProducts,
              categories: mockCategories,
              onFilterSelected: (index) {
                selectedIndex = index;
              },
            ),
          ),
        );

        // Open the modal
        await tester.tap(find.byType(FilterButton));
        await tester.pumpAndSettle();

        // Tap on the first category in the modal
        await tester.tap(find.text('Electronics'));
        await tester.pumpAndSettle();

        // Verify callback was called with correct index
        expect(selectedIndex, equals(0));
      },
    );

    testWidgets('should call onFilterUnselected when filter is cleared', (
      tester,
    ) async {
      bool filterUnselected = false;

      await tester.pumpWidget(
        MaterialApp(
          home: SearchPageTemplateMobile(
            searchController: searchController,
            onSearchSubmitted: (_) {},
            productListTitle: 'Search Results',
            products: mockProducts,
            categories: mockCategories,
            selectedFilter: 'Electronics',
            onFilterUnselected: () {
              filterUnselected = true;
            },
          ),
        ),
      );

      // Tap the FilterButton directly (which has active filter, so it should clear)
      await tester.tap(find.byType(FilterButton));
      await tester.pumpAndSettle();

      // Verify callback was called (filter should be cleared directly)
      expect(filterUnselected, isTrue);
    });
  });
}
