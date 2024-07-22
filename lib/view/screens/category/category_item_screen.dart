import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/controller/category_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/model/response/item_model.dart';
import 'package:sixam_mart/data/model/response/store_model.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/cart_widget.dart';
import 'package:sixam_mart/view/base/item_view.dart';
import 'package:sixam_mart/view/base/menu_drawer.dart';
import 'package:sixam_mart/view/base/veg_filter_widget.dart';
import 'package:sixam_mart/view/base/web_menu_bar.dart';

class CategoryItemScreen extends StatefulWidget {
  final String? categoryID;
  final String categoryName;
  const CategoryItemScreen(
      {super.key, required this.categoryID, required this.categoryName});

  @override
  CategoryItemScreenState createState() => CategoryItemScreenState();
}

class CategoryItemScreenState extends State<CategoryItemScreen> {
  final ScrollController scrollController = ScrollController();
  final ScrollController storeScrollController = ScrollController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Fetch the category store list
    Get.find<CategoryController>().getSubCategoryList(widget.categoryID);
    Get.find<CategoryController>().getCategoryStoreList(
      widget.categoryID,
      1,
      Get.find<CategoryController>().type,
      true,
    );

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          Get.find<CategoryController>().categoryStoreList != null &&
          !Get.find<CategoryController>().isLoading) {
        int pageSize =
            (Get.find<CategoryController>().restPageSize! / 10).ceil();
        if (Get.find<CategoryController>().offset < pageSize) {
          if (kDebugMode) {
            print('end of the page');
          }
          Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getCategoryStoreList(
            Get.find<CategoryController>().subCategoryIndex == 0
                ? widget.categoryID
                : Get.find<CategoryController>()
                    .subCategoryList![
                        Get.find<CategoryController>().subCategoryIndex]
                    .id
                    .toString(),
            Get.find<CategoryController>().offset + 1,
            Get.find<CategoryController>().type,
            false,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (catController) {
      List<Store>? stores;
      if (catController.isSearching
          ? catController.searchStoreList != null
          : catController.categoryStoreList != null) {
        stores = [];
        if (catController.isSearching) {
          stores.addAll(catController.searchStoreList!);
        } else {
          stores.addAll(catController.categoryStoreList!);
        }
      }

      return WillPopScope(
        onWillPop: () async {
          if (catController.isSearching) {
            catController.toggleSearch();
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          appBar: (ResponsiveHelper.isDesktop(context)
              ? const WebMenuBar()
              : AppBar(
                  title: catController.isSearching
                      ? TextField(
                          autofocus: true,
                          textInputAction: TextInputAction.search,
                          decoration: const InputDecoration(
                            hintText: 'Search...',
                            border: InputBorder.none,
                          ),
                          style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeLarge),
                          onSubmitted: (String query) {
                            catController.searchData(
                              query,
                              catController.subCategoryIndex == 0
                                  ? widget.categoryID
                                  : catController
                                      .subCategoryList![
                                          catController.subCategoryIndex]
                                      .id
                                      .toString(),
                              catController.type,
                            );
                          })
                      : Text(widget.categoryName,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          )),
                  centerTitle: true,
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.red,
                    ),
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    onPressed: () {
                      if (catController.isSearching) {
                        catController.toggleSearch();
                      } else {
                        Get.back();
                      }
                    },
                  ),
                  backgroundColor: Theme.of(context).cardColor,
                  elevation: 0,
                  actions: [
                    IconButton(
                      onPressed: () => catController.toggleSearch(),
                      icon: Icon(
                        catController.isSearching
                            ? Icons.close_sharp
                            : Icons.search,
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.toNamed(RouteHelper.getCartRoute()),
                      icon: CartWidget(
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                          size: 25),
                    ),
                    VegFilterWidget(
                        type: catController.type,
                        fromAppBar: true,
                        onSelected: (String type) {
                          if (catController.isSearching) {
                            catController.searchData(
                              catController.subCategoryIndex == 0
                                  ? widget.categoryID
                                  : catController
                                      .subCategoryList![
                                          catController.subCategoryIndex]
                                      .id
                                      .toString(),
                              '1',
                              type,
                            );
                          } else {
                            catController.getCategoryStoreList(
                              catController.subCategoryIndex == 0
                                  ? widget.categoryID
                                  : catController
                                      .subCategoryList![
                                          catController.subCategoryIndex]
                                      .id
                                      .toString(),
                              1,
                              type,
                              true,
                            );
                          }
                        }),
                  ],
                )) as PreferredSizeWidget?,
          endDrawer: const MenuDrawer(),
          endDrawerEnableOpenDragGesture: false,
          body: Center(
              child: SizedBox(
            width: Dimensions.webMaxWidth,
            child: Column(children: [
              (catController.subCategoryList != null &&
                      !catController.isSearching)
                  ? Center(
                      child: Container(
                      height: 40,
                      width: Dimensions.webMaxWidth,
                      color: Theme.of(context).cardColor,
                      padding: const EdgeInsets.symmetric(
                          vertical: Dimensions.paddingSizeExtraSmall),
                      child: ListView.builder(
                        key: scaffoldKey,
                        scrollDirection: Axis.horizontal,
                        itemCount: catController.subCategoryList!.length,
                        padding: const EdgeInsets.only(
                            left: Dimensions.paddingSizeSmall),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              catController.setSubCategoryIndex(
                                  index, widget.categoryID);
                              String? categoryId =
                                  catController.subCategoryIndex == 0
                                      ? widget.categoryID
                                      : catController
                                          .subCategoryList![
                                              catController.subCategoryIndex]
                                          .id
                                          .toString();
                              catController.getCategoryStoreList(
                                  categoryId, 1, catController.type, true);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.paddingSizeSmall,
                                  vertical: Dimensions.paddingSizeExtraSmall),
                              margin: const EdgeInsets.only(
                                  right: Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radiusSmall),
                                color: index == catController.subCategoryIndex
                                    ? Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.1)
                                    : Colors.transparent,
                              ),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      catController
                                          .subCategoryList![index].name!,
                                      style: index ==
                                              catController.subCategoryIndex
                                          ? robotoMedium.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall,
                                              color: Theme.of(context)
                                                  .primaryColor)
                                          : robotoRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall),
                                    ),
                                  ]),
                            ),
                          );
                        },
                      ),
                    ))
                  : const SizedBox(),
              Text(Get.find<SplashController>()
                      .configModel!
                      .moduleConfig!
                      .module!
                      .showRestaurantText!
                  ? 'restaurants'.tr
                  : 'stores'.tr),
              Expanded(
                child: NotificationListener(
                  onNotification: (dynamic scrollNotification) {
                    if (scrollNotification is ScrollEndNotification) {
                      // Fetch more data if scrolled to the bottom
                      if (scrollController.position.pixels ==
                              scrollController.position.maxScrollExtent &&
                          catController.categoryStoreList != null &&
                          !catController.isLoading) {
                        int pageSize =
                            (catController.restPageSize! / 10).ceil();
                        if (catController.offset < pageSize) {
                          if (kDebugMode) {
                            print('End of the page');
                          }
                          catController.showBottomLoader();
                          catController.getCategoryStoreList(
                            catController.subCategoryIndex == 0
                                ? widget.categoryID
                                : catController
                                    .subCategoryList![
                                        catController.subCategoryIndex]
                                    .id
                                    .toString(),
                            catController.offset + 1,
                            catController.type,
                            false,
                          );
                        }
                      }
                    }
                    return false;
                  },
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: ItemsView(
                      isStore: true,
                      items: null,
                      stores: stores,
                      noDataText: Get.find<SplashController>()
                              .configModel!
                              .moduleConfig!
                              .module!
                              .showRestaurantText!
                          ? 'no_category_restaurant_found'.tr
                          : 'no_category_store_found'.tr,
                    ),
                  ),
                ),
              ),
              catController.isLoading
                  ? Center(
                      child: Padding(
                        padding:
                            const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor)),
                      ),
                    )
                  : const SizedBox(),
            ]),
          )),
        ),
      );
    });
  }
}

class SubCategoryItemScreen extends StatefulWidget {
  final String? categoryID;
  final String categoryName;
  const SubCategoryItemScreen(
      {super.key, required this.categoryID, required this.categoryName});

  @override
  SubCategoryItemScreenState createState() => SubCategoryItemScreenState();
}

class SubCategoryItemScreenState extends State<SubCategoryItemScreen>
    with TickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Get.find<CategoryController>().getSubCategoryList(widget.categoryID);
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          Get.find<CategoryController>().categoryItemList != null &&
          !Get.find<CategoryController>().isLoading) {
        int pageSize = (Get.find<CategoryController>().pageSize! / 10).ceil();
        if (Get.find<CategoryController>().offset < pageSize) {
          if (kDebugMode) {
            print('end of the page');
          }
          Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getCategoryItemList(
            Get.find<CategoryController>().subCategoryIndex == 0
                ? widget.categoryID
                : Get.find<CategoryController>()
                    .subCategoryList![
                        Get.find<CategoryController>().subCategoryIndex]
                    .id
                    .toString(),
            Get.find<CategoryController>().offset + 1,
            Get.find<CategoryController>().type,
            false,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (catController) {
      List<Item>? item;
      if (catController.isSearching
          ? catController.searchItemList != null
          : catController.categoryItemList != null) {
        item = [];
        if (catController.isSearching) {
          item.addAll(catController.searchItemList!);
        } else {
          item.addAll(catController.categoryItemList!);
        }
      }

      return Column(children: [
        Row(
          children: [
            catController.isSearching
                ? TextField(
                    autofocus: true,
                    textInputAction: TextInputAction.search,
                    decoration: const InputDecoration(
                      hintText: 'Search...',
                      border: InputBorder.none,
                    ),
                    style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeLarge),
                    onSubmitted: (String query) {
                      catController.searchData(
                        query,
                        catController.subCategoryIndex == 0
                            ? widget.categoryID
                            : catController
                                .subCategoryList![
                                    catController.subCategoryIndex]
                                .id
                                .toString(),
                        catController.type,
                      );
                    })
                : Text(widget.categoryName,
                    style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    )),
            IconButton(
                onPressed: () => catController.toggleSearch(),
                icon: Icon(
                  catController.isSearching ? Icons.close_sharp : Icons.search,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                )),
          ],
        ),
        (catController.subCategoryList != null && !catController.isSearching)
            ? Container(
                height: 40,
                width: Dimensions.webMaxWidth,
                color: Theme.of(context).cardColor,
                padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.paddingSizeExtraSmall),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: catController.subCategoryList!.length,
                  padding:
                      const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => catController.setSubCategoryIndex(
                          index, widget.categoryID),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeSmall,
                            vertical: Dimensions.paddingSizeExtraSmall),
                        margin: const EdgeInsets.only(
                            right: Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radiusSmall),
                          color: index == catController.subCategoryIndex
                              ? Theme.of(context).primaryColor.withOpacity(0.1)
                              : Colors.transparent,
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                catController.subCategoryList![index].name!,
                                style: index == catController.subCategoryIndex
                                    ? robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: Theme.of(context).primaryColor)
                                    : robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall),
                              ),
                            ]),
                      ),
                    );
                  },
                ),
              )
            : const SizedBox(),
        NotificationListener(
          onNotification: (dynamic scrollNotification) {
            if (scrollNotification is ScrollEndNotification) {
              if (catController.isSearching) {
                catController.searchData(
                  catController.searchText,
                  catController.subCategoryIndex == 0
                      ? widget.categoryID
                      : catController
                          .subCategoryList![catController.subCategoryIndex].id
                          .toString(),
                  catController.type,
                );
              } else {
                if (catController.offset <
                    (Get.find<CategoryController>().pageSize! / 10).ceil()) {
                  if (kDebugMode) {
                    print('end of the page');
                  }
                  Get.find<CategoryController>().showBottomLoader();
                  Get.find<CategoryController>().getCategoryItemList(
                    catController.subCategoryIndex == 0
                        ? widget.categoryID
                        : catController
                            .subCategoryList![catController.subCategoryIndex].id
                            .toString(),
                    catController.offset + 1,
                    catController.type,
                    false,
                  );
                }
              }
            }
            return false;
          },
          child: SingleChildScrollView(
            controller: scrollController,
            child: ItemsView(
              isStore: false,
              items: item,
              stores: null,
              noDataText: 'no_category_item_found'.tr,
            ),
          ),
        ),
        catController.isLoading
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor)),
                ),
              )
            : const SizedBox(),
      ]);
    });
  }
}
