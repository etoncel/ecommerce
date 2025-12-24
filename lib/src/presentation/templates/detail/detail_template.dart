import 'package:ecommerce_package_sample/ecommerce_package_sample.dart';
import 'package:ecommerce_sample/src/presentation/templates/detail/detail_template_desktop.dart';
import 'package:ecommerce_sample/src/presentation/templates/detail/detail_template_mobile.dart';
import 'package:ecommerce_sample_design_system/ecommerce_sample_design_system.dart';
import 'package:flutter/material.dart';

/// Template que representa la interfaz para una pantalla de detalle
/// de un elemento de una lista.
class DetailTemplate extends StatelessWidget {
  final ProductEntity productEntity;
  const DetailTemplate({super.key, required this.productEntity});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Container(
          color: AppColors.textLight.withAlpha(30),
          alignment: Alignment.center,
          constraints: BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              CustomAppBar(showSearchBar: true),
              AppSpacing.verticalL,
              Expanded(
                child: SingleChildScrollView(
                  child: switch (screenWidth) {
                    > 700 => DetailTemplateDesktop(
                      productEntity: productEntity,
                    ),
                    _ => DetailTemplateMobile(productEntity: productEntity),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
