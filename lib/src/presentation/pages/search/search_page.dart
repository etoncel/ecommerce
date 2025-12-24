import 'package:ecommerce_sample/src/presentation/templates/search/search_page_template.dart';
import 'package:flutter/material.dart';

/// Representa pantalla de resultados de búsqueda de
/// productos.
///
class SearchPage extends StatelessWidget {
  /// Texto que se ha ingresado en el buscador. Se utiliza
  /// para iniciar la búsqueda] de productos
  final String searchText;
  const SearchPage({super.key, required this.searchText});

  @override
  Widget build(BuildContext context) {
    return SearchPageTemplate(searchText: searchText);
  }
}
