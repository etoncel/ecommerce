import 'package:equatable/equatable.dart';
import 'package:ecommerce_package_sample/ecommerce_package_sample.dart';

abstract class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object> get props => [];
}

class CategoriesInitial extends CategoriesState {}

class CategoriesLoading extends CategoriesState {}

class CategoriesLoaded extends CategoriesState {
  final List<CategoryEntity> categories;

  const CategoriesLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}

class CategoriesError extends CategoriesState {
  final String message;

  const CategoriesError({required this.message});
}
