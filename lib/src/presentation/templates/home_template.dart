import 'package:ecommerce_sample/src/presentation/pages/search/search_page.dart';
import 'package:ecommerce_sample_design_system/ecommerce_sample_design_system.dart';
import 'package:flutter/material.dart';

class HomeTemplate extends StatelessWidget {
  final Widget firstSection;
  final Widget secondSection;
  final Widget thirdSection;
  final String title;
  const HomeTemplate({
    super.key,
    required this.title,
    required this.firstSection,
    required this.secondSection,
    required this.thirdSection,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: title,
        showSearchBar: true,
        onSubmitted: (text) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (c) => SearchPage(searchText: text)),
          );
        },
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            firstSection,
            AppSpacing.verticalL,
            secondSection,
            thirdSection,
          ],
        ),
      ),
    );
  }
}
