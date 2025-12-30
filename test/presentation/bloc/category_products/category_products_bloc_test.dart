import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:ecommerce_package_sample/ecommerce_package_sample.dart';
import 'package:ecommerce_sample/src/presentation/bloc/category_products/category_products_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/use_cases_mocks.dart';

void main() {
  late MockGetAllProductsUseCase mockGetAllProductsUseCase;

  setUp(() {
    mockGetAllProductsUseCase = MockGetAllProductsUseCase();
  });

  group('CategoryProductsBloc Property Tests', () {
    // **Feature: category-filtered-products, Property 2: Category Product Filtering**
    // **Validates: Requirements 1.3, 2.1**
    test(
      'Property 2: Category Product Filtering - For any category name and any set of products, only products belonging to the selected category should be displayed',
      () async {
        // Property-based test with multiple iterations
        final random = Random();

        for (int iteration = 0; iteration < 100; iteration++) {
          // Generate random test data
          final categories = [
            'electronics',
            'clothing',
            'jewelery',
            'books',
            'sports',
          ];
          final selectedCategory =
              categories[random.nextInt(categories.length)];

          // Generate random products with various categories
          final allProducts = List.generate(random.nextInt(20) + 5, (index) {
            final category = categories[random.nextInt(categories.length)];
            return ProductEntity(
              id: index,
              title: 'Product $index',
              price: random.nextDouble() * 100,
              description: 'Description $index',
              category: category,
              image: 'image$index.jpg',
              rating: RatingEntity(
                rate: random.nextDouble() * 5,
                count: random.nextInt(1000),
              ),
            );
          });

          // Ensure at least one product exists for the selected category
          if (!allProducts.any((p) => p.category == selectedCategory)) {
            allProducts.add(
              ProductEntity(
                id: 999,
                title: 'Guaranteed Product',
                price: 50.0,
                description: 'Guaranteed product for category',
                category: selectedCategory,
                image: 'guaranteed.jpg',
                rating: RatingEntity(rate: 4.0, count: 100),
              ),
            );
          }

          // Setup mock
          when(
            () => mockGetAllProductsUseCase.call(),
          ).thenAnswer((_) async => Right(allProducts));

          // Create fresh bloc for each iteration
          final bloc = CategoryProductsBloc(
            getAllProductsUseCase: mockGetAllProductsUseCase,
          );

          // Act
          bloc.add(LoadCategoryProducts(selectedCategory));

          // Assert
          await expectLater(
            bloc.stream,
            emitsInOrder([
              isA<CategoryProductsLoading>(),
              isA<CategoryProductsLoaded>()
                  .having(
                    (state) {
                      // Verify all returned products belong to the selected category
                      return state.products.every(
                        (product) => product.category == selectedCategory,
                      );
                    },
                    'all products belong to selected category',
                    true,
                  )
                  .having(
                    (state) => state.categoryName,
                    'category name matches',
                    selectedCategory,
                  ),
            ]),
          );

          await bloc.close();
        }
      },
    );

    // **Feature: category-filtered-products, Property 4: Loading State Display**
    // **Validates: Requirements 2.2**
    test(
      'Property 4: Loading State Display - For any category loading operation, when products are being fetched, a loading indicator should be displayed',
      () async {
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
            'home',
            'garden',
          ];
          final selectedCategory =
              categories[random.nextInt(categories.length)];

          // Generate random products
          final allProducts = List.generate(random.nextInt(15) + 1, (index) {
            return ProductEntity(
              id: index,
              title: 'Product $index',
              price: random.nextDouble() * 200,
              description: 'Description $index',
              category: categories[random.nextInt(categories.length)],
              image: 'image$index.jpg',
              rating: RatingEntity(
                rate: random.nextDouble() * 5,
                count: random.nextInt(500),
              ),
            );
          });

          // Setup mock with delay to ensure loading state is emitted
          when(() => mockGetAllProductsUseCase.call()).thenAnswer((_) async {
            await Future.delayed(Duration(milliseconds: 10));
            return Right(allProducts);
          });

          // Create fresh bloc for each iteration
          final bloc = CategoryProductsBloc(
            getAllProductsUseCase: mockGetAllProductsUseCase,
          );

          // Act
          bloc.add(LoadCategoryProducts(selectedCategory));

          // Assert - verify loading state is emitted first
          await expectLater(
            bloc.stream,
            emitsInOrder([
              isA<CategoryProductsLoading>(),
              isA<CategoryProductsLoaded>(),
            ]),
          );

          await bloc.close();
        }
      },
    );

    // **Feature: category-filtered-products, Property 6: Error Message Display**
    // **Validates: Requirements 2.5**
    test(
      'Property 6: Error Message Display - For any error condition during product loading, an appropriate error message should be displayed',
      () async {
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
          final selectedCategory =
              categories[random.nextInt(categories.length)];

          // Generate random error messages
          final errorMessages = [
            'Network error occurred',
            'Server timeout',
            'Invalid response format',
            'Connection failed',
            'Service unavailable',
            'Authentication failed',
            'Rate limit exceeded',
          ];
          final errorMessage =
              errorMessages[random.nextInt(errorMessages.length)];

          // Setup mock to return error
          when(
            () => mockGetAllProductsUseCase.call(),
          ).thenAnswer((_) async => Left(ServerFailure(message: errorMessage)));

          // Create fresh bloc for each iteration
          final bloc = CategoryProductsBloc(
            getAllProductsUseCase: mockGetAllProductsUseCase,
          );

          // Act
          bloc.add(LoadCategoryProducts(selectedCategory));

          // Assert - verify error state is emitted with message
          await expectLater(
            bloc.stream,
            emitsInOrder([
              isA<CategoryProductsLoading>(),
              isA<CategoryProductsError>().having(
                (state) => state.message.isNotEmpty,
                'error message is not empty',
                true,
              ),
            ]),
          );

          await bloc.close();
        }
      },
    );
  });
}
