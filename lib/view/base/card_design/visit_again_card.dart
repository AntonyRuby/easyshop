import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/model/response/item_model.dart';
import 'package:sixam_mart/data/model/response/store_model.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/add_favourite_view.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:sixam_mart/view/screens/store/store_screen.dart';

class VisitAgainCard extends StatelessWidget {
  final Store store;
  final bool fromFood;

  const VisitAgainCard({
    Key? key,
    required this.store,
    required this.fromFood,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      onTap: () {
        Get.toNamed(
          RouteHelper.getStoreRoute(id: store.id, page: 'tore'),
          arguments: StoreScreen(store: store, fromModule: false),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(
          top: Dimensions.paddingSizeDefault,
          right: Dimensions.paddingSizeDefault,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          color: Theme.of(context).cardColor,
          border: Border.all(
            color: Theme.of(context).primaryColor.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: Dimensions.paddingSizeSmall,
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(
                    fromFood ? 100 : Dimensions.radiusDefault),
                child: CustomImage(
                  image:
                      '${Get.find<SplashController>().configModel!.baseUrls!.businessLogoUrl}/${store.logo}',
                  fit: BoxFit.cover,
                  height: 124,
                  width: 124,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                store.name ?? '',
                style: robotoBold,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Text(
                "${store.deliveryTime}",
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
