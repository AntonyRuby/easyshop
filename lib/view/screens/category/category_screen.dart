import 'package:sixam_mart/controller/category_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_app_bar.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:sixam_mart/view/base/footer_view.dart';
import 'package:sixam_mart/view/base/menu_drawer.dart';
import 'package:sixam_mart/view/base/no_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/view/base/web_page_title_widget.dart';
import 'package:sixam_mart/data/model/response/store_model.dart';
import 'package:sixam_mart/view/screens/store/store_screen.dart';

class CategoryScreen extends StatefulWidget {
  final Store? store;

  const CategoryScreen({super.key, required this.store});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Get.find<CategoryController>().getCategoryList(false);
  }

  @override
  Widget build(BuildContext context) {
    final store = widget.store ?? Get.arguments['store'];
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: CustomAppBar(title: 'categories'.tr),
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: SafeArea(
          child: Scrollbar(
              controller: scrollController,
              child: SingleChildScrollView(
                  controller: scrollController,
                  child: FooterView(
                      child: Column(
                    children: [
                      WebScreenTitleWidget(title: 'categories'.tr),
                      SizedBox(
                        width: Dimensions.webMaxWidth,
                        child: GetBuilder<CategoryController>(
                            builder: (categoryController) {
                          return categoryController.categoryList != null
                              ? categoryController.categoryList!.isNotEmpty
                                  ? GridView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: ResponsiveHelper
                                                .isDesktop(context)
                                            ? 6
                                            : ResponsiveHelper.isTab(context)
                                                ? 4
                                                : 3,
                                        childAspectRatio: (0.75 / 0.90),
                                        mainAxisSpacing:
                                            Dimensions.paddingSizeSmall,
                                        crossAxisSpacing:
                                            Dimensions.paddingSizeSmall,
                                      ),
                                      padding: const EdgeInsets.all(
                                          Dimensions.paddingSizeSmall),
                                      itemCount: categoryController
                                          .categoryList!.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            //   Get.toNamed(
                                            //     RouteHelper.getStoreRoute(
                                            //         id: widget.store?.id,
                                            //         page: 'item'),
                                            //     arguments: {
                                            //       'store': widget.store,
                                            //       'fromModule': false,
                                            //       'selectedCategory':
                                            //           catController
                                            //               .categoryList![index]
                                            //               .id,
                                            //     },
                                            //   );

                                            //                      Get.toNamed(RouteHelper.getCategoryItemRoute(
                                            //   categoryController.categoryList![index].id,
                                            //   categoryController.categoryList![index].name!,
                                            // )),

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      StoreScreen(
                                                        store: store,
                                                        fromModule: false,
                                                        selectedIndex: index,
                                                        categoryID:
                                                            categoryController
                                                                .categoryList![
                                                                    index]
                                                                .id
                                                                .toString(),
                                                        categoryName:
                                                            categoryController
                                                                .categoryList![
                                                                    index]
                                                                .name!,
                                                      )),
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  Theme.of(context).cardColor,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.radiusSmall),
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: Colors.black12,
                                                    blurRadius: 5,
                                                    spreadRadius: 1)
                                              ],
                                            ),
                                            alignment: Alignment.center,
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Dimensions
                                                                .radiusSmall),
                                                    child: CustomImage(
                                                      height: 100,
                                                      width: 100,
                                                      fit: BoxFit.cover,
                                                      image:
                                                          '${Get.find<SplashController>().configModel!.baseUrls!.categoryImageUrl}/${categoryController.categoryList![index].image}',
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                      height: Dimensions
                                                          .paddingSizeSmall),
                                                  Text(
                                                    categoryController
                                                        .categoryList![index]
                                                        .name!,
                                                    textAlign: TextAlign.center,
                                                    style:
                                                        robotoMedium.copyWith(
                                                            fontSize: Dimensions
                                                                .fontSizeSmall),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ]),
                                          ),
                                        );
                                      },
                                    )
                                  : NoDataScreen(text: 'no_category_found'.tr)
                              : const Center(
                                  child: CircularProgressIndicator());
                        }),
                      ),
                    ],
                  ))))),
    );
  }
}
