import 'package:ecommerce_sample/src/presentation/templates/search/search_page_template_desktop.dart';
import 'package:ecommerce_sample/src/presentation/ui_models/category_quantity_ui_model.dart';
import 'package:ecommerce_sample/src/presentation/ui_models/product_ui_model.dart';
import 'package:ecommerce_sample/src/presentation/ui_models/rating_ui_model.dart';
import 'package:ecommerce_sample_design_system/ecommerce_sample_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SearchPageTemplateDesktop', () {
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

    testWidgets('should display sidebar layout structure with 2:6 flex ratio', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1600, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: SearchPageTemplateDesktop(
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
      expect(find.byType(VerticalProductList), findsOneWidget);

      // Verify sidebar layout with Row
      expect(find.byType(Row), findsAtLeastNWidgets(1));

      // Find the main layout Row (not the ones inside QuantityIndicator)
      final rows = tester.widgetList<Row>(find.byType(Row));
      final mainRow = rows.firstWhere(
        (row) => row.children.whereType<Flexible>().length == 2,
      );

      // Verify 2:6 flex ratio
      final flexibleWidgets = mainRow.children.whereType<Flexible>().toList();
      expect(flexibleWidgets.length, equals(2));
      expect(
        flexibleWidgets[0].flex,
        equals(2),
        reason: 'Sidebar should have flex: 2',
      );
      expect(
        flexibleWidgets[1].flex,
        equals(6),
        reason: 'Content should have flex: 6',
      );
    });

    testWidgets('should display CustomAppBar with search functionality', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1600, 800);
      tester.view.devicePixelRatio = 1.0;
      await tester.pumpWidget(
        MaterialApp(
          home: SearchPageTemplateDesktop(
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

    testWidgets('should NOT display FilterButton (mobile component)', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1600, 800);
      tester.view.devicePixelRatio = 1.0;
      await tester.pumpWidget(
        MaterialApp(
          home: SearchPageTemplateDesktop(
            searchController: searchController,
            onSearchSubmitted: (_) {},
            productListTitle: 'Search Results',
            products: mockProducts,
            categories: mockCategories,
          ),
        ),
      );

      // Critical assertion: FilterButton should NEVER be present on desktop
      expect(find.byType(FilterButton), findsNothing);
    });

    testWidgets(
      'should display sidebar with Categories title and QuantityIndicatorList',
      (tester) async {
        tester.view.physicalSize = const Size(1600, 800);
        tester.view.devicePixelRatio = 1.0;
        await tester.pumpWidget(
          MaterialApp(
            home: SearchPageTemplateDesktop(
              searchController: searchController,
              onSearchSubmitted: (_) {},
              productListTitle: 'Search Results',
              products: mockProducts,
              categories: mockCategories,
              selectedFilter: null,
            ),
          ),
        );

        // Verify sidebar elements
        expect(find.text('Categories'), findsOneWidget);
        expect(find.byType(QuantityIndicatorList), findsOneWidget);

        // Verify categories are displayed
        expect(find.text('Electronics'), findsOneWidget);
        expect(find.text('Clothing'), findsOneWidget);
        expect(find.text('Books'), findsOneWidget);
      },
    );

    testWidgets('should display AppIconButton when filter is selected', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1600, 800);
      tester.view.devicePixelRatio = 1.0;

      const selectedFilter = 'Electronics';

      await tester.pumpWidget(
        MaterialApp(
          home: SearchPageTemplateDesktop(
            searchController: searchController,
            onSearchSubmitted: (_) {},
            productListTitle: 'Search Results',
            products: mockProducts,
            categories: mockCategories,
            selectedFilter: selectedFilter,
          ),
        ),
      );

      // Verify AppIconButton is shown instead of QuantityIndicatorList
      expect(find.byType(AppIconButton), findsOneWidget);
      expect(find.byType(QuantityIndicatorList), findsNothing);
      expect(find.text(selectedFilter), findsOneWidget);
    });

    testWidgets('should display products in VerticalProductList', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1600, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: SearchPageTemplateDesktop(
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
      tester.view.physicalSize = const Size(1600, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: SearchPageTemplateDesktop(
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
      tester.view.physicalSize = const Size(1600, 800);
      tester.view.devicePixelRatio = 1.0;

      const errorMessage = 'Network error occurred';

      await tester.pumpWidget(
        MaterialApp(
          home: SearchPageTemplateDesktop(
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
        tester.view.physicalSize = const Size(1600, 800);
        tester.view.devicePixelRatio = 1.0;

        const noProductsMessage = 'No products found';

        await tester.pumpWidget(
          MaterialApp(
            home: SearchPageTemplateDesktop(
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
      tester.view.physicalSize = const Size(1600, 800);
      tester.view.devicePixelRatio = 1.0;

      String? submittedQuery;

      await tester.pumpWidget(
        MaterialApp(
          home: SearchPageTemplateDesktop(
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

    testWidgets('should call onFilterSelected when category is selected', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1600, 800);
      tester.view.devicePixelRatio = 1.0;

      int? selectedIndex;

      await tester.pumpWidget(
        MaterialApp(
          home: SearchPageTemplateDesktop(
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

      // Tap on the first category
      await tester.tap(find.text('Electronics'));
      await tester.pumpAndSettle();

      // Verify callback was called with correct index
      expect(selectedIndex, equals(0));
    });

    testWidgets(
      'should call onFilterUnselected when filter clear button is tapped',
      (tester) async {
        tester.view.physicalSize = const Size(1600, 800);
        tester.view.devicePixelRatio = 1.0;

        bool filterUnselected = false;

        await tester.pumpWidget(
          MaterialApp(
            home: SearchPageTemplateDesktop(
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

        // Find and tap the clear filter button (AppIconButton with close icon)
        await tester.tap(find.byType(AppIconButton));
        await tester.pumpAndSettle();

        // Verify callback was called
        expect(filterUnselected, isTrue);
      },
    );

    testWidgets('should preserve existing filter interactions and behaviors', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1600, 800);
      tester.view.devicePixelRatio = 1.0;

      int? selectedIndex;
      bool filterUnselected = false;

      await tester.pumpWidget(
        MaterialApp(
          home: SearchPageTemplateDesktop(
            searchController: searchController,
            onSearchSubmitted: (_) {},
            productListTitle: 'Search Results',
            products: mockProducts,
            categories: mockCategories,
            onFilterSelected: (index) {
              selectedIndex = index;
            },
            onFilterUnselected: () {
              filterUnselected = true;
            },
          ),
        ),
      );

      // Test filter selection
      await tester.tap(find.text('Clothing'));
      await tester.pumpAndSettle();
      expect(selectedIndex, equals(1));

      // Rebuild with selected filter
      await tester.pumpWidget(
        MaterialApp(
          home: SearchPageTemplateDesktop(
            searchController: searchController,
            onSearchSubmitted: (_) {},
            productListTitle: 'Search Results',
            products: mockProducts,
            categories: mockCategories,
            selectedFilter: 'Clothing',
            onFilterSelected: (index) {
              selectedIndex = index;
            },
            onFilterUnselected: () {
              filterUnselected = true;
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Test filter clearing
      await tester.tap(find.byType(AppIconButton));
      await tester.pumpAndSettle();
      expect(filterUnselected, isTrue);
    });
  });
}
