import 'package:dartz/dartz.dart';
import 'package:ecommerce_package_sample/ecommerce_package_sample.dart';
import 'package:ecommerce_sample/src/presentation/bloc/categories_section/categories_section_bloc.dart';
import 'package:ecommerce_sample/src/presentation/bloc/categories_section/categories_section_state.dart';
import 'package:ecommerce_sample/src/presentation/pages/category_products/category_products_page.dart';
import 'package:ecommerce_sample/src/presentation/pages/home/sections/categories_section.dart';
import 'package:ecommerce_sample/src/presentation/templates/category_products/category_products_template.dart';
import 'package:ecommerce_sample/src/presentation/ui_models/category_ui_model.dart';
import 'package:ecommerce_sample_design_system/ecommerce_sample_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks/blocs_mocks.dart';
import '../mocks/use_cases_mocks.dart';

void main() {
  late MockGetAllProductsUseCase mockGetAllProductsUseCase;
  late MockCategoriesSectionBloc mockCategoriesSectionBloc;

  setUp(() {
    mockGetAllProductsUseCase = MockGetAllProductsUseCase();
    mockCategoriesSectionBloc = MockCategoriesSectionBloc();

    // Register ServiceLocator mock
    if (!ServiceLocator.instance.isRegistered<GetAllProductsUseCase>()) {
      ServiceLocator.instance.registerFactory<GetAllProductsUseCase>(
        () => mockGetAllProductsUseCase,
      );
    }
  });

  tearDown(() {
    // Clean up ServiceLocator after each test
    if (ServiceLocator.instance.isRegistered<GetAllProductsUseCase>()) {
      ServiceLocator.instance.unregister<GetAllProductsUseCase>();
    }
  });

  group('Category Products Integration Tests', () {
    /// Integration test for complete navigation flow from home to category products and back
    /// **Validates: Requirements 3.2, 5.4, 5.5**
    testWidgets(
      'should complete full navigation flow from categories to products and back',
      (WidgetTester tester) async {
        // Arrange - Setup test data
        const categoryName = 'electronics';
        final mockCategories = [
          CategoryUiModel(
            id: 1,
            name: categoryName,
            image: 'https://example.com/electronics.jpg',
            quantity: 3,
          ),
          CategoryUiModel(
            id: 2,
            name: 'clothing',
            image: 'https://example.com/clothing.jpg',
            quantity: 2,
          ),
        ];

        final mockProducts = [
          ProductEntity(
            id: 1,
            title: 'Smartphone',
            price: 599.99,
            description: 'Latest smartphone',
            category: categoryName,
            image: 'https://example.com/phone.jpg',
            rating: RatingEntity(rate: 4.5, count: 150),
          ),
          ProductEntity(
            id: 2,
            title: 'Laptop',
            price: 999.99,
            description: 'Gaming laptop',
            category: categoryName,
            image: 'https://example.com/laptop.jpg',
            rating: RatingEntity(rate: 4.8, count: 89),
          ),
          ProductEntity(
            id: 3,
            title: 'T-Shirt',
            price: 19.99,
            description: 'Cotton t-shirt',
            category: 'clothing',
            image: 'https://example.com/tshirt.jpg',
            rating: RatingEntity(rate: 4.2, count: 45),
          ),
        ];

        // Setup mocks
        when(
          () => mockCategoriesSectionBloc.state,
        ).thenReturn(CategoriesSectionLoaded(mockCategories));

        when(
          () => mockGetAllProductsUseCase.call(),
        ).thenAnswer((_) async => Right(mockProducts));

        // Act & Assert - Build the home page with categories section
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              appBar: AppBar(title: const Text('Home Page')),
              body: BlocProvider<CategoriesSectionBloc>.value(
                value: mockCategoriesSectionBloc,
                child: const CategoriesSection(),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify home page is displayed with categories
        expect(find.text('Home Page'), findsOneWidget);
        expect(find.text(categoryName), findsOneWidget);
        expect(find.text('clothing'), findsOneWidget);

        // Step 1: Navigate to category products page
        await tester.tap(find.text(categoryName));
        await tester.pumpAndSettle();

        // Verify navigation to CategoryProductsPage occurred
        expect(find.byType(CategoryProductsPage), findsOneWidget);
        expect(find.byType(CategoryProductsTemplate), findsOneWidget);

        // Verify category name is displayed in the page (appears in both AppBar and body)
        expect(find.text('$categoryName Products'), findsAtLeastNWidgets(1));

        // Verify only electronics products are displayed (filtered correctly)
        expect(find.text('Smartphone'), findsOneWidget);
        expect(find.text('Laptop'), findsOneWidget);
        expect(
          find.text('T-Shirt'),
          findsNothing,
        ); // Should not show clothing item

        // Verify product information is displayed correctly
        expect(find.text('\$599.99'), findsOneWidget);
        expect(find.text('\$999.99'), findsOneWidget);

        // Step 2: Navigate back using back button
        final backButton = find.byWidgetPredicate(
          (widget) =>
              widget is AppIcon && widget.iconData == AppIcons.arrowBack,
        );
        expect(backButton, findsOneWidget);

        await tester.tap(backButton);
        await tester.pumpAndSettle();

        // Verify we're back on the home page
        expect(find.byType(CategoryProductsPage), findsNothing);
        expect(find.text('Home Page'), findsOneWidget);
        expect(find.text(categoryName), findsOneWidget);
        expect(find.text('clothing'), findsOneWidget);
      },
    );

    /// Integration test for BLoC integration with UI components
    /// **Validates: Requirements 5.4, 5.5**
    testWidgets(
      'should properly integrate CategoryProductsBloc with UI components',
      (WidgetTester tester) async {
        // Arrange
        const categoryName = 'jewelery';
        final mockProducts = [
          ProductEntity(
            id: 1,
            title: 'Gold Ring',
            price: 299.99,
            description: 'Beautiful gold ring',
            category: categoryName,
            image: 'https://example.com/ring.jpg',
            rating: RatingEntity(rate: 4.7, count: 25),
          ),
        ];

        // Setup mock to delay response. It is important to be able to see the loader
        when(() => mockGetAllProductsUseCase.call()).thenAnswer((_) async {
          await Future.delayed(Duration(milliseconds: 100));
          return Right(mockProducts);
        });

        // Act - Create CategoryProductsPage directly
        await tester.pumpWidget(
          MaterialApp(home: CategoryProductsPage(categoryName: categoryName)),
        );

        // Assert - Verify loading state is shown initially
        await tester.pump(); // Give one frame for initial render

        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // Wait for BLoC to process and load data
        await tester.pumpAndSettle();

        // Verify loaded state with correct data
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.text('$categoryName Products'), findsAtLeastNWidgets(1));
        expect(find.text('Gold Ring'), findsOneWidget);
        expect(find.text('\$299.99'), findsOneWidget);

        // Verify BLoC integration by checking template receives correct data
        final template = tester.widget<CategoryProductsTemplate>(
          find.byType(CategoryProductsTemplate),
        );
        expect(template.categoryName, equals(categoryName));
        expect(template.isLoading, isFalse);
        expect(template.errorMessage, isNull);
        expect(template.products.length, equals(1));
        expect(template.products.first.title, equals('Gold Ring'));
        expect(template.products.first.category, equals(categoryName));
      },
    );

    /// Integration test for error handling across the complete flow
    /// **Validates: Requirements 3.2, 5.4**
    testWidgets(
      'should handle errors gracefully in the complete navigation flow',
      (WidgetTester tester) async {
        // Arrange
        const categoryName = 'books';
        const errorMessage = 'Network connection failed';
        final mockCategories = [
          CategoryUiModel(
            id: 1,
            name: categoryName,
            image: 'https://example.com/books.jpg',
            quantity: 0,
          ),
        ];

        when(
          () => mockCategoriesSectionBloc.state,
        ).thenReturn(CategoriesSectionLoaded(mockCategories));

        when(
          () => mockGetAllProductsUseCase.call(),
        ).thenAnswer((_) async => Left(ServerFailure(message: errorMessage)));

        // Act - Build home page and navigate to category
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              appBar: AppBar(title: const Text('Home Page')),
              body: BlocProvider<CategoriesSectionBloc>.value(
                value: mockCategoriesSectionBloc,
                child: const CategoriesSection(),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Navigate to category products page
        await tester.tap(find.text(categoryName));
        await tester.pumpAndSettle();

        // Assert - Verify error is displayed correctly
        expect(find.byType(CategoryProductsPage), findsOneWidget);
        expect(find.textContaining(errorMessage), findsOneWidget);

        // Verify template receives error state
        final template = tester.widget<CategoryProductsTemplate>(
          find.byType(CategoryProductsTemplate),
        );
        expect(template.categoryName, equals(categoryName));
        expect(template.isLoading, isFalse);
        expect(template.errorMessage, contains(errorMessage));
        expect(template.products, isEmpty);

        // Verify back navigation still works even with error
        final backButton = find.byWidgetPredicate(
          (widget) =>
              widget is AppIcon && widget.iconData == AppIcons.arrowBack,
        );
        expect(backButton, findsOneWidget);

        await tester.tap(backButton);
        await tester.pumpAndSettle();

        // Verify we're back on home page
        expect(find.byType(CategoryProductsPage), findsNothing);
        expect(find.text('Home Page'), findsOneWidget);
      },
    );

    /// Integration test for empty category results
    /// **Validates: Requirements 3.2, 5.4**
    testWidgets('should handle empty category results correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      const categoryName = 'nonexistent';
      final mockProducts = [
        ProductEntity(
          id: 1,
          title: 'Some Product',
          price: 99.99,
          description: 'Product description',
          category: 'different-category',
          image: 'https://example.com/product.jpg',
          rating: RatingEntity(rate: 4.0, count: 10),
        ),
      ];

      when(
        () => mockGetAllProductsUseCase.call(),
      ).thenAnswer((_) async => Right(mockProducts));

      // Act
      await tester.pumpWidget(
        MaterialApp(home: CategoryProductsPage(categoryName: categoryName)),
      );

      await tester.pumpAndSettle();

      // Assert - Verify empty state is handled
      expect(find.text('$categoryName Products'), findsAtLeastNWidgets(1));
      expect(find.text('No products found in this category'), findsOneWidget);

      // Verify template receives empty products list
      final template = tester.widget<CategoryProductsTemplate>(
        find.byType(CategoryProductsTemplate),
      );
      expect(template.categoryName, equals(categoryName));
      expect(template.isLoading, isFalse);
      expect(template.errorMessage, isNull);
      expect(template.products, isEmpty);
    });

    /// Integration test for multiple category navigation
    /// **Validates: Requirements 3.2, 5.4, 5.5**
    testWidgets(
      'should handle navigation between different categories correctly',
      (WidgetTester tester) async {
        // Arrange
        final mockCategories = [
          CategoryUiModel(
            id: 1,
            name: 'electronics',
            image: 'https://example.com/electronics.jpg',
            quantity: 2,
          ),
          CategoryUiModel(
            id: 2,
            name: 'clothing',
            image: 'https://example.com/clothing.jpg',
            quantity: 1,
          ),
        ];

        final mockProducts = [
          ProductEntity(
            id: 1,
            title: 'Phone',
            price: 599.99,
            description: 'Smartphone',
            category: 'electronics',
            image: 'https://example.com/phone.jpg',
            rating: RatingEntity(rate: 4.5, count: 100),
          ),
          ProductEntity(
            id: 2,
            title: 'Shirt',
            price: 29.99,
            description: 'Cotton shirt',
            category: 'clothing',
            image: 'https://example.com/shirt.jpg',
            rating: RatingEntity(rate: 4.2, count: 50),
          ),
        ];

        when(
          () => mockCategoriesSectionBloc.state,
        ).thenReturn(CategoriesSectionLoaded(mockCategories));

        when(
          () => mockGetAllProductsUseCase.call(),
        ).thenAnswer((_) async => Right(mockProducts));

        // Act & Assert - Start from home page
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              appBar: AppBar(title: const Text('Home Page')),
              body: BlocProvider<CategoriesSectionBloc>.value(
                value: mockCategoriesSectionBloc,
                child: const CategoriesSection(),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Navigate to electronics category
        await tester.tap(find.text('electronics'));
        await tester.pumpAndSettle();

        // Verify electronics products are shown
        expect(find.text('electronics Products'), findsAtLeastNWidgets(1));
        expect(find.text('Phone'), findsOneWidget);
        expect(find.text('Shirt'), findsNothing);

        // Navigate back to home
        final backButton = find.byWidgetPredicate(
          (widget) =>
              widget is AppIcon && widget.iconData == AppIcons.arrowBack,
        );
        await tester.tap(backButton);
        await tester.pumpAndSettle();

        // Verify we're back on home
        expect(find.text('Home Page'), findsOneWidget);

        // Navigate to clothing category
        await tester.tap(find.text('clothing'));
        await tester.pumpAndSettle();

        // Verify clothing products are shown
        expect(find.text('clothing Products'), findsAtLeastNWidgets(1));
        expect(find.text('Shirt'), findsOneWidget);
        expect(find.text('Phone'), findsNothing);

        // Navigate back again
        final backButton2 = find.byWidgetPredicate(
          (widget) =>
              widget is AppIcon && widget.iconData == AppIcons.arrowBack,
        );
        await tester.tap(backButton2);
        await tester.pumpAndSettle();

        // Verify we're back on home
        expect(find.text('Home Page'), findsOneWidget);
        expect(find.text('electronics'), findsOneWidget);
        expect(find.text('clothing'), findsOneWidget);
      },
    );
  });
}
