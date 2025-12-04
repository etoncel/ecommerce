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

class ServiceLocator {
  static final GetIt _instance = GetIt.instance;

  static GetIt get instance => _instance;

  static setUp() {
    _setUpProductFeature();
    _setUpExternal();
  }

  static void _setUpProductFeature() {
    //! Features - Product

    // Bloc (or other State Management)
    _instance.registerFactory(
      () => ProductBloc(
        getAllProductsUseCase: _instance(),
        getProductByIdUseCase: _instance(),
        addProductUseCase: _instance(),
      ),
    );

    // Use cases
    _instance.registerFactory(() => GetAllProductsUseCase(_instance()));
    _instance.registerFactory(() => GetProductByIdUseCase(_instance()));
    _instance.registerFactory(() => AddProductUseCase(_instance()));

    // Repository
    _instance.registerFactory<ProductRepository>(
      () => ProductRepositoryImpl(remoteDatasource: _instance()),
    );

    // Data sources
    _instance.registerFactory<ProductRemoteDatasource>(
      () => ProductRemoteDatasourceImpl(client: _instance()),
    );
  }

  static void _setUpExternal() {
    //! External
    _instance.registerFactory(() => http.Client());
  }
}
