import 'package:dartz/dartz.dart';
import 'package:ecommerce_sample/src/core/error/failures.dart';
import 'package:ecommerce_sample/src/domain/entities/product.dart';
import 'package:ecommerce_sample/src/domain/repositories/product_repository.dart';

class AddProductUseCase {
  final ProductRepository repository;

  AddProductUseCase(this.repository);

  Future<Either<Failure, int>> call(Product product) async {
    return await repository.addProduct(product);
  }
}
