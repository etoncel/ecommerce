import 'package:ecommerce_sample/src/domain/entities/product_entity.dart';
import 'package:equatable/equatable.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class AllProductsLoaded extends ProductState {
  final List<ProductEntity> products;

  const AllProductsLoaded(this.products);

  @override
  List<Object> get props => [products];
}

class SingleProductLoaded extends ProductState {
  final ProductEntity product;

  const SingleProductLoaded(this.product);

  @override
  List<Object> get props => [product];
}

class ProductAdded extends ProductState {
  final int productId;

  const ProductAdded(this.productId);

  @override
  List<Object> get props => [productId];
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object> get props => [message];
}
