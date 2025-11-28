import 'package:dartz/dartz.dart';
import 'package:ecommerce_sample/src/core/error/failures.dart';
import 'package:ecommerce_sample/src/domain/entities/product.dart';
import 'package:ecommerce_sample/src/domain/repositories/product_repository.dart';

class GetProductByIdUseCase {
  final ProductRepository repository;

  GetProductByIdUseCase(this.repository);

  Future<Either<Failure, Product>> call(int id) async {
    return await repository.getProductById(id);
  }
}
