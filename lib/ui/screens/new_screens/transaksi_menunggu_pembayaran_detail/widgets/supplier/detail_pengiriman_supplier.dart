import 'package:flutter/material.dart';
import 'package:marketplace/data/models/new_models/order.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;

class DetailPengirimanSupplier extends StatelessWidget {
  const DetailPengirimanSupplier({
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
          "Detail Pengiriman",
          style: AppTypo.subtitle1.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Kurir Pengiriman",
                  style: AppTypo.caption,
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(data.courirer,
                    style:
                        AppTypo.caption.copyWith(fontWeight: FontWeight.w500)),
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
                  "No. Resi",
                  style: AppTypo.caption,
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text("-",
                    style:
                        AppTypo.caption.copyWith(fontWeight: FontWeight.w500)),
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
                  "Alamat Pengiriman",
                  style: AppTypo.caption,
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(data.shippingAddress,
                    textAlign: TextAlign.right,
                    style:
                        AppTypo.caption.copyWith(fontWeight: FontWeight.w500)),
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
                  "Alamat HUB",
                  textAlign: TextAlign.right,
                  style: AppTypo.caption,
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(data.hubAddress,
                    textAlign: TextAlign.right,
                    style:
                        AppTypo.caption.copyWith(fontWeight: FontWeight.w500)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
