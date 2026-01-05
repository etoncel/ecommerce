import 'package:equatable/equatable.dart';
import 'package:ecommerce_package_sample/ecommerce_package_sample.dart';

/// UI model for category data used in the presentation layer.
/// Contains the essential properties needed for displaying categories in the UI.
class CategoryUiModel extends Equatable {
  /// The unique identifier for the category
  final int id;

  /// The name of the category
  final String name;

  /// The URL of the category's representative image
  final String image;

  /// The number of products in this category
  final int quantity;

  const CategoryUiModel({
    required this.id,
    required this.name,
    required this.image,
    required this.quantity,
  });

  /// Creates a CategoryUiModel from a CategoryEntity
  factory CategoryUiModel.fromEntity(
    CategoryEntity entity, {
    int? id,
    int? quantity,
  }) {
    return CategoryUiModel(
      id: id ?? entity.name.hashCode, // Use name hash as fallback ID
      name: entity.name,
      image: entity.image,
      quantity: quantity ?? 0,
    );
  }

  @override
  List<Object?> get props => [id, name, image, quantity];
}
