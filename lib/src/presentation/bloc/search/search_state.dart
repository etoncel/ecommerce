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
  final List<ProductEntity> allProducts;
  final List<ProductEntity> displayProducts;
  final String searchQuery;

  const SearchLoaded({
    required this.allProducts,
    required this.displayProducts,
    this.searchQuery = '',
  });

  SearchLoaded copyWith({
    List<ProductEntity>? allProducts,
    List<ProductEntity>? displayProducts,
    String? searchQuery,
  }) {
    return SearchLoaded(
      allProducts: allProducts ?? this.allProducts,
      displayProducts: displayProducts ?? this.displayProducts,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);
}
