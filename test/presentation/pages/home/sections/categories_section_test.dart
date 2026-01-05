import 'package:dartz/dartz.dart';
import 'package:ecommerce_package_sample/ecommerce_package_sample.dart';
import 'package:ecommerce_sample/src/presentation/bloc/categories_section/categories_section_bloc.dart';
import 'package:ecommerce_sample/src/presentation/bloc/categories_section/categories_section_state.dart';
import 'package:ecommerce_sample/src/presentation/pages/category_products/category_products_page.dart';
import 'package:ecommerce_sample/src/presentation/pages/home/sections/categories_section.dart';
import 'package:ecommerce_sample/src/presentation/ui_models/category_ui_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/blocs_mocks.dart';
import '../../../../mocks/use_cases_mocks.dart';

void main() {
  late MockGetAllProductsUseCase mockGetAllProductsUseCase;

  setUp(() {
    mockGetAllProductsUseCase = MockGetAllProductsUseCase();

    // Register ServiceLocator mock for CategoryProductsPage dependency
    if (!ServiceLocator.instance.isRegistered<GetAllProductsUseCase>()) {
      ServiceLocator.instance.registerFactory<GetAllProductsUseCase>(
        () => mockGetAllProductsUseCase,
      );
    }

    // Setup default mock response for GetAllProductsUseCase
    when(() => mockGetAllProductsUseCase.call()).thenAnswer(
      (_) async => Right([
        ProductEntity(
          id: 1,
          title: 'Test Product',
          price: 99.99,
          description: 'Test Description',
          category: 'electronics',
          image: 'test.jpg',
          rating: RatingEntity(rate: 4.5, count: 100),
        ),
      ]),
    );
  });

  tearDown(() {
    // Clean up ServiceLocator after each test
    if (ServiceLocator.instance.isRegistered<GetAllProductsUseCase>()) {
      ServiceLocator.instance.unregister<GetAllProductsUseCase>();
    }
  });

  group('CategoriesSection', () {
    late MockCategoriesSectionBloc mockCategoriesSectionBloc;

    setUp(() {
      mockCategoriesSectionBloc = MockCategoriesSectionBloc();
    });

    /// **Feature: category-filtered-products, Property 1: Category Navigation**
    /// *For any* valid category name, when a user taps on that category in the home page,
    /// the system should navigate to the Category_Products_Page with the correct category parameter
    /// **Validates: Requirements 1.1, 1.2**
    testWidgets(
      'Property 1: Category Navigation - should navigate to CategoryProductsPage when category is tapped',
      (tester) async {
        // Test with electronics category
        const categoryName = 'electronics';
        final category = CategoryUiModel(
          id: 1,
          name: categoryName,
          image: 'https://example.com/image.jpg',
          quantity: 5,
        );

        when(
          () => mockCategoriesSectionBloc.state,
        ).thenReturn(CategoriesSectionLoaded([category]));

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider<CategoriesSectionBloc>.value(
                value: mockCategoriesSectionBloc,
                child: const CategoriesSection(),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Find the category item and verify it exists
        final categoryItem = find.text(categoryName);
        expect(
          categoryItem,
          findsOneWidget,
          reason: 'Category "$categoryName" should be displayed',
        );

        // Tap the category item
        await tester.tap(categoryItem);
        await tester.pumpAndSettle();

        // Verify that navigation occurred by checking if CategoryProductsPage is in the widget tree
        expect(
          find.byType(CategoryProductsPage),
          findsOneWidget,
          reason:
              'CategoryProductsPage should be displayed after tapping "$categoryName"',
        );

        // Verify the correct category name is passed
        final categoryProductsPage = tester.widget<CategoryProductsPage>(
          find.byType(CategoryProductsPage),
        );
        expect(
          categoryProductsPage.categoryName,
          equals(categoryName),
          reason:
              'CategoryProductsPage should receive the correct category name',
        );
      },
    );

    testWidgets(
      'should display loading indicator when categories are loading',
      (tester) async {
        when(
          () => mockCategoriesSectionBloc.state,
        ).thenReturn(CategoriesSectionLoading());

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: BlocProvider<CategoriesSectionBloc>.value(
                value: mockCategoriesSectionBloc,
                child: const CategoriesSection(),
              ),
            ),
          ),
        );

        expect(find.byType(LinearProgressIndicator), findsOneWidget);
      },
    );

    testWidgets('should display error message when categories fail to load', (
      tester,
    ) async {
      const errorMessage = 'Failed to load categories';
      when(
        () => mockCategoriesSectionBloc.state,
      ).thenReturn(const CategoriesSectionError(message: errorMessage));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<CategoriesSectionBloc>.value(
              value: mockCategoriesSectionBloc,
              child: const CategoriesSection(),
            ),
          ),
        ),
      );

      expect(find.text(errorMessage), findsOneWidget);
    });
  });
}
