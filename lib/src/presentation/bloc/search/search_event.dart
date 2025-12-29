part of 'search_bloc.dart';

abstract class SearchEvent {
  const SearchEvent();
}

class LoadProducts extends SearchEvent {
  const LoadProducts();
}

class SearchProducts extends SearchEvent {
  final String query;

  const SearchProducts(this.query);
}

class SearchCategorySelected extends SearchEvent {
  final String selectedCategory;

  SearchCategorySelected({required this.selectedCategory});
}

class SearchCategoryUnSelected extends SearchEvent {
  SearchCategoryUnSelected();
}
