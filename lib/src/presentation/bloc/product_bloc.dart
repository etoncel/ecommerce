import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_sample/src/domain/usecases/add_product_usecase.dart';
import 'package:ecommerce_sample/src/domain/usecases/get_all_products_usecase.dart';
import 'package:ecommerce_sample/src/domain/usecases/get_product_by_id_usecase.dart';
import 'package:ecommerce_sample/src/presentation/bloc/product_event.dart';
import 'package:ecommerce_sample/src/presentation/bloc/product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetAllProductsUseCase getAllProductsUseCase;
  final GetProductByIdUseCase getProductByIdUseCase;
  final AddProductUseCase addProductUseCase;

  ProductBloc({
    required this.getAllProductsUseCase,
    required this.getProductByIdUseCase,
    required this.addProductUseCase,
  }) : super(ProductInitial()) {
    on<GetAllProductsEvent>(_onGetAllProducts);
    on<GetProductByIdEvent>(_onGetProductById);
    on<AddProductEvent>(_onAddProduct);
  }

  Future<void> _onGetAllProducts(
      GetAllProductsEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final result = await getAllProductsUseCase();
    result.fold(
      (failure) => emit(ProductError(failure.toString())),
      (products) {
        print('Success! Found ${products.length} products.');
        products.forEach((p) => print('- ${p.title}'));
        emit(AllProductsLoaded(products));
      },
    );
  }

  Future<void> _onGetProductById(
      GetProductByIdEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final result = await getProductByIdUseCase(event.id);
    result.fold(
      (failure) => emit(ProductError(failure.toString())),
      (product) {
        print('Success! Found product:');
        print(product.toString());
        emit(SingleProductLoaded(product));
      },
    );
  }

  Future<void> _onAddProduct(
      AddProductEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final result = await addProductUseCase(event.product);
    result.fold(
      (failure) => emit(ProductError(failure.toString())),
      (id) {
        print('Success! Product added with ID: $id');
        emit(ProductAdded(id));
      },
    );
  }
}
