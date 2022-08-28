import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketplace/utils/constants.dart' as AppConst;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:shimmer/shimmer.dart';

class WppProductImage extends StatelessWidget {
  const WppProductImage({
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
        child: Image(
          image: NetworkImage(
            image,
            // "https://picsum.photos/200",
          ),
          width: width,
          height: height,
          fit: BoxFit.cover,
          errorBuilder:
              (BuildContext context, Object exception, StackTrace stackTrace) {
            return Image.asset(
              AppImg.img_error,
              width: width,
              height: height,
              fit: BoxFit.contain,
            );
          },
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) {
              return child;
            } else {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: frame != null
                    ? child
                    : Container(
                        width: width,
                        height: height,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(10)),
                          color: Colors.grey[200],
                        ),
                      ),
              );
            }
          },
        ));
  }
}
