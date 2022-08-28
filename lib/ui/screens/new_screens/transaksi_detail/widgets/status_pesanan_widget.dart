import 'package:flutter/material.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;

import '../transaksi_status_pesanan_screen.dart';

class StatusPesananWidget extends StatelessWidget {
  final String status;
  final int orderId;

  const StatusPesananWidget({Key key, @required this.status, @required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Status",
              style: AppTypo.caption,
            ),
            SizedBox(
              height: 5,
            ),
            Text(status,
                style: AppTypo.subtitle2
                    .copyWith(color: Theme.of(context).primaryColor)),
          ],
        ),
        TextButton(
          onPressed: () {
            AppExt.pushScreen(context, TransaksiStatusPesananScreen(orderId: orderId));
          },
          child: Text("Lihat Status",
              style: AppTypo.caption.copyWith(
                color: Theme.of(context).primaryColor,
                decoration: TextDecoration.underline,
              )),
        ),
      ],
    );
  }
}
