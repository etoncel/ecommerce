import 'package:ecommerce_package_sample/ecommerce_package_sample.dart';
import 'package:ecommerce_sample/src/presentation/templates/detail/detail_template.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final ProductEntity productEntity;
  const DetailPage({super.key, required this.productEntity});

  @override
  Widget build(BuildContext context) {
    return DetailTemplate(productEntity: productEntity);
  }
}
