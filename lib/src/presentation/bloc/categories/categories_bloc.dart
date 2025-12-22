import 'package:ecommerce_package_sample/ecommerce_package_sample.dart';
import 'package:ecommerce_sample/src/presentation/bloc/categories/categories_event.dart';
import 'package:ecommerce_sample/src/presentation/bloc/categories/categories_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  CategoriesBloc({required this.getCategoriesUseCase})
    : super(CategoriesInitial()) {
    on<GetCategoriesEvent>(_onGetCategories);
  }

  Future<void> _onGetCategories(
    GetCategoriesEvent event,
    Emitter<CategoriesState> emit,
  ) async {
    debugPrint("get catgories");
    emit(CategoriesLoading());
    final result = await getCategoriesUseCase();
    result.fold(
      (failure) =>
          emit(CategoriesError(message: "no se obtuvieron las categorías")),
      (categories) => emit(CategoriesLoaded(categories)),
    );
  }
}
