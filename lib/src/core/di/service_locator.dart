import 'package:ecommerce_sample/src/data/datasources/product_remote_datasource.dart';
import 'package:ecommerce_sample/src/data/datasources/product_remote_datasource_impl.dart';
import 'package:ecommerce_sample/src/data/repositories/product_repository_impl.dart';
import 'package:ecommerce_sample/src/domain/repositories/product_repository.dart';
import 'package:ecommerce_sample/src/domain/usecases/add_product_usecase.dart';
import 'package:ecommerce_sample/src/domain/usecases/get_all_products_usecase.dart';
import 'package:ecommerce_sample/src/domain/usecases/get_product_by_id_usecase.dart';
import 'package:ecommerce_sample/src/presentation/bloc/product_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final GetIt serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async {
  //! Features - Product

  // Bloc (or other State Management)
  serviceLocator.registerFactory(() => ProductBloc(
        getAllProductsUseCase: serviceLocator(),
        getProductByIdUseCase: serviceLocator(),
        addProductUseCase: serviceLocator(),
      ));

  // Use cases
  serviceLocator.registerFactory(() => GetAllProductsUseCase(serviceLocator()));
  serviceLocator.registerFactory(() => GetProductByIdUseCase(serviceLocator()));
  serviceLocator.registerFactory(() => AddProductUseCase(serviceLocator()));

  // Repository
  serviceLocator.registerFactory<ProductRepository>(
    () => ProductRepositoryImpl(remoteDatasource: serviceLocator()),
  );

  // Data sources
  serviceLocator.registerFactory<ProductRemoteDatasource>(
    () => ProductRemoteDatasourceImpl(client: serviceLocator()),
  );

  //! Core
  // No core dependencies specified yet, but NetworkInfo would go here.

  //! External
  serviceLocator.registerFactory(() => http.Client());
}
