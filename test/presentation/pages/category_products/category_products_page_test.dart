import 'package:dartz/dartz.dart';
import 'package:ecommerce_package_sample/ecommerce_package_sample.dart';
import 'package:ecommerce_sample/src/presentation/bloc/category_products/category_products_bloc.dart';
import 'package:ecommerce_sample/src/presentation/pages/category_products/category_products_page.dart';
import 'package:ecommerce_sample/src/presentation/templates/category_products/category_products_template.dart';
import 'package:ecommerce_sample_design_system/ecommerce_sample_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/use_cases_mocks.dart';

void main() {
  late MockGetAllProductsUseCase mockGetAllProductsUseCase;

  setUp(() {
    mockGetAllProductsUseCase = MockGetAllProductsUseCase();

    // Register ServiceLocator mock
    if (!ServiceLocator.instance.isRegistered<GetAllProductsUseCase>()) {
      ServiceLocator.instance.registerFactory<GetAllProductsUseCase>(
        () => mockGetAllProductsUseCase,
      );
    }
  });

  group('CategoryProductsPage', () {
    testWidgets(
      'should provide CategoryProductsBloc and render CategoryProductsTemplate',
      (WidgetTester tester) async {
        // Arrange
        const categoryName = 'electronics';
        final mockProducts = [
          ProductEntity(
            id: 1,
            title: 'Test Product',
            price: 99.99,
            description: 'Test Description',
            category: categoryName,
            image: 'test.jpg',
            rating: RatingEntity(rate: 4.5, count: 100),
          ),
        ];

        when(
          () => mockGetAllProductsUseCase.call(),
        ).thenAnswer((_) async => Right(mockProducts));

        // Act
        await tester.pumpWidget(
          MaterialApp(home: CategoryProductsPage(categoryName: categoryName)),
        );

        // Assert
        // Check that BlocProvider is created
        expect(find.byType(BlocProvider<CategoryProductsBloc>), findsOneWidget);

        // Check that CategoryProductsTemplate is rendered
        expect(find.byType(CategoryProductsTemplate), findsOneWidget);

        // Check that the category name is passed correctly
        final template = tester.widget<CategoryProductsTemplate>(
          find.byType(CategoryProductsTemplate),
        );
        expect(template.categoryName, equals(categoryName));
      },
    );

    testWidgets(
      'should pass correct parameters to CategoryProductsTemplate based on BLoC state',
      (WidgetTester tester) async {
        // Arrange
        const categoryName = 'clothing';
        final mockProducts = [
          ProductEntity(
            id: 1,
            title: 'Test Shirt',
            price: 29.99,
            description: 'Test Shirt Description',
            category: categoryName,
            image: 'shirt.jpg',
            rating: RatingEntity(rate: 4.0, count: 50),
          ),
        ];

        when(
          () => mockGetAllProductsUseCase.call(),
        ).thenAnswer((_) async => Right(mockProducts));

        // Act
        await tester.pumpWidget(
          MaterialApp(home: CategoryProductsPage(categoryName: categoryName)),
        );

        // Wait for the BLoC to process
        await tester.pumpAndSettle();

        // Assert
        final template = tester.widget<CategoryProductsTemplate>(
          find.byType(CategoryProductsTemplate),
        );

        expect(template.categoryName, equals(categoryName));
        expect(template.isLoading, isFalse);
        expect(template.errorMessage, isNull);
        expect(template.products.length, equals(1));
        expect(template.products.first.title, equals('Test Shirt'));
      },
    );

    testWidgets('should handle error state correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      const categoryName = 'books';
      const errorMessage = 'Network error';

      when(
        () => mockGetAllProductsUseCase.call(),
      ).thenAnswer((_) async => Left(ServerFailure(message: errorMessage)));

      // Act
      await tester.pumpWidget(
        MaterialApp(home: CategoryProductsPage(categoryName: categoryName)),
      );

      // Wait for the BLoC to process
      await tester.pumpAndSettle();

      // Assert
      final template = tester.widget<CategoryProductsTemplate>(
        find.byType(CategoryProductsTemplate),
      );

      expect(template.categoryName, equals(categoryName));
      expect(template.isLoading, isFalse);
      expect(template.errorMessage, contains(errorMessage));
      expect(template.products, isEmpty);
    });

    testWidgets('should show loading state initially', (
      WidgetTester tester,
    ) async {
      // Arrange
      const categoryName = 'sports';
      final mockProducts = [
        ProductEntity(
          id: 1,
          title: 'Test Shirt',
          price: 29.99,
          description: 'Test Shirt Description',
          category: categoryName,
          image: 'shirt.jpg',
          rating: RatingEntity(rate: 4.0, count: 50),
        ),
      ];

      // Setup mock to delay response
      when(() => mockGetAllProductsUseCase.call()).thenAnswer((_) async {
        await Future.delayed(Duration(milliseconds: 100));
        return Right(mockProducts);
      });

      // Act
      await tester.pumpWidget(
        MaterialApp(home: CategoryProductsPage(categoryName: categoryName)),
      );

      // Check loading state before settling
      await tester.pump();

      // Assert
      final template = tester.widget<CategoryProductsTemplate>(
        find.byType(CategoryProductsTemplate),
      );

      final loader = find.byType(CircularProgressIndicator);

      expect(template.isLoading, isTrue, reason: 'isLoading should be true');
      expect(
        template.products.length,
        0,
        reason: 'Products should be empty while loading',
      );
      expect(loader, findsOneWidget);

      // Finish al Bloc events. Without this the test fails with pending timers error
      await tester.pumpAndSettle();
    });
  });

  group('CategoryProductsPage Property Tests', () {
    /// **Feature: category-filtered-products, Property 7: Back Navigation**
    /// *For any* Category_Products_Page instance, when the back button is pressed,
    /// the system should navigate back to the Home_Page
    /// **Validates: Requirements 3.1, 3.2**
    testWidgets(
      'Property 7: Back Navigation - should navigate back when back button is pressed',
      (WidgetTester tester) async {
        // Property-based test with multiple iterations
        for (int i = 0; i < 10; i++) {
          // Generate different category names for property testing
          final categoryNames = [
            'electronics',
            'clothing',
            'jewelery',
            'books',
            'sports',
            'home-garden',
            'toys',
            'beauty',
            'automotive',
            'food',
          ];
          final categoryName = categoryNames[i % categoryNames.length];

          final mockProducts = [
            ProductEntity(
              id: i + 1,
              title: 'Test Product $i',
              price: 99.99 + i,
              description: 'Test Description $i',
              category: categoryName,
              image: 'test$i.jpg',
              rating: RatingEntity(rate: 4.5, count: 100 + i),
            ),
          ];

          when(
            () => mockGetAllProductsUseCase.call(),
          ).thenAnswer((_) async => Right(mockProducts));

          // Create a navigation stack with home page and category page
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                appBar: AppBar(title: Text('Home Page')),
                body: Builder(
                  builder: (context) => ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              CategoryProductsPage(categoryName: categoryName),
                        ),
                      );
                    },
                    child: Text('Go to Category'),
                  ),
                ),
              ),
            ),
          );

          await tester.pumpAndSettle();

          // Navigate to CategoryProductsPage
          await tester.tap(find.text('Go to Category'));
          await tester.pumpAndSettle();

          // Verify we're on the CategoryProductsPage
          expect(
            find.byType(CategoryProductsPage),
            findsOneWidget,
            reason:
                'Should be on CategoryProductsPage for category "$categoryName"',
          );

          // Check what back navigation widgets are available
          // The CustomAppBar uses Flutter's AppBar which should automatically show back button
          final appBar = find.byType(AppBar);
          expect(appBar, findsOneWidget, reason: 'AppBar should be present');

          // Look for navigation back widgets
          final backButton = find.byWidgetPredicate(
            (widget) =>
                widget is AppIcon && widget.iconData == AppIcons.arrowBack,
          );

          expect(
            backButton,
            findsOneWidget,
            reason: 'Should have a back button of type AppIcon',
          );

          await tester.tap(backButton);
          await tester.pumpAndSettle();

          // Verify we're back on the home page
          expect(
            find.byType(CategoryProductsPage),
            findsNothing,
            reason: 'Should have navigated away from CategoryProductsPage',
          );

          expect(
            find.text('Home Page'),
            findsOneWidget,
            reason: 'Should be back on the Home Page',
          );

          // Reset for next iteration
          await tester.pumpWidget(Container());
          await tester.pumpAndSettle();
        }
      },
    );
  });
}
