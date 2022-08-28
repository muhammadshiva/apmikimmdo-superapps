import 'package:flutter/material.dart';
import 'package:marketplace/ui/widgets/data_table.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;

import '../../transaksi_detail/transaksi_status_pesanan_screen.dart';

class StatusPesananWidget extends StatelessWidget {
  final String status;
  final int orderId;

  const StatusPesananWidget(
      {Key key, @required this.status, @required this.orderId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Status",
          style: AppTypo.caption,
        ),
        SizedBox(
          height: 3,
        ),
        dataTable.detail2(
          status,
          "Lihat Status",
          () {
            AppExt.pushScreen(
                context, TransaksiStatusPesananScreen(orderId: orderId));
          },
        ),
      ],
    );
  }
}
