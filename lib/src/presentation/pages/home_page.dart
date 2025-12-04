import 'package:ecommerce_sample/src/core/di/service_locator.dart';
import 'package:ecommerce_sample/src/domain/entities/product_entity.dart';
import 'package:ecommerce_sample/src/domain/entities/rating_entity.dart';
import 'package:ecommerce_sample/src/presentation/bloc/product_bloc.dart';
import 'package:ecommerce_sample/src/presentation/bloc/product_event.dart';
import 'package:ecommerce_sample/src/presentation/bloc/product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServiceLocator.instance<ProductBloc>(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API Test with BLoC')),
      body: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
          } else if (state is ProductAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Product added with ID: ${state.productId}'),
              ),
            );
          }
        },
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProductBloc>().add(GetAllProductsEvent());
                    },
                    child: const Text('Get All Products'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProductBloc>().add(
                        const GetProductByIdEvent(1),
                      );
                    },
                    child: const Text('Get Product by ID 1'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final newProduct = ProductEntity(
                        id: 0,
                        title: 'Test Product',
                        price: 13.5,
                        description: 'A test product',
                        image: 'https://i.pravatar.cc',
                        category: 'electronic',
                        rating: const RatingEntity(rate: 4.5, count: 120),
                      );
                      context.read<ProductBloc>().add(
                        AddProductEvent(newProduct),
                      );
                    },
                    child: const Text('Add Product'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
