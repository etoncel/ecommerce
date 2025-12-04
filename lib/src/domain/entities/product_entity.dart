import 'package:ecommerce_sample/src/domain/entities/rating_entity.dart';
import 'package:equatable/equatable.dart';

/// Representa un producto en la aplicación de comercio electrónico.
///
/// Esta entidad contiene toda la información necesaria sobre un producto,
/// incluyendo su identificación, descripción, precio, categorización,
/// imagen y calificaciones de los usuarios.
class ProductEntity extends Equatable {
  /// El identificador único del producto.
  final int id;
  /// El título o nombre del producto.
  final String title;
  /// El precio del producto.
  final double price;
  /// Una descripción detallada del producto.
  final String description;
  /// La categoría a la que pertenece el producto.
  final String category;
  /// La URL de la imagen principal del producto.
  final String image;
  /// La entidad de calificación asociada a este producto.
  final RatingEntity rating;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

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
