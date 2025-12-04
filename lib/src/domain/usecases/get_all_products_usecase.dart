import 'package:dartz/dartz.dart';
import 'package:ecommerce_sample/src/core/error/failures.dart';
import 'package:ecommerce_sample/src/domain/entities/product_entity.dart';
import 'package:ecommerce_sample/src/domain/repositories/product_repository.dart';

class GetAllProductsUseCase {
  final ProductRepository repository;

  GetAllProductsUseCase(this.repository);

  Future<Either<Failure, List<ProductEntity>>> call() async {
    return await repository.getAllProducts();
  }
}
