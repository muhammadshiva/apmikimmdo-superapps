import 'package:flutter/material.dart';
import 'package:marketplace/data/models/new_models/order.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;

import 'detail_pesanan_item.dart';

class DetailPesananList extends StatelessWidget {
  const DetailPesananList({
    Key key,
    @required this.data,
  }) : super(key: key);

  final OrderDetailResponseData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Detail Pesanan",
          style: AppTypo.subtitle1.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 8,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < data.products.length; i++)
              DetailPesananItem(
                image: data.products[i].cover,
                itemName: data.products[i].name,
                qtyItem:
                    "${data.products[i].quantity}x ${data.products[i].price} ",
              ),
            Text(
              "Catatan: ${data.note ?? ""}",
              style: AppTypo.caption.copyWith(color: Colors.grey),
            ),
          ],
        )
      ],
    );
  }
}
