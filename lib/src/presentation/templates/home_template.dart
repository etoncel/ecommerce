import 'package:ecommerce_sample_design_system/ecommerce_sample_design_system.dart';
import 'package:flutter/material.dart';

class HomeTemplate extends StatelessWidget {
  final Widget firstSection;
  final Widget secondSection;
  final String title;
  const HomeTemplate({
    super.key,
    required this.title,
    required this.firstSection,
    required this.secondSection,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: title),
      body: SingleChildScrollView(
        child: Column(
          children: [firstSection, AppSpacing.verticalL, secondSection],
        ),
      ),
    );
  }
}
