import 'package:ecommerce_package_sample/ecommerce_package_sample.dart';
import 'package:ecommerce_sample_design_system/ecommerce_sample_design_system.dart';
import 'package:flutter/material.dart';

class DetailTemplateFirstSection extends StatelessWidget {
  final ProductEntity productEntity;
  const DetailTemplateFirstSection({super.key, required this.productEntity});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppImage(imageUrl: productEntity.image),
        AppSpacing.verticalL,
        AppText(
          text: "Description",
          style: AppTextStyles.headline2,
          textAlign: TextAlign.justify,
        ),
        ConstrainedBox(
          constraints: BoxConstraints.loose(Size(450, 300)),
          child: AppText(
            text: productEntity.description,
            style: AppTextStyles.body,
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }
}
