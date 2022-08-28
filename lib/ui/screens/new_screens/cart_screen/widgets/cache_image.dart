import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketplace/utils/constants.dart' as AppConst;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:shimmer/shimmer.dart';

class CacheImage extends StatelessWidget {
  const CacheImage({
    Key key,
    @required this.image,
    this.height = 115,
    this.width = double.infinity,
    this.colorBlendMode = BlendMode.srcIn,
    this.color,
  }) : super(key: key);

  final String image;
  final double height;
  final double width;
  final BlendMode colorBlendMode;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CachedNetworkImage(
        imageUrl:
           image,
        memCacheHeight:
            Get.height > 350 ? (Get.height * 0.25).toInt() : Get.height,
        colorBlendMode: colorBlendMode,
        color: color,
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[200],
          period: Duration(milliseconds: 1000),
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15)
                ,
                color: Colors.white),
          ),
        ),
        errorWidget: (context, url, error) => Image.asset(
          AppImg.img_error,
          width: width,
          height: height,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
