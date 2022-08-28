import 'package:flutter/material.dart';
import 'package:marketplace/data/models/new_models/order.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;

class RingkasanPembayaranSupplier extends StatelessWidget {
  const RingkasanPembayaranSupplier({
    Key key,
    @required this.data,
  }) : super(key: key);

  final OrderDetailSupplierResponseData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Ringkasan Pesanan",
          style:
          AppTypo.subtitle1.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Metode Pembayaran",
                  style: AppTypo.caption,
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(data.paymentMethod,
                    style: AppTypo.caption
                        .copyWith(fontWeight: FontWeight.w500)),
              ),
            )
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Subtotal Produk",
                  style: AppTypo.caption,
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(data.productSubtotal,
                    style: AppTypo.caption
                        .copyWith(fontWeight: FontWeight.w500)),
              ),
            )
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Subtotal Pengiriman",
                  style: AppTypo.caption,
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(data.shippingSubtotal,
                    style: AppTypo.caption
                        .copyWith(fontWeight: FontWeight.w500)),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Biaya Penanganan",
                  style: AppTypo.caption,
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(data.handlingFee,
                    style: AppTypo.caption
                        .copyWith(fontWeight: FontWeight.w500)),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Divider(
          thickness: 1,
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "TOTAL",
                  style: AppTypo.caption.copyWith(
                      color: Theme.of(context).primaryColor),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  data.totalPayment,
                  style: AppTypo.caption.copyWith(
                      color: Theme.of(context).primaryColor),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}