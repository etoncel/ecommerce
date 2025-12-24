import 'package:ecommerce_package_sample/ecommerce_package_sample.dart';
import 'package:ecommerce_sample/src/presentation/templates/detail/detail_template_first_section.dart';
import 'package:ecommerce_sample/src/presentation/templates/detail/detail_template_second_section.dart';
import 'package:ecommerce_sample_design_system/ecommerce_sample_design_system.dart';
import 'package:flutter/material.dart';

class DetailTemplateDesktop extends StatelessWidget {
  final ProductEntity productEntity;
  const DetailTemplateDesktop({super.key, required this.productEntity});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.spaceM),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            child: DetailTemplateFirstSection(productEntity: productEntity),
          ),
          AppSpacing.horizontalM,
          Flexible(
            child: DetailTemplateSecondSection(productEntity: productEntity),
          ),
        ],
      ),
    );
  }
}
