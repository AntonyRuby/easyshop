import 'package:flutter/cupertino.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/banner_controller.dart';
import 'package:sixam_mart/controller/campaign_controller.dart';
import 'package:sixam_mart/controller/category_controller.dart';
import 'package:sixam_mart/controller/coupon_controller.dart';
import 'package:sixam_mart/controller/flash_sale_controller.dart';
import 'package:sixam_mart/controller/localization_controller.dart';
import 'package:sixam_mart/controller/location_controller.dart';
import 'package:sixam_mart/controller/notification_controller.dart';
import 'package:sixam_mart/controller/item_controller.dart';
import 'package:sixam_mart/controller/parcel_controller.dart';
import 'package:sixam_mart/controller/store_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/controller/user_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/app_constants.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/item_view.dart';
import 'package:sixam_mart/view/base/menu_drawer.dart';
import 'package:sixam_mart/view/base/paginated_list_view.dart';
import 'package:sixam_mart/view/base/web_menu_bar.dart';
import 'package:sixam_mart/view/screens/home/modules/food_home_screen.dart';
import 'package:sixam_mart/view/screens/home/modules/grocery_home_screen.dart';
import 'package:sixam_mart/view/screens/home/modules/pharmacy_home_screen.dart';
import 'package:sixam_mart/view/screens/home/modules/shop_home_screen.dart';
import 'package:sixam_mart/view/screens/home/web_new_home_screen.dart';
import 'package:sixam_mart/view/screens/home/widget/filter_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/view/screens/home/widget/module_view.dart';
import 'package:sixam_mart/view/screens/parcel/parcel_category_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static Future<void> loadData(bool reload) async {
    Get.find<LocationController>().syncZoneData();
    Get.find<FlashSaleController>().setEmptyFlashSale();
    if (Get.find<SplashController>().module != null &&
        !Get.find<SplashController>()
            .configModel!
            .moduleConfig!
            .module!
            .isParcel!) {
      Get.find<BannerController>().getBannerList(reload);
      if (Get.find<SplashController>().module!.moduleType.toString() ==
          AppConstants.grocery) {
        Get.find<FlashSaleController>().getFlashSale(reload, false);
      }
      if (Get.find<SplashController>().module!.moduleType.toString() ==
          AppConstants.ecommerce) {
        Get.find<ItemController>().getFeaturedCategoriesItemList(false, false);
        Get.find<FlashSaleController>().getFlashSale(reload, false);
      }
      Get.find<BannerController>().getPromotionalBanner(reload);
      Get.find<ItemController>().getDiscountedItemList(reload, false);
      Get.find<CategoryController>().getCategoryList(reload);
      Get.find<StoreController>().getPopularStoreList(reload, 'all', false);
      Get.find<CampaignController>().getBasicCampaignList(reload);
      Get.find<CampaignController>().getItemCampaignList(reload);
      Get.find<ItemController>().getPopularItemList(reload, 'all', false);
      Get.find<StoreController>().getLatestStoreList(reload, 'all', false);
      Get.find<ItemController>().getReviewedItemList(reload, 'all', false);
      Get.find<ItemController>().getRecommendedItemList(reload, 'all', false);
      Get.find<StoreController>().getStoreList(1, reload);
      Get.find<StoreController>().getRecommendedStoreList();
    }
    if (Get.find<AuthController>().isLoggedIn()) {
      Get.find<UserController>().getUserInfo();
      Get.find<NotificationController>().getNotificationList(reload);
      Get.find<StoreController>().getVisitAgainStoreList();
      Get.find<CouponController>().getCouponList();
    }
    Get.find<SplashController>().getModules();
    if (Get.find<SplashController>().module == null &&
        Get.find<SplashController>().configModel!.module == null) {
      Get.find<BannerController>().getFeaturedBanner();
      Get.find<StoreController>().getFeaturedStoreList();
      if (Get.find<AuthController>().isLoggedIn()) {
        Get.find<LocationController>().getAddressList();
      }
    }
    if (Get.find<SplashController>().module != null &&
        Get.find<SplashController>()
            .configModel!
            .moduleConfig!
            .module!
            .isParcel!) {
      Get.find<ParcelController>().getParcelCategoryList();
    }
    if (Get.find<SplashController>().module != null &&
        Get.find<SplashController>().module!.moduleType.toString() ==
            AppConstants.pharmacy) {
      Get.find<ItemController>().getBasicMedicine(reload, false);
      Get.find<StoreController>().getFeaturedStoreList();
      await Get.find<ItemController>().getCommonConditions(false);
      if (Get.find<ItemController>().commonConditions!.isNotEmpty) {
        Get.find<ItemController>().getConditionsWiseItem(
            Get.find<ItemController>().commonConditions![0].id!, false);
      }
    }
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    HomeScreen.loadData(false);
    if (!ResponsiveHelper.isWeb()) {
      Get.find<LocationController>().getZone(
          Get.find<LocationController>().getUserAddress()!.latitude,
          Get.find<LocationController>().getUserAddress()!.longitude,
          false,
          updateInAddress: true);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(builder: (splashController) {
      bool showMobileModule = !ResponsiveHelper.isDesktop(context) &&
          splashController.module == null &&
          splashController.configModel!.module == null;
      bool isParcel = splashController.module != null &&
          splashController.configModel!.moduleConfig!.module!.isParcel!;
      bool isPharmacy = splashController.module != null &&
          splashController.module!.moduleType.toString() ==
              AppConstants.pharmacy;
      bool isFood = splashController.module != null &&
          splashController.module!.moduleType.toString() == AppConstants.food;
      bool isShop = splashController.module != null &&
          splashController.module!.moduleType.toString() ==
              AppConstants.ecommerce;
      bool isGrocery = splashController.module != null &&
          splashController.module!.moduleType.toString() ==
              AppConstants.grocery;
      // bool isTaxiBooking = splashController.module != null && splashController.configModel!.moduleConfig!.module!.isTaxi!;

      return Scaffold(
        appBar: ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : null,
        endDrawer: const MenuDrawer(),
        endDrawerEnableOpenDragGesture: false,
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: /*isTaxiBooking ? const RiderHomeScreen() :*/ isParcel
            ? const ParcelCategoryScreen()
            : SafeArea(
                child: RefreshIndicator(
                  onRefresh: () async {
                    splashController.setRefreshing(true);
                    if (Get.find<SplashController>().module != null) {
                      await Get.find<LocationController>().syncZoneData();
                      await Get.find<BannerController>().getBannerList(true);
                      if (isGrocery) {
                        await Get.find<FlashSaleController>()
                            .getFlashSale(true, true);
                      }
                      await Get.find<BannerController>()
                          .getPromotionalBanner(true);
                      await Get.find<ItemController>()
                          .getDiscountedItemList(true, false);
                      await Get.find<CategoryController>()
                          .getCategoryList(true);
                      await Get.find<StoreController>()
                          .getPopularStoreList(true, 'all', false);
                      await Get.find<CampaignController>()
                          .getItemCampaignList(true);
                      Get.find<CampaignController>().getBasicCampaignList(true);
                      await Get.find<ItemController>()
                          .getPopularItemList(true, 'all', false);
                      await Get.find<StoreController>()
                          .getLatestStoreList(true, 'all', false);
                      await Get.find<ItemController>()
                          .getReviewedItemList(true, 'all', false);
                      await Get.find<StoreController>().getStoreList(1, true);
                      if (Get.find<AuthController>().isLoggedIn()) {
                        await Get.find<UserController>().getUserInfo();
                        await Get.find<NotificationController>()
                            .getNotificationList(true);
                        Get.find<CouponController>().getCouponList();
                      }
                      if (isPharmacy) {
                        Get.find<ItemController>().getBasicMedicine(true, true);
                        Get.find<ItemController>().getCommonConditions(true);
                      }
                      if (isShop) {
                        await Get.find<FlashSaleController>()
                            .getFlashSale(true, true);
                        Get.find<ItemController>()
                            .getFeaturedCategoriesItemList(true, true);
                      }
                    } else {
                      await Get.find<BannerController>().getFeaturedBanner();
                      await Get.find<SplashController>().getModules();
                      if (Get.find<AuthController>().isLoggedIn()) {
                        await Get.find<LocationController>().getAddressList();
                      }
                      await Get.find<StoreController>().getFeaturedStoreList();
                    }
                    splashController.setRefreshing(false);
                  },
                  child: ResponsiveHelper.isDesktop(context)
                      ? WebNewHomeScreen(
                          scrollController: _scrollController,
                        )
                      : CustomScrollView(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          slivers: [
                            /// App Bar
                            SliverAppBar(
                              floating: true,
                              elevation: 0,
                              automaticallyImplyLeading: false,
                              backgroundColor:
                                  ResponsiveHelper.isDesktop(context)
                                      ? Colors.transparent
                                      : Theme.of(context).colorScheme.surface,
                              toolbarHeight: 100,
                              title: Container(
                                width: Dimensions.webMaxWidth,
                                height: Get.find<LocalizationController>().isLtr
                                    ? 100
                                    : 80,
                                color: Theme.of(context).colorScheme.surface,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      const SizedBox(
                                          height:
                                              Dimensions.paddingSizeDefault),
                                      GetBuilder<LocationController>(
                                          builder: (locationController) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: Dimensions
                                                .paddingSizeExtremeLarge,
                                          ),
                                          child: Text(
                                            locationController
                                                .getUserAddress()!
                                                .addressType!
                                                .tr,
                                            style: robotoMedium.copyWith(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .color,
                                              fontSize:
                                                  Dimensions.fontSizeDefault,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        );
                                      }),
                                      Expanded(
                                          child: InkWell(
                                        onTap: () =>
                                            Get.find<LocationController>()
                                                .navigateToLocationScreen(
                                                    'home'),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical:
                                                Dimensions.paddingSizeSmall,
                                            horizontal: ResponsiveHelper
                                                    .isDesktop(context)
                                                ? Dimensions.paddingSizeSmall
                                                : 0,
                                          ),
                                          child: GetBuilder<LocationController>(
                                              builder: (locationController) {
                                            return Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                (splashController.module !=
                                                            null &&
                                                        splashController
                                                                .configModel!
                                                                .module ==
                                                            null)
                                                    ? InkWell(
                                                        onTap: () =>
                                                            splashController
                                                                .removeModule(),
                                                        child: Image.asset(
                                                            Images.moduleIcon,
                                                            height: 25,
                                                            width: 25,
                                                            color: Colors.red),
                                                      )
                                                    : const SizedBox(),
                                                SizedBox(
                                                    width: (splashController
                                                                    .module !=
                                                                null &&
                                                            splashController
                                                                    .configModel!
                                                                    .module ==
                                                                null)
                                                        ? Dimensions
                                                            .paddingSizeSmall
                                                        : 0),
                                                Expanded(
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .all(Dimensions
                                                            .paddingSizeSmall),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  6)),
                                                      border: Border.all(
                                                          width: 1,
                                                          color: Colors.grey),
                                                    ),
                                                    child: Row(children: [
                                                      const Icon(
                                                        Icons.location_on,
                                                        color:
                                                            Color(0xFFFE0100),
                                                        size: 22,
                                                      ),
                                                      const SizedBox(
                                                          width: Dimensions
                                                              .paddingSizeSmall),
                                                      Flexible(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .stretch,
                                                          children: [
                                                            Text(
                                                              'Delivering to:',
                                                              style:
                                                                  robotoRegular
                                                                      .copyWith(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: Dimensions
                                                                    .fontSizeExtraSmall,
                                                              ),
                                                            ),
                                                            Text(
                                                              locationController
                                                                  .getUserAddress()!
                                                                  .address!,
                                                              style:
                                                                  robotoRegular
                                                                      .copyWith(
                                                                color:
                                                                    Colors.red,
                                                                fontSize: Dimensions
                                                                    .fontSizeSmall,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const Icon(
                                                        Icons.expand_more,
                                                        color: Colors.red,
                                                        size: 18,
                                                      ),
                                                    ]),
                                                  ),
                                                ),
                                                const SizedBox(
                                                    width: Dimensions
                                                        .paddingSizeDefault),
                                                InkWell(
                                                  child: GetBuilder<
                                                          NotificationController>(
                                                      builder:
                                                          (notificationController) {
                                                    return Stack(children: [
                                                      Icon(CupertinoIcons.bell,
                                                          size: 25,
                                                          color:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge!
                                                                  .color),
                                                      notificationController
                                                              .hasNotification
                                                          ? Positioned(
                                                              top: 0,
                                                              right: 0,
                                                              child: Container(
                                                                height: 10,
                                                                width: 10,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  border: Border.all(
                                                                      width: 1,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .cardColor),
                                                                ),
                                                              ))
                                                          : const SizedBox(),
                                                    ]);
                                                  }),
                                                  onTap: () => Get.toNamed(
                                                      RouteHelper
                                                          .getNotificationRoute()),
                                                ),
                                              ],
                                            );
                                          }),
                                        ),
                                      )),
                                    ]),
                              ),
                              actions: const [SizedBox()],
                            ),

                            /// Search Button
                            !showMobileModule
                                ? SliverPersistentHeader(
                                    pinned: true,
                                    delegate: SliverDelegate(
                                        child: Center(
                                            child: Container(
                                      height: 50, width: Dimensions.webMaxWidth,
                                      // color: Theme.of(context).colorScheme.background,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              Dimensions.paddingSizeSmall),
                                      child: InkWell(
                                        onTap: () => Get.toNamed(
                                            RouteHelper.getSearchRoute()),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal:
                                                  Dimensions.paddingSizeSmall),
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 3),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                            border: Border.all(
                                                color: Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.2),
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  spreadRadius: 1,
                                                  blurRadius: 5,
                                                  offset: const Offset(2, 3))
                                            ],
                                          ),
                                          child: Row(children: [
                                            Icon(
                                              CupertinoIcons.search,
                                              size: 25,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            const SizedBox(
                                                width: Dimensions
                                                    .paddingSizeExtraSmall),
                                            Expanded(
                                                child: Text(
                                              Get.find<SplashController>()
                                                      .configModel!
                                                      .moduleConfig!
                                                      .module!
                                                      .showRestaurantText!
                                                  ? 'search_food_or_restaurant'
                                                      .tr
                                                  : 'search_item_or_store'.tr,
                                              style: robotoRegular.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall,
                                                color:
                                                    Theme.of(context).hintColor,
                                              ),
                                            )),
                                          ]),
                                        ),
                                      ),
                                    ))),
                                  )
                                : const SliverToBoxAdapter(),

                            SliverToBoxAdapter(
                              child: Center(
                                  child: SizedBox(
                                width: Dimensions.webMaxWidth,
                                child: !showMobileModule
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                            isGrocery
                                                ? const GroceryHomeScreen()
                                                : isPharmacy
                                                    ? const PharmacyHomeScreen()
                                                    : isFood
                                                        ? const FoodHomeScreen()
                                                        : isShop
                                                            ? const ShopHomeScreen()
                                                            : const SizedBox(),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  Get.find<LocalizationController>()
                                                          .isLtr
                                                      ? 10
                                                      : 0,
                                                  15,
                                                  0,
                                                  5),
                                              child:
                                                  GetBuilder<StoreController>(
                                                      builder:
                                                          (storeController) {
                                                return Row(children: [
                                                  Expanded(
                                                      child: Padding(
                                                    padding: EdgeInsets.only(
                                                        right: Get.find<
                                                                    LocalizationController>()
                                                                .isLtr
                                                            ? 0
                                                            : 10),
                                                    child: Text(
                                                      '${storeController.storeModel?.totalSize ?? 0} ${Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText! ? 'restaurants'.tr : 'stores'.tr}',
                                                      style: robotoMedium.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeLarge),
                                                    ),
                                                  )),
                                                  FilterView(
                                                      storeController:
                                                          storeController),
                                                ]);
                                              }),
                                            ),
                                            GetBuilder<StoreController>(
                                                builder: (storeController) {
                                              return PaginatedListView(
                                                scrollController:
                                                    _scrollController,
                                                totalSize: storeController
                                                    .storeModel?.totalSize,
                                                offset: storeController
                                                    .storeModel?.offset,
                                                onPaginate:
                                                    (int? offset) async =>
                                                        await storeController
                                                            .getStoreList(
                                                                offset!, false),
                                                itemView: ItemsView(
                                                  isStore: true,
                                                  items: null,
                                                  isFoodOrGrocery:
                                                      (isFood || isGrocery),
                                                  stores: storeController
                                                      .storeModel?.stores,
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: ResponsiveHelper
                                                            .isDesktop(context)
                                                        ? Dimensions
                                                            .paddingSizeExtraSmall
                                                        : Dimensions
                                                            .paddingSizeSmall,
                                                    vertical: ResponsiveHelper
                                                            .isDesktop(context)
                                                        ? Dimensions
                                                            .paddingSizeExtraSmall
                                                        : Dimensions
                                                            .paddingSizeDefault,
                                                  ),
                                                ),
                                              );
                                            }),
                                            SizedBox(
                                                height:
                                                    ResponsiveHelper.isDesktop(
                                                            context)
                                                        ? 0
                                                        : 100),
                                          ])
                                    : ModuleView(
                                        splashController: splashController),
                              )),
                            ),
                          ],
                        ),
                ),
              ),
      );
    });
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 ||
        oldDelegate.minExtent != 50 ||
        child != oldDelegate.child;
  }
}
