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

  final OrderDetailMenungguPembayaranResponseData data;

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
          children: [
            for (var i = 0; i < data.orders.length; i++)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.orders[i].sellerName,
                    style:
                        AppTypo.caption.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    data.orders[i].sellerAddress,
                    style: AppTypo.caption.copyWith(color: Colors.grey),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  for (var p = 0; p < data.orders[i].items.length; p++)
                    DetailPesananItem(
                      image: data.orders[i].items[p].productImage,
                      itemName: data.orders[i].items[p].productName,
                      qtyItem: "${data.orders[i].items[p].quantity}x ",
                      priceItem: "${data.orders[i].items[p].productPrice}",
                    ),
                  Text(
                    "Catatan: ${data.orders[i].note ?? ""}",
                    style: AppTypo.caption.copyWith(color: Colors.grey),
                  ),
                ],
              )
          ],
        )
      ],
    );
  }
}
