import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class PaginatedListView extends StatefulWidget {
  final ScrollController scrollController;
  final Function(int? offset) onPaginate;
  final Function? onPaginateEnd;
  final int? totalSize;
  final int? offset;
  final Widget itemView;
  final bool enabledPagination;
  final bool reverse;
  final NotificationListenerCallback<ScrollNotification>? notificationListener;
  const PaginatedListView({
    Key? key,
    required this.scrollController,
    required this.onPaginate,
    required this.totalSize,
    required this.offset,
    required this.itemView,
    this.enabledPagination = true,
    this.reverse = false,
    this.onPaginateEnd,
    this.notificationListener,
  }) : super(key: key);

  @override
  State<PaginatedListView> createState() => _PaginatedListViewState();
}

class _PaginatedListViewState extends State<PaginatedListView> {
  int? _offset;
  late List<int?> _offsetList;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _offset = 1;
    _offsetList = [1];

    widget.scrollController.addListener(() {
      // print("test 1");
      if (widget.scrollController.position.pixels ==
          widget.scrollController.position.maxScrollExtent) {
        if (widget.onPaginateEnd != null) {
          widget.onPaginateEnd!();
        }
      }
      if (widget.scrollController.position.pixels ==
              widget.scrollController.position.maxScrollExtent &&
          widget.totalSize != null &&
          !_isLoading &&
          widget.enabledPagination) {
        print("tset 2");
        if (mounted && !ResponsiveHelper.isDesktop(context)) {
          print("tset 3");
          _paginate();
        }
      }
    });
  }

  void _paginate() async {
    int pageSize = (widget.totalSize! / 10).ceil();
    if (_offset! < pageSize && !_offsetList.contains(_offset! + 1)) {
      setState(() {
        _offset = _offset! + 1;
        _offsetList.add(_offset);
        _isLoading = true;
      });
      await widget.onPaginate(_offset);
      setState(() {
        _isLoading = false;
      });
    } else {
      if (_isLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.offset != null) {
      _offset = widget.offset;
      _offsetList = [];
      for (int index = 1; index <= widget.offset!; index++) {
        _offsetList.add(index);
      }
    }

    return Column(children: [
      widget.reverse ? const SizedBox() : widget.itemView,
      (ResponsiveHelper.isDesktop(context) &&
              (widget.totalSize == null ||
                  _offset! >= (widget.totalSize! / 10).ceil() ||
                  _offsetList.contains(_offset! + 1)))
          ? const SizedBox()
          : Center(
              child: Padding(
              padding: (_isLoading || ResponsiveHelper.isDesktop(context))
                  ? const EdgeInsets.all(Dimensions.paddingSizeSmall)
                  : EdgeInsets.zero,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : (ResponsiveHelper.isDesktop(context) &&
                          widget.totalSize != null)
                      ? InkWell(
                          onTap: _paginate,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: Dimensions.paddingSizeSmall,
                                horizontal: Dimensions.paddingSizeLarge),
                            margin: ResponsiveHelper.isDesktop(context)
                                ? const EdgeInsets.only(
                                    top: Dimensions.paddingSizeSmall)
                                : null,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radiusSmall),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Text('view_more'.tr,
                                style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeLarge,
                                    color: Colors.white)),
                          ),
                        )
                      : const SizedBox(),
            )),
      widget.reverse ? widget.itemView : const SizedBox(),
    ]);
  }
}
