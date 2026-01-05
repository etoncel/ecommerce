import 'package:ecommerce_sample/src/presentation/bloc/categories_section/categories_section_bloc.dart';
import 'package:ecommerce_sample/src/presentation/bloc/categories_section/categories_section_state.dart';
import 'package:mocktail/mocktail.dart';

/// Mock for CategoriesSectionBloc used in testing
class MockCategoriesSectionBloc extends Mock implements CategoriesSectionBloc {
  @override
  Stream<CategoriesSectionState> get stream => Stream.value(state);
}
