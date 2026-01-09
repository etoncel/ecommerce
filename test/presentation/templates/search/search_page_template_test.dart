import 'package:ecommerce_sample/src/presentation/templates/search/search_page_template.dart';
import 'package:ecommerce_sample/src/presentation/templates/search/search_page_template_desktop.dart';
import 'package:ecommerce_sample/src/presentation/templates/search/search_page_template_mobile.dart';
import 'package:ecommerce_sample/src/presentation/ui_models/category_quantity_ui_model.dart';
import 'package:ecommerce_sample/src/presentation/ui_models/product_ui_model.dart';
import 'package:ecommerce_sample/src/presentation/ui_models/rating_ui_model.dart';
import 'package:ecommerce_sample_design_system/ecommerce_sample_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SearchPageTemplate - Responsive Coordinator', () {
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
      ];
      mockCategories = [
        const CategoryQuantityUiModel(name: 'Electronics', quantity: 10),
        const CategoryQuantityUiModel(name: 'Clothing', quantity: 5),
      ];
    });

    tearDown(() {
      searchController.dispose();
    });

    group('Property 2: Dynamic Layout Switching', () {
      testWidgets(
        'Feature: adaptive-search-filters, Property 2: For any screen size change, the SearchPage should automatically switch between mobile and desktop layouts while maintaining current search state and selected filters',
        (tester) async {
          // Test multiple screen sizes to verify dynamic switching
          final testSizes = [
            const Size(400, 800), // Mobile
            const Size(800, 600), // Desktop
            const Size(600, 800), // Mobile (portrait tablet)
            const Size(1200, 800), // Large desktop
            const Size(767, 600), // Just below mobile breakpoint
            const Size(768, 600), // Exactly at breakpoint
          ];

          for (final size in testSizes) {
            tester.view.physicalSize = size;
            tester.view.devicePixelRatio = 1.0;

            await tester.pumpWidget(
              MaterialApp(
                home: SearchPageTemplate(
                  searchController: searchController,
                  onSearchSubmitted: (_) {},
                  productListTitle: 'Search Results',
                  products: mockProducts,
                  categories: mockCategories,
                  selectedFilter: 'Electronics', // Maintain filter state
                ),
              ),
            );

            await tester.pump();

            // Verify correct template is used based on screen size
            if (size.width < 768) {
              // Should use mobile template
              expect(
                find.byType(SearchPageTemplateMobile),
                findsOneWidget,
                reason:
                    'Mobile template should be used for width ${size.width}',
              );
              expect(
                find.byType(SearchPageTemplateDesktop),
                findsNothing,
                reason:
                    'Desktop template should not be used for width ${size.width}',
              );
            } else {
              // Should use desktop template
              expect(
                find.byType(SearchPageTemplateDesktop),
                findsOneWidget,
                reason:
                    'Desktop template should be used for width ${size.width}',
              );
              expect(
                find.byType(SearchPageTemplateMobile),
                findsNothing,
                reason:
                    'Mobile template should not be used for width ${size.width}',
              );
            }

            // Verify filter state is maintained across layout switches
            expect(
              find.text('Electronics'),
              findsAtLeastNWidgets(1),
              reason:
                  'Selected filter should be maintained across layout switches',
            );
          }
        },
      );

      testWidgets(
        'should maintain search controller state across layout switches',
        (tester) async {
          // Start with mobile layout
          tester.view.physicalSize = const Size(400, 800);
          tester.view.devicePixelRatio = 1.0;

          await tester.pumpWidget(
            MaterialApp(
              home: SearchPageTemplate(
                searchController: searchController,
                onSearchSubmitted: (_) {},
                productListTitle: 'Search Results',
                products: mockProducts,
                categories: mockCategories,
              ),
            ),
          );

          // Enter text in search field
          final searchField = find.byType(TextField);
          await tester.enterText(searchField, 'test search');
          await tester.pump();

          // Switch to desktop layout
          tester.view.physicalSize = const Size(1200, 800);
          await tester.pump();

          // Verify search text is maintained
          expect(searchController.text, equals('test search'));
          expect(find.text('test search'), findsOneWidget);
        },
      );

      testWidgets('should maintain loading state across layout switches', (
        tester,
      ) async {
        // Test with loading state
        tester.view.physicalSize = const Size(400, 800); // Mobile
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          MaterialApp(
            home: SearchPageTemplate(
              searchController: searchController,
              onSearchSubmitted: (_) {},
              productListTitle: 'Search Results',
              products: mockProducts,
              categories: mockCategories,
              isLoading: true,
            ),
          ),
        );

        // Verify loading indicator on mobile
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // Switch to desktop
        tester.view.physicalSize = const Size(1200, 800);
        await tester.pump();

        // Verify loading indicator is still shown on desktop
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('should maintain error state across layout switches', (
        tester,
      ) async {
        const errorMessage = 'Network error';

        // Test with error state
        tester.view.physicalSize = const Size(400, 800); // Mobile
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          MaterialApp(
            home: SearchPageTemplate(
              searchController: searchController,
              onSearchSubmitted: (_) {},
              productListTitle: 'Search Results',
              products: mockProducts,
              categories: mockCategories,
              errorMessage: errorMessage,
            ),
          ),
        );

        // Verify error message on mobile
        expect(find.text('Error: $errorMessage'), findsOneWidget);

        // Switch to desktop
        tester.view.physicalSize = const Size(1200, 800);
        await tester.pump();

        // Verify error message is still shown on desktop
        expect(find.text('Error: $errorMessage'), findsOneWidget);
      });
    });

    group('Property 9: Filter State Consistency', () {
      testWidgets(
        'Feature: adaptive-search-filters, Property 9: For any filter clearing action in any layout, the filter state should be cleared consistently across all layouts',
        (tester) async {
          bool filterUnselected = false;
          int? selectedIndex;

          // Test filter clearing from mobile layout
          tester.view.physicalSize = const Size(600, 800); // Mobile
          tester.view.devicePixelRatio = 1.0;

          await tester.pumpWidget(
            MaterialApp(
              home: SearchPageTemplate(
                searchController: searchController,
                onSearchSubmitted: (_) {},
                productListTitle: 'Search Results',
                products: mockProducts,
                categories: mockCategories,
                selectedFilter: 'Electronics', // Start with filter selected
                onFilterSelected: (index) => selectedIndex = index,
                onFilterUnselected: () => filterUnselected = true,
              ),
            ),
          );

          // Verify filter is shown in mobile layout
          expect(find.text('Electronics'), findsAtLeastNWidgets(1));

          // Clear filter by tapping FilterButton (which shows selected filter with close icon)
          final filterButton = find.byWidgetPredicate(
            (widget) =>
                widget is FilterButton &&
                widget.selectedFilter == 'Electronics',
          );
          expect(filterButton, findsOneWidget);
          await tester.tap(filterButton);
          await tester.pumpAndSettle();

          // Verify callback was called
          expect(
            filterUnselected,
            isTrue,
            reason:
                'Filter unselected callback should be called when tapping active FilterButton',
          );

          // Reset callback state for next test
          filterUnselected = false;

          // Switch to desktop layout with no filter
          tester.view.physicalSize = const Size(1200, 800); // Desktop
          await tester.pump();

          await tester.pumpWidget(
            MaterialApp(
              home: SearchPageTemplate(
                searchController: searchController,
                onSearchSubmitted: (_) {},
                productListTitle: 'Search Results',
                products: mockProducts,
                categories: mockCategories,
                selectedFilter: null, // No filter selected
                onFilterSelected: (index) => selectedIndex = index,
                onFilterUnselected: () => filterUnselected = true,
              ),
            ),
          );

          // Verify no filter is shown in desktop layout
          expect(find.byType(QuantityIndicatorList), findsOneWidget);
          expect(find.byType(AppIconButton), findsNothing);

          // Select a filter in desktop layout
          await tester.tap(find.text('Clothing'));
          await tester.pump();

          // Verify callback was called
          expect(
            selectedIndex,
            equals(1),
            reason: 'Clothing should be at index 1',
          ); // Clothing is at index 1

          // Rebuild with selected filter
          await tester.pumpWidget(
            MaterialApp(
              home: SearchPageTemplate(
                searchController: searchController,
                onSearchSubmitted: (_) {},
                productListTitle: 'Search Results',
                products: mockProducts,
                categories: mockCategories,
                selectedFilter: 'Clothing', // Filter selected
                onFilterSelected: (index) => selectedIndex = index,
                onFilterUnselected: () => filterUnselected = true,
              ),
            ),
          );

          // Clear filter in desktop layout
          await tester.tap(find.byType(AppIconButton));
          await tester.pump();

          // Verify callback was called
          expect(
            filterUnselected,
            isTrue,
            reason: 'Filter should be cleared in desktop layout',
          );

          // Reset and switch back to mobile to verify consistency
          filterUnselected = false;
          tester.view.physicalSize = const Size(400, 800); // Mobile
          await tester.pump();

          await tester.pumpWidget(
            MaterialApp(
              home: SearchPageTemplate(
                searchController: searchController,
                onSearchSubmitted: (_) {},
                productListTitle: 'Search Results',
                products: mockProducts,
                categories: mockCategories,
                selectedFilter: null, // No filter (cleared state)
                onFilterSelected: (index) => selectedIndex = index,
                onFilterUnselected: () => filterUnselected = true,
              ),
            ),
          );

          // Verify no filter is shown in mobile layout (consistent with desktop clearing)
          final filterButtonWidget = tester.widget<FilterButton>(
            find.byType(FilterButton),
          );
          expect(filterButtonWidget.selectedFilter, isNull);
          expect(filterButtonWidget.hasActiveFilter, isFalse);
        },
      );

      testWidgets(
        'should maintain filter selection consistency across layout switches',
        (tester) async {
          // Start with mobile layout and select a filter
          tester.view.physicalSize = const Size(400, 800); // Mobile
          tester.view.devicePixelRatio = 1.0;

          await tester.pumpWidget(
            MaterialApp(
              home: SearchPageTemplate(
                searchController: searchController,
                onSearchSubmitted: (_) {},
                productListTitle: 'Search Results',
                products: mockProducts,
                categories: mockCategories,
                selectedFilter: 'Electronics',
              ),
            ),
          );

          // Verify filter is shown in mobile (FilterButton shows selected filter)
          final filterButton = tester.widget<FilterButton>(
            find.byType(FilterButton),
          );
          expect(filterButton.selectedFilter, equals('Electronics'));
          expect(filterButton.hasActiveFilter, isTrue);
          expect(find.byType(SearchPageTemplateMobile), findsOneWidget);

          // Switch to desktop layout
          tester.view.physicalSize = const Size(1200, 800); // Desktop
          await tester.pump();

          // Verify same filter is shown in desktop (AppIconButton with filter name)
          expect(find.byType(AppIconButton), findsOneWidget);
          expect(find.text('Electronics'), findsOneWidget);
          expect(find.byType(QuantityIndicatorList), findsNothing);
          expect(find.byType(SearchPageTemplateDesktop), findsOneWidget);

          // Switch back to mobile
          tester.view.physicalSize = const Size(400, 800); // Mobile
          await tester.pump();

          // Verify filter is still maintained
          final filterButtonAfter = tester.widget<FilterButton>(
            find.byType(FilterButton),
          );
          expect(filterButtonAfter.selectedFilter, equals('Electronics'));
          expect(filterButtonAfter.hasActiveFilter, isTrue);
        },
      );
    });
  });
}
