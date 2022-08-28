import 'package:flutter/material.dart';
import 'package:marketplace/data/models/new_models/order.dart';
import 'package:marketplace/ui/screens/new_screens/transaksi_detail/widgets/detail_pesanan_item.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;

class DetailPesananListSupplier extends StatelessWidget {
  const DetailPesananListSupplier({
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
          "Detail Pesanan",
          style: AppTypo.subtitle1.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8,),
        Column(
          children: [
            for (var i = 0; i < data.products.length; i++)
              DetailPesananItem(
                image: data.products[i].cover,
                itemName: data.products[i].title,
                qtyItem: "${data.products[i].price}",
              ),
          ],
        )
      ],
    );
  }
}