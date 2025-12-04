import 'package:ecommerce_sample/src/domain/entities/rating_entity.dart';

class RatingModel {
  final double rate;
  final int count;

  const RatingModel({required this.rate, required this.count});

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      rate: (json['rate'] as num).toDouble(),
      count: json['count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'rate': rate, 'count': count};
  }

  RatingEntity toEntity() {
    return RatingEntity(rate: rate, count: count);
  }
}
