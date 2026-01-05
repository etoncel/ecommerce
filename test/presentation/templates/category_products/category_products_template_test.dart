import 'dart:math';

import 'package:ecommerce_sample/src/presentation/templates/category_products/category_products_template.dart';
import 'package:ecommerce_sample/src/presentation/ui_models/product_ui_model.dart';
import 'package:ecommerce_sample/src/presentation/ui_models/rating_ui_model.dart';
import 'package:ecommerce_sample_design_system/ecommerce_sample_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CategoryProductsTemplate Property Tests', () {
    // **Feature: category-filtered-products, Property 3: Page Title Display**
    // **Validates: Requirements 1.4**
    testWidgets(
      'Property 3: Page Title Display - For any category name, when the CategoryProductsTemplate is displayed, the page title should contain the category name',
      (WidgetTester tester) async {
        // Property-based test with multiple iterations
        final random = Random();

        for (int iteration = 0; iteration < 100; iteration++) {
          // Generate random category names
          final categories = [
            'electronics',
            'clothing',
            'jewelery',
            'books',
            'sports',
            'home',
            'garden',
            'toys',
            'automotive',
            'health',
          ];
          final categoryName = categories[random.nextInt(categories.length)];

          // Generate random products for the category
          final products = List.generate(random.nextInt(5) + 1, (index) {
            return ProductUiModel(
              id: index,
              title: 'Product $index',
              price: random.nextDouble() * 100,
              description: 'Description $index',
              category: categoryName,
              image: 'image$index.jpg',
              rating: RatingUiModel(
                rate: random.nextDouble() * 5,
                count: random.nextInt(1000),
              ),
            );
          });

          // Build the widget
          await tester.pumpWidget(
            MaterialApp(
              home: CategoryProductsTemplate(
                categoryName: categoryName,
                products: products,
                isLoading: false,
              ),
            ),
          );

          // Assert that the title contains the category name in the AppBar
          final expectedTitle = '$categoryName Products';

          // Find the AppBar specifically
          final appBarFinder = find.byType(AppBar);
          expect(appBarFinder, findsOneWidget);

          // Check that the title text exists (allowing for multiple instances)
          expect(find.text(expectedTitle), findsAtLeastNWidgets(1));

          // Clean up for next iteration
          await tester.pumpAndSettle();
        }
      },
    );

    // **Feature: category-filtered-products, Property 5: Product List Display**
    // **Validates: Requirements 2.3**
    testWidgets(
      'Property 5: Product List Display - For any non-empty list of products, they should be displayed in a scrollable vertical list format',
      (WidgetTester tester) async {
        // Property-based test with multiple iterations
        final random = Random();

        for (int iteration = 0; iteration < 100; iteration++) {
          // Generate random category name
          final categories = [
            'electronics',
            'clothing',
            'jewelery',
            'books',
            'sports',
          ];
          final categoryName = categories[random.nextInt(categories.length)];

          // Generate random non-empty list of products
          final productCount = random.nextInt(10) + 1; // At least 1 product
          final products = List.generate(productCount, (index) {
            return ProductUiModel(
              id: index,
              title: 'Product $index',
              price: random.nextDouble() * 200,
              description: 'Description $index',
              category: categoryName,
              image: 'image$index.jpg',
              rating: RatingUiModel(
                rate: random.nextDouble() * 5,
                count: random.nextInt(1000),
              ),
            );
          });

          // Build the widget
          await tester.pumpWidget(
            MaterialApp(
              home: CategoryProductsTemplate(
                categoryName: categoryName,
                products: products,
                isLoading: false,
              ),
            ),
          );

          // Assert that products are displayed in a scrollable list
          // Check for SingleChildScrollView (scrollable)
          expect(find.byType(SingleChildScrollView), findsOneWidget);

          // Check for VerticalProductList
          expect(find.byType(VerticalProductList), findsOneWidget);

          // Verify that product cards are displayed
          // Note: ProductCard widgets might not all be visible due to scrolling
          final productCardFinder = find.byType(ProductCard);
          expect(productCardFinder, findsAtLeastNWidgets(1));

          // Clean up for next iteration
          await tester.pumpAndSettle();
        }
      },
    );

    // **Feature: category-filtered-products, Property 8: Product Information Display**
    // **Validates: Requirements 4.1**
    testWidgets(
      'Property 8: Product Information Display - For any product in the category list, the display should include product image, title, rating and price',
      (WidgetTester tester) async {
        // Property-based test with multiple iterations
        final random = Random();

        for (int iteration = 0; iteration < 100; iteration++) {
          // Generate random category name
          final categories = [
            'electronics',
            'clothing',
            'jewelery',
            'books',
            'sports',
          ];
          final categoryName = categories[random.nextInt(categories.length)];

          // Generate a single product to test information display
          final product = ProductUiModel(
            id: 1,
            title: 'Test Product ${random.nextInt(1000)}',
            price: random.nextDouble() * 200 + 1, // Ensure price > 0
            description: 'Test Description',
            category: categoryName,
            image: 'test_image.jpg',
            rating: RatingUiModel(
              rate: random.nextDouble() * 5,
              count: random.nextInt(1000),
            ),
          );

          // Build the widget with single product
          await tester.pumpWidget(
            MaterialApp(
              home: CategoryProductsTemplate(
                categoryName: categoryName,
                products: [product],
                isLoading: false,
              ),
            ),
          );

          // Assert that product information is displayed
          // Check for product title
          expect(find.text(product.title), findsOneWidget);

          // Check for product price (formatted as currency)
          final expectedPrice = '\$${product.price.toStringAsFixed(2)}';
          expect(find.text(expectedPrice), findsOneWidget);

          // Check for ProductCard which contains the image and rating
          expect(find.byType(ProductCard), findsOneWidget);

          // Check for ProductRating component (rating display)
          expect(find.byType(ProductRating), findsOneWidget);

          // Clean up for next iteration
          await tester.pumpAndSettle();
        }
      },
    );
  });

  group('CategoryProductsTemplate Edge Cases', () {
    testWidgets(
      'should display "No products found" message when products list is empty',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: CategoryProductsTemplate(
              categoryName: 'electronics',
              products: [],
              isLoading: false,
            ),
          ),
        );

        expect(find.text('No products found in this category'), findsOneWidget);
      },
    );

    testWidgets('should display loading indicator when isLoading is true', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CategoryProductsTemplate(
            categoryName: 'electronics',
            products: [],
            isLoading: true,
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display error message when errorMessage is provided', (
      WidgetTester tester,
    ) async {
      const errorMessage = 'Network connection failed';

      await tester.pumpWidget(
        MaterialApp(
          home: CategoryProductsTemplate(
            categoryName: 'electronics',
            products: [],
            isLoading: false,
            errorMessage: errorMessage,
          ),
        ),
      );

      expect(find.text('Error: $errorMessage'), findsOneWidget);
    });
  });
}
