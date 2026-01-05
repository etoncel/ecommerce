import 'package:ecommerce_package_sample/ecommerce_package_sample.dart';
import 'package:ecommerce_sample/src/presentation/bloc/categories_section/categories_section_event.dart';
import 'package:ecommerce_sample/src/presentation/bloc/categories_section/categories_section_state.dart';
import 'package:ecommerce_sample/src/presentation/ui_models/category_ui_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesSectionBloc
    extends Bloc<CategoriesSectionEvent, CategoriesSectionState> {
  final GetCategoriesUseCase getCategoriesUseCase;

  CategoriesSectionBloc({required this.getCategoriesUseCase})
    : super(CategoriesSectionInitial()) {
    on<GetCategoriesSectionEvent>(_onGetCategories);
  }

  Future<void> _onGetCategories(
    GetCategoriesSectionEvent event,
    Emitter<CategoriesSectionState> emit,
  ) async {
    debugPrint("get categories");
    emit(CategoriesSectionLoading());
    final result = await getCategoriesUseCase();
    result.fold(
      (failure) => emit(
        const CategoriesSectionError(
          message: "no se obtuvieron las categorías",
        ),
      ),
      (categories) {
        // Convert CategoryEntity to CategoryUiModel
        final categoryUiModels = categories
            .asMap()
            .entries
            .map(
              (entry) => CategoryUiModel.fromEntity(
                entry.value,
                id: entry.key + 1, // Use index + 1 as ID
                quantity: 0, // Default quantity, can be updated later
              ),
            )
            .toList();
        emit(CategoriesSectionLoaded(categoryUiModels));
      },
    );
  }
}
