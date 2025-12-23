import 'package:ecommerce_package_sample/ecommerce_package_sample.dart';
import 'package:ecommerce_sample/src/presentation/bloc/categories/categories_bloc.dart';
import 'package:ecommerce_sample/src/presentation/bloc/categories/categories_event.dart';
import 'package:ecommerce_sample/src/presentation/bloc/categories/categories_state.dart';
import 'package:ecommerce_sample/src/presentation/bloc/product/product_bloc.dart';
import 'package:ecommerce_sample/src/presentation/bloc/product/product_event.dart';
import 'package:ecommerce_sample/src/presentation/pages/home/sections/categories_section.dart';
import 'package:ecommerce_sample/src/presentation/pages/home/sections/top_products_section.dart';
import 'package:ecommerce_sample/src/presentation/templates/home_template.dart';
import 'package:ecommerce_sample_design_system/ecommerce_sample_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CategoriesBloc(
            getCategoriesUseCase: ServiceLocator.instance.get(),
          )..add(GetCategoriesEvent()),
          child: CategoriesSection(),
        ),
        BlocProvider(
          create: (context) => ProductBloc(
            getAllProductsUseCase: ServiceLocator.instance.get(),
            getProductByIdUseCase: ServiceLocator.instance.get(),
            addProductUseCase: ServiceLocator.instance.get(),
          )..add(GetAllProductsEvent()),
          child: TopProductsSection(),
        ),
      ],
      child: _HomePageView(),
    );
  }
}

class _HomePageView extends StatelessWidget {
  const _HomePageView();

  @override
  Widget build(BuildContext context) {
    return HomeTemplate(
      title: "Home",
      firstSection: CategoriesSection(),
      secondSection: TopProductsSection(),
    );
  }
}
