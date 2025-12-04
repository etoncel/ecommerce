import 'package:equatable/equatable.dart';

/// Representa la calificación y el número de votos de un producto.
///
/// Esta entidad encapsula la información de calificación de un producto,
/// incluyendo la puntuación promedio y la cantidad de personas que han votado.
class RatingEntity extends Equatable {
  /// La puntuación promedio de la calificación del producto.
  final double rate;
  /// El número total de personas que han calificado el producto.
  final int count;

  const RatingEntity({required this.rate, required this.count});

  @override
  List<Object?> get props => [rate, count];
}
