import 'package:ecommerce_package_sample/ecommerce_package_sample.dart';
import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class GetAllProductsEvent extends ProductEvent {}

class GetProductByIdEvent extends ProductEvent {
  final int id;

  const GetProductByIdEvent(this.id);

  @override
  List<Object> get props => [id];
}

class AddProductEvent extends ProductEvent {
  final ProductEntity product;

  const AddProductEvent(this.product);

  @override
  List<Object> get props => [product];
}
