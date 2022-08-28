import 'package:flutter/material.dart';
import 'package:marketplace/data/models/new_models/order.dart';
import 'package:marketplace/ui/widgets/data_table.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;

class RingkasanPembayaran extends StatefulWidget {
  const RingkasanPembayaran({
    Key key,
    @required this.data,
  }) : super(key: key);

  final OrderDetailMenungguPembayaranResponseData data;

  @override
  _RingkasanPembayaranState createState() => _RingkasanPembayaranState();
}

class _RingkasanPembayaranState extends State<RingkasanPembayaran> {
  int total;

  @override
  void initState() {
    super.initState();
    final productsLen = widget.data.orders.map((e) => e.items.length);
    total = productsLen.reduce((a, b) => a + b);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Ringkasan Pembayaran",
          style: AppTypo.subtitle1.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 16,
        ),
        dataTable.boldDetail(
          "Metode Pembayaran",
          widget.data.bankName,
        ),
        SizedBox(
          height: 3,
        ),
        dataTable.boldDetail(
          "Subtotal ( $total Item )",
          widget.data.subtotal,
        ),
        SizedBox(
          height: 3,
        ),
        dataTable.boldDetail(
          "Ongkos Kirim",
          widget.data.totalOngkir,
        ),
        SizedBox(
          height: 6,
        ),
        Divider(
          thickness: 1,
        ),
        SizedBox(
          height: 5,
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
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  widget.data.totalPayment,
                  style: AppTypo.caption.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
