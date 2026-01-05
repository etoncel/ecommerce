import 'package:equatable/equatable.dart';
import 'package:ecommerce_sample/src/presentation/ui_models/category_ui_model.dart';

abstract class CategoriesSectionState extends Equatable {
  const CategoriesSectionState();

  @override
  List<Object> get props => [];
}

class CategoriesSectionInitial extends CategoriesSectionState {}

class CategoriesSectionLoading extends CategoriesSectionState {}

class CategoriesSectionLoaded extends CategoriesSectionState {
  final List<CategoryUiModel> categories;

  const CategoriesSectionLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}

class CategoriesSectionError extends CategoriesSectionState {
  final String message;

  const CategoriesSectionError({required this.message});

  @override
  List<Object> get props => [message];
}
