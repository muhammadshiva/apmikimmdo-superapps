import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/transitions.dart' as AppTrans;
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/constants.dart' as AppConst;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:shimmer/shimmer.dart';

class WppPaymentMethodItem extends StatefulWidget {
  const WppPaymentMethodItem({Key key, this.paymentMethod, this.onSelected})
      : super(key: key);

  final List<PaymentMethod> paymentMethod;
  final Function(PaymentMethod paymentSelected) onSelected;

  @override
  _WppPaymentMethodItemState createState() => _WppPaymentMethodItemState();
}

class _WppPaymentMethodItemState extends State<WppPaymentMethodItem> {
  int _selectedOpt = -1;

  @override
  Widget build(BuildContext context) {
    return widget.paymentMethod != null
        ? ListView.separated(
            key: Key("loaded_otp"),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              log('image: ' + '${widget.paymentMethod[index].image}');

              return _buildOption(
                
                  "${widget.paymentMethod[index].name}",
                  "${widget.paymentMethod[index].image}",
                  // NetworkImage(
                  //     "${AppConst.STORAGE_URL}/bank/${paymentMethod[id].image}"),
                  _selectedOpt == index, () {
                setState(() {
                  _selectedOpt = index;
                });
                widget.onSelected(widget.paymentMethod[index]);
              }, context);
            },
            separatorBuilder: (context, id) => SizedBox(
                  height: 15,
                ),
            itemCount: widget.paymentMethod.length)
        : SizedBox.shrink(
            key: Key("else_otp"),
          );
  }

  Widget _buildOption(String label, String imageUrl,
      bool selected, VoidCallback onTap, BuildContext context) {
    return GestureDetector(
      // borderRadius: BorderRadius.circular(7.5),
      // splashColor: AppColor.primaryLight1.withOpacity(0.3),
      // highlightColor: AppColor.primaryLight2.withOpacity(0.3),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.line, width: 1),
          borderRadius: BorderRadius.circular(7.5),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child:Image(
                      image: NetworkImage(
                        imageUrl,
                        // "https://picsum.photos/200",
                      ),
                      width: 60,
                      height: 56,
                      fit: BoxFit.contain,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace stackTrace) {
                        return Image.asset(
                          AppImg.img_error,
                          width: 60,
                          height: 56,
                          fit: BoxFit.contain,
                        );
                      },
                      frameBuilder:
                          (context, child, frame, wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded) {
                          return child;
                        } else {
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: frame != null
                                ? child
                                : Container(
                                    width: 60,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7.5),
                                      color: Colors.grey[200],
                                    ),
                                  ),
                          );
                        }
                      },
                    )
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: Text(
                label.toUpperCase(),
                style: AppTypo.body1Lato,
              ),
            ),
            selected
                ? Icon(
                    Icons.check_circle,
                    color: AppColor.primary,
                    size: 35,
                  )
                : SizedBox(),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
