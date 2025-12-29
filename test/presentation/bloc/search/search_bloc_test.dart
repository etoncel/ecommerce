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
      id: 1,
      title: "Pantalon",
      price: 2,
      description: "Pantalon negro hombre",
      category: "Ropa",
      image: "image",
      rating: RatingEntity(rate: 3, count: 10),
    ),
  ];

  setUp(() {
    mockGetAllProductsUseCase = MockGetAllProductsUseCase();
    sut = SearchBloc(getAllProductsUseCase: mockGetAllProductsUseCase);
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
        ProductUiModel(
          id: 1,
          title: "Pantalon",
          price: 2,
          description: "Pantalon negro hombre",
          category: "Ropa",
          image: "image",
          rating: RatingUiModel(rate: 3, count: 10),
        ),
      ];
      when(
        () => mockGetAllProductsUseCase.call(),
      ).thenAnswer((_) async => Right(mockProductsEntities));
      final searchText = "Camisa";

      // Act
      sut.add(SearchProducts(searchText));

      // Assert
      expectLater(
        sut.stream,
        emits(
          isA<SearchLoaded>()
              .having(
                (state) => state.allProducts.length,
                'allProducts  length',
                expectedProducts.length,
              )
              .having(
                (state) => state.displayProducts.length,
                'displayProducts products length',
                1,
              )
              .having(
                (state) => state.displayProducts.first,
                'first displayed product',
                expectedProducts.first,
              ),
        ),
      );
    });
  });

  group('Products Categories', () {
    test('Should return categories with quantities', () async {
      final expectedCategories = [
        CategoryQuantityUiModel(name: "Ropa", quantity: 2),
      ];
      when(
        () => mockGetAllProductsUseCase.call(),
      ).thenAnswer((_) async => Right(mockProductsEntities));
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
                1,
              )
              .having(
                (state) => state.categoryQuantities,
                'categories with 2 products',
                expectedCategories,
              ),
        ),
      );
    });
  });
}
