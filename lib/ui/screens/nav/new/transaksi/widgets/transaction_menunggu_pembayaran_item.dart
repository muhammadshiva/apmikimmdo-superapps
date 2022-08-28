import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/transaksi_upload_review_photo/transaksi_upload_review_photo_cubit.dart';
import 'package:marketplace/data/models/new_models/order.dart';
import 'package:marketplace/ui/screens/nav/new/transaksi/widgets/transaksi_item_footer.dart';
import 'package:marketplace/ui/screens/nav/new/transaksi/widgets/transaksi_status.dart';
import 'package:marketplace/ui/screens/new_screens/transaksi_detail/transaksi_detail_screen.dart';
import 'package:marketplace/ui/screens/new_screens/transaksi_detail/transaksi_supplier_detail.dart';
import 'package:marketplace/ui/screens/new_screens/transaksi_menunggu_pembayaran_detail/transaksi_menunggu_pembayaran_detail_screen.dart';
import 'package:marketplace/ui/widgets/filled_button.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:shimmer/shimmer.dart';

import 'bs_transaksi_review.dart';

class TransaksiMenungguPembayaranItem extends StatelessWidget {
  const TransaksiMenungguPembayaranItem(
      {Key key, @required this.item, this.isSupplier = false})
      : super(key: key);

  final OrderMenungguPembayaranData item;
  final bool isSupplier;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
          if (isSupplier) {
            AppExt.pushScreen(
                context,
                TransaksiSupplierDetailScreen(
                  id: item.id,
                ));
          } else {
            AppExt.pushScreen(
                context,
                TransaksiMenungguPembayaranDetailScreen(
                  id: item.id,
                ));
          }
        
      },
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[300], width: 1.4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TransaksiStatus(
                label: item.status ?? '',
                kode: AppExt.convertDateToStringFormatId(item.createdAt),
                nama: "",
                orderDate: item.createdAt,
                isPembayaran: item.status == "Menunggu Pembayaran",
              ),
              SizedBox(
                height: 8,
              ),
              Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: kIsWeb
                              ? Image(
                                  image: NetworkImage(
                                    item.bankLogo,
                                    // "https://picsum.photos/200",
                                  ),
                                  width: double.infinity,
                                  height: 70,
                                  fit: BoxFit.contain,
                                  errorBuilder: (BuildContext context,
                                      Object exception, StackTrace stackTrace) {
                                    return Image.asset(
                                      AppImg.img_error,
                                      width: double.infinity,
                                      height: 70,
                                      fit: BoxFit.contain,
                                    );
                                  },
                                  frameBuilder: (context, child, frame,
                                      wasSynchronouslyLoaded) {
                                    if (wasSynchronouslyLoaded) {
                                      return child;
                                    } else {
                                      return AnimatedSwitcher(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        child: frame != null
                                            ? child
                                            : Container(
                                                width: double.infinity,
                                                height: 70,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                          top: Radius.circular(
                                                              10)),
                                                  color: Colors.grey[200],
                                                ),
                                              ),
                                      );
                                    }
                                  },
                                )
                              : CachedNetworkImage(
                                  imageUrl: item.bankLogo ?? "https://error",
                                  memCacheHeight: Get.height > 350
                                      ? (Get.height * 0.25).toInt()
                                      : Get.height,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                    baseColor: Colors.grey[300],
                                    highlightColor: Colors.grey[200],
                                    period: Duration(milliseconds: 1000),
                                    child: Container(
                                      width: double.infinity,
                                      height: 80,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(5),
                                              topRight: Radius.circular(5)),
                                          color: Colors.white),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    AppImg.img_error,
                                    width: double.infinity,
                                    height: 115,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.bankName,
                                style: AppTypo.caption
                                    .copyWith(fontWeight: FontWeight.w700),
                              ),
                              item.accountNumber != null
                                  ? Column(
                                      children: [
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(item.accountNumber ?? "",
                                            style: AppTypo.caption),
                                      ],
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: 5,
                              ),
                              Text(item.accountName,
                                  style: AppTypo.caption
                                      .copyWith(color: Colors.grey))
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Total Pembayaran",
                      style: AppTypo.caption.copyWith(fontSize: 12),
                    ),
                    Text(
                      item.amount,
                      style:
                          AppTypo.caption.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
