import 'package:equatable/equatable.dart';

abstract class CategoriesSectionEvent extends Equatable {
  const CategoriesSectionEvent();

  @override
  List<Object> get props => [];
}

class GetCategoriesSectionEvent extends CategoriesSectionEvent {}
