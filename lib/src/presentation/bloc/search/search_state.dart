part of 'search_bloc.dart';

abstract class SearchState {
  const SearchState();
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchLoading extends SearchState {
  const SearchLoading();
}

class SearchLoaded extends SearchState {
  final List<ProductUiModel> allProducts;
  final List<ProductUiModel> displayProducts;
  final String searchQuery;
  final Map<String, int> categoryQuantities;

  const SearchLoaded({
    required this.allProducts,
    required this.displayProducts,
    this.searchQuery = '',
    this.categoryQuantities = const {},
  });

  SearchLoaded copyWith({
    List<ProductUiModel>? allProducts,
    List<ProductUiModel>? displayProducts,
    String? searchQuery,
    Map<String, int>? categoryQuantities,
  }) {
    return SearchLoaded(
      allProducts: allProducts ?? this.allProducts,
      displayProducts: displayProducts ?? this.displayProducts,
      searchQuery: searchQuery ?? this.searchQuery,
      categoryQuantities: categoryQuantities ?? this.categoryQuantities,
    );
  }
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);
}
