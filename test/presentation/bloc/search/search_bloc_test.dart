import 'package:dartz/dartz.dart';
import 'package:ecommerce_package_sample/ecommerce_package_sample.dart';
import 'package:ecommerce_sample/src/presentation/bloc/search/search_bloc.dart';
import 'package:ecommerce_sample/src/presentation/ui_models/category_quantity_ui_model.dart';
import 'package:ecommerce_sample/src/presentation/ui_models/product_ui_model.dart';
import 'package:ecommerce_sample/src/presentation/ui_models/rating_ui_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/use_cases_mocks.dart';

void main() {
  late SearchBloc sut;
  late MockGetAllProductsUseCase mockGetAllProductsUseCase;

  final List<ProductEntity> mockProductsEntities = [
    ProductEntity(
      id: 1,
      title: "Camisa",
      price: 2,
      description: "Camisa Azul Hombre",
      category: "Ropa",
      image: "image",
      rating: RatingEntity(rate: 4, count: 100),
    ),
    ProductEntity(
      id: 2,
      title: "Pantalon",
      price: 2,
      description: "Pantalon negro hombre",
      category: "Ropa",
      image: "image",
      rating: RatingEntity(rate: 3, count: 10),
    ),
    ProductEntity(
      id: 3,
      title: "Laptop",
      price: 200,
      description: "Black Laptop 16 inches",
      category: "Electronics",
      image: "image",
      rating: RatingEntity(rate: 5, count: 100),
    ),
  ];

  setUp(() {
    mockGetAllProductsUseCase = MockGetAllProductsUseCase();
    sut = SearchBloc(getAllProductsUseCase: mockGetAllProductsUseCase);
    when(
      () => mockGetAllProductsUseCase.call(),
    ).thenAnswer((_) async => Right(mockProductsEntities));
  });
  group('Search Products', () {
    test('Should return filtered products ui models by search text', () async {
      // Arrange
      final expectedProducts = [
        ProductUiModel(
          id: 1,
          title: "Camisa",
          price: 2,
          description: "Camisa Azul Hombre",
          category: "Ropa",
          image: "image",
          rating: RatingUiModel(rate: 4, count: 100),
        ),
      ];

      final searchText = "Camisa";

      // Act
      sut.add(SearchProducts(searchText));

      // Assert
      await expectLater(
        sut.stream,
        emits(
          isA<SearchLoaded>()
              .having(
                (state) => state.allProducts.length,
                'allProducts equal to all products entities',
                mockProductsEntities.length,
              )
              .having(
                (state) => state.displayProducts.length,
                'displayProducts equal to expected products',
                expectedProducts.length,
              )
              .having(
                (state) => state.displayProducts.first,
                'first displayed product',
                expectedProducts.first,
              ),
        ),
      );

      verify(() => mockGetAllProductsUseCase.call()).called(1);
    });

    test(
      'Should not call get products use case when all products is not empty',
      () async {
        // Arrange
        final expectedProducts = [
          ProductUiModel(
            id: 1,
            title: "Camisa",
            price: 2,
            description: "Camisa Azul Hombre",
            category: "Ropa",
            image: "image",
            rating: RatingUiModel(rate: 4, count: 100),
          ),
        ];
        final sut = SearchBloc(
          getAllProductsUseCase: mockGetAllProductsUseCase,
          initialState: SearchLoaded(
            allProducts: expectedProducts,
            displayProducts: expectedProducts,
          ),
        );

        // Act
        sut.add(SearchProducts(''));

        // Assert

        await expectLater(
          sut.stream,
          emits(
            isA<SearchLoaded>()
                .having(
                  (state) => state.allProducts.length,
                  'allProducts equal to all expected products',
                  expectedProducts.length,
                )
                .having(
                  (state) => state.displayProducts.length,
                  'displayProducts equal to expected products',
                  expectedProducts.length,
                )
                .having(
                  (state) => state.displayProducts.first,
                  'first displayed product',
                  expectedProducts.first,
                ),
          ),
        );

        verifyNever(() => mockGetAllProductsUseCase.call());
      },
    );
  });

  group('Products Categories', () {
    test('Should return categories with quantities', () async {
      // Arrange
      final expectedCategories = [
        CategoryQuantityUiModel(name: "Ropa", quantity: 2),
        CategoryQuantityUiModel(name: "Electronics", quantity: 1),
      ];

      final searchText = "";

      // Act
      sut.add(SearchProducts(searchText));

      // Assert
      expectLater(
        sut.stream,
        emits(
          isA<SearchLoaded>()
              .having(
                (state) => state.categoryQuantities.length,
                'categories  length',
                expectedCategories.length,
              )
              .having(
                (state) => state.categoryQuantities,
                'categories',
                expectedCategories,
              ),
        ),
      );
    });

    test('Should filter category products', () {
      // Arrange
      final products = [
        ProductUiModel(
          id: 1,
          title: "Camisa",
          price: 2,
          description: "Camisa Azul Hombre",
          category: "Ropa",
          image: "image",
          rating: RatingUiModel(rate: 4, count: 100),
        ),
        ProductUiModel(
          id: 2,
          title: "Laptop",
          price: 200,
          description: "Black Laptop 16 inches",
          category: "Electronics",
          image: "image",
          rating: RatingUiModel(rate: 5, count: 100),
        ),
      ];
      const selectedCategory = "Electronics";
      final initialState = SearchLoaded(
        allProducts: products,
        displayProducts: products,
      );
      final sut = SearchBloc(
        getAllProductsUseCase: mockGetAllProductsUseCase,
        initialState: initialState,
      );

      // Act
      sut.add(SearchCategorySelected(selectedCategory: selectedCategory));

      // Assert
      expectLater(
        sut.stream,
        emits(
          isA<SearchLoaded>()
              .having(
                (state) => state.displayProducts.length,
                'selected category products length',
                1,
              )
              .having(
                (state) => state.displayProducts.first.category,
                'filtered electronic product',
                selectedCategory,
              ),
        ),
      );
    });

    test(
      'Should display all search products when cancel category products',
      () {
        // Arrange
        final products = [
          ProductUiModel(
            id: 1,
            title: "Camisa",
            price: 2,
            description: "Camisa Azul Hombre",
            category: "Ropa",
            image: "image",
            rating: RatingUiModel(rate: 4, count: 100),
          ),
          ProductUiModel(
            id: 2,
            title: "Laptop",
            price: 200,
            description: "Black Laptop 16 inches",
            category: "Electronics",
            image: "image",
            rating: RatingUiModel(rate: 5, count: 100),
          ),
        ];
        final filteredProducts = [products[1]];
        const selectedCategory = "Electronics";
        final initialState = SearchLoaded(
          allProducts: products,
          displayProducts: filteredProducts,
          selectedCategory: selectedCategory,
        );
        final sut = SearchBloc(
          getAllProductsUseCase: mockGetAllProductsUseCase,
          initialState: initialState,
        );

        // Act
        sut.add(SearchCategoryUnSelected());

        // Assert
        expectLater(
          sut.stream,
          emits(
            isA<SearchLoaded>().having(
              (state) => state.displayProducts.length,
              'displayProducts should not be filtered by category',
              products.length,
            ),
          ),
        );
      },
    );
  });
}
