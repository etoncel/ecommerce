import 'package:ecommerce_package_sample/ecommerce_package_sample.dart';
import 'package:equatable/equatable.dart';

/// Modelo de UI para representar la calificación de un producto.
class RatingUiModel extends Equatable {
  final double rate;
  final int count;

  /// Constructor para crear una instancia de [RatingUiModel].
  const RatingUiModel({required this.rate, required this.count});

  /// Factory constructor para crear una instancia de [RatingUiModel] desde un [RatingEntity].
  factory RatingUiModel.fromEntity(RatingEntity entity) {
    return RatingUiModel(rate: entity.rate, count: entity.count);
  }

  @override
  List<Object?> get props => [rate, count];
}
