import 'package:flutter/material.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/view/base/custom_image.dart';

class WebStoreWiseBannerView extends StatelessWidget {
  const WebStoreWiseBannerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: Dimensions.paddingSizeExtraLarge),
      child: Container(
        height: 135,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
          child: const CustomImage(
            image: Images.placeholder,
            fit: BoxFit.cover,
            height: 135,
            width: double.infinity,
          ),
        ),
      ),
    );
  }
}
