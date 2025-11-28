import 'package:dartz/dartz.dart';
import 'package:ecommerce_sample/src/core/error/failures.dart';
import 'package:ecommerce_sample/src/domain/entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getAllProducts();
  Future<Either<Failure, Product>> getProductById(int id);
  Future<Either<Failure, int>> addProduct(Product product);
}
