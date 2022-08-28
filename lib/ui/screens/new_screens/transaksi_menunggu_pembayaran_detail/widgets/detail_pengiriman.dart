import 'package:flutter/material.dart';
import 'package:marketplace/data/models/new_models/order.dart';
import 'package:marketplace/ui/widgets/data_table.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;

class DetailPengiriman extends StatelessWidget {
  const DetailPengiriman({
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
          "Detail Pengiriman",
          style: AppTypo.subtitle1.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 16,
        ),
        dataTable.detail(
          "Kurir Pengiriman",
          data.orders[0].courier,
        ),
        SizedBox(
          height: 8,
        ),
        dataTable.detail(
          "No. Resi",
          "-",
        ),
        SizedBox(
          height: 8,
        ),
        dataTable.detail(
          "Alamat Pengiriman",
          data.orders[0].recipientAddress ?? '-',
        ),
        SizedBox(
          height: 8,
        ),
        dataTable.detail(
          "Alamat HUB",
          data.orders[0].hubAddress,
        ),
      ],
    );
  }
}
