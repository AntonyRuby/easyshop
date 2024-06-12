import 'package:cached_network_image/cached_network_image.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:flutter/cupertino.dart';

class CustomImage extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final bool isNotification;
  final String placeholder;
  final Alignment alignment;

  const CustomImage({
    Key? key,
    required this.image,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.isNotification = false,
    this.placeholder = '',
    this.alignment = Alignment.center,
    holder = '',
  }) : super(key: key);

  // @override
  // Widget build(BuildContext context) {
  //   return CachedNetworkImage(
  //     imageUrl: image,
  //     height: height,
  //     width: width,
  //     fit: fit,
  //     placeholder: (context, url) => Image.asset(
  //         placeholder.isNotEmpty
  //             ? placeholder
  //             : isNotification
  //                 ? Images.notificationPlaceholder
  //                 : Images.placeholder,
  //         height: height,
  //         width: width,
  //         fit: fit),
  //     errorWidget: (context, url, error) => Image.asset(
  //         placeholder.isNotEmpty
  //             ? placeholder
  //             : isNotification
  //                 ? Images.notificationPlaceholder
  //                 : Images.placeholder,
  //         height: height,
  //         width: width,
  //         fit: fit),
  //     alignment: alignment,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    String imageValue = "";
    if (placeholder.isNotEmpty) {
      imageValue = placeholder;
    } else {
      if (isNotification) {
        imageValue = Images.notificationPlaceholder;
      } else {
        imageValue = Images.placeholder;
      }
    }
    return FastCachedImage(
      url: image,
      height: height,
      width: width,
      fit: fit,
      fadeInDuration: const Duration(seconds: 1),
      errorBuilder: (context, exception, stacktrace) => Image.asset(
        imageValue,
        height: height,
        width: width,
        fit: fit,
      ),
      loadingBuilder: (context, progress) => Image.asset(
        imageValue,
        height: height,
        width: width,
        fit: fit,
      ),
    );
  }
}
