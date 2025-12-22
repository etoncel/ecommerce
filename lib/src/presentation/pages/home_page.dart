import 'package:ecommerce_package_sample/ecommerce_package_sample.dart';
import 'package:ecommerce_sample/src/presentation/bloc/categories/categories_bloc.dart';
import 'package:ecommerce_sample/src/presentation/bloc/categories/categories_event.dart';
import 'package:ecommerce_sample/src/presentation/bloc/categories/categories_state.dart';
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
      secondSection: CategoriesSection(),
    );
  }
}

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (context, state) {
        if (state is CategoriesInitial) {
          return Placeholder();
        }
        if (state is CategoriesLoading) {
          return LinearProgressIndicator();
        }

        if (state is CategoriesLoaded) {
          return SingleHorizontalList(
            items: state.categories
                .map(
                  (category) => SingleListItemData(
                    imageUrl: category.image,
                    itemName: category.name,
                  ),
                )
                .toList(),
            title: "Categorías",
          );
        }

        if (state is CategoriesError) {
          return Text(state.message);
        }

        return SizedBox();
      },
    );
  }
}
