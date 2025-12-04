import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ecommerce_sample/src/core/error/network_exception.dart';
import 'package:ecommerce_sample/src/core/error/server_exception.dart';
import 'package:ecommerce_sample/src/core/error/failures.dart';
import 'package:ecommerce_sample/src/data/datasources/product_remote_datasource.dart';
import 'package:ecommerce_sample/src/data/models/product_model.dart';
import 'package:ecommerce_sample/src/data/models/rating_model.dart';
import 'package:ecommerce_sample/src/domain/entities/product_entity.dart';
import 'package:ecommerce_sample/src/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource remoteDatasource;

  ProductRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, List<ProductEntity>>> getAllProducts() async {
    try {
      final remoteProducts = await remoteDatasource.getAllProducts();
      return Right(remoteProducts.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on SocketException {
      return Left(NetworkFailure(message: 'No hay conexión a internet.'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductById(int id) async {
    try {
      final remoteProduct = await remoteDatasource.getProductById(id);
      return Right(remoteProduct.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on SocketException {
      return Left(NetworkFailure(message: 'No hay conexión a internet.'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> addProduct(ProductEntity product) async {
    try {
      // FakeStoreAPI expects a ProductModel for adding, it returns a ProductModel too.
      // We pass the entity and convert it to model for the datasource
      // The API doesn't return the full created product, just a confirmation with an ID.
      final addedProduct = await remoteDatasource.addProduct(
        ProductModel(
          id: product.id,
          title: product.title,
          price: product.price,
          description: product.description,
          category: product.category,
          image: product.image,
          rating: RatingModel(
            rate: product.rating.rate,
            count: product.rating.count,
          ),
        ),
      );
      return Right(addedProduct.id);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on SocketException {
      return Left(NetworkFailure(message: 'No hay conexión a internet.'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
