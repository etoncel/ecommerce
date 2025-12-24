import 'package:ecommerce_package_sample/ecommerce_package_sample.dart';
import 'package:ecommerce_sample_design_system/ecommerce_sample_design_system.dart';
import 'package:flutter/material.dart';

class DetailTemplateSecondSection extends StatelessWidget {
  final ProductEntity productEntity;
  final bool shouldAlignBottomButtonsVertically;
  const DetailTemplateSecondSection({
    super.key,
    required this.productEntity,
    this.shouldAlignBottomButtonsVertically = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSpacing.verticalM,
        AppText(
          text: productEntity.title,
          style: AppTextStyles.headline1,
          maxLines: 6,
          overflow: TextOverflow.ellipsis,
        ),
        AppSpacing.verticalXxs,

        Row(
          children: [
            ProductRating(rating: productEntity.rating.rate, fontSize: 18.0),
            AppSpacing.horizontalS,
            AppText(
              text: "(${productEntity.rating.count} Reviews)",
              style: AppTextStyles.body,
            ),
          ],
        ),
        AppSpacing.verticalS,
        AppText(
          text: "\$ ${productEntity.price}",
          style: AppTextStyles.headline1.copyWith(fontSize: 40),
        ),
        AppSpacing.verticalS,
        QuantitySelector(initialQuantity: 1, onChanged: (quantity) {}),
        AppSpacing.verticalS,
        shouldAlignBottomButtonsVertically
            ? Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(text: "Add to Cart", onPressed: () {}),
                  ),
                  AppSpacing.verticalS,
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      text: "Buy Now",
                      isPrimary: false,
                      onPressed: () {},
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  AppButton(text: "Add to Cart", onPressed: () {}),
                  AppSpacing.horizontalM,
                  AppButton(
                    text: "Buy Now",
                    isPrimary: false,
                    onPressed: () {},
                  ),
                ],
              ),
      ],
    );
  }
}
