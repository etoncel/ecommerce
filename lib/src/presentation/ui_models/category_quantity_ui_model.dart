import 'package:equatable/equatable.dart';

class CategoryQuantityUiModel extends Equatable {
  final String name;
  final int quantity;

  const CategoryQuantityUiModel({required this.name, required this.quantity});

  @override
  List<Object?> get props => [name, quantity];
}
