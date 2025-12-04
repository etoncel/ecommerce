import 'package:dartz/dartz.dart';
import 'package:ecommerce_sample/src/core/error/failures.dart';
import 'package:ecommerce_sample/src/domain/entities/product_entity.dart';
import 'package:ecommerce_sample/src/domain/repositories/product_repository.dart';

class AddProductUseCase {
  final ProductRepository repository;

  AddProductUseCase(this.repository);

  Future<Either<Failure, int>> call(ProductEntity product) async {
    return await repository.addProduct(product);
  }
}
