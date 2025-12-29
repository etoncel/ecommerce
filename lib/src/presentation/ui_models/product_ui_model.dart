import 'package:ecommerce_package_sample/ecommerce_package_sample.dart';
import 'package:ecommerce_sample/src/presentation/ui_models/rating_ui_model.dart';
import 'package:equatable/equatable.dart';

/// Modelo de UI para representar un producto.
///
/// Contiene propiedades relevantes para la presentación de un producto en la interfaz de usuario.
class ProductUiModel extends Equatable {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final RatingUiModel rating;

  const ProductUiModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory ProductUiModel.fromEntity(ProductEntity entity) {
    return ProductUiModel(
      id: entity.id,
      title: entity.title,
      price: entity.price,
      description: entity.description,
      category: entity.category,
      image: entity.image,
      rating: RatingUiModel.fromEntity(entity.rating),
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    price,
    description,
    category,
    image,
    rating,
  ];
}
