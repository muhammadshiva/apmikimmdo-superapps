import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketplace/data/models/new_models/order.dart';
import 'package:marketplace/ui/screens/new_screens/invoice/invoice_payment_screen.dart';
import 'package:marketplace/ui/screens/new_screens/invoice/invoice_screen.dart';
import 'package:marketplace/ui/screens/new_screens/invoice/invoice_waiting_payment_screen.dart';
import 'package:marketplace/ui/widgets/data_table.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/extensions.dart' as AppExt;

class DetailMenungguPembayaranHeader extends StatelessWidget {
  const DetailMenungguPembayaranHeader(
      {Key key, @required this.data})
      : super(key: key);

  final OrderDetailMenungguPembayaranResponseData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        dataTable.detail2(
          "${data.transactionCode}",
          "Lihat Invoice",
          () {
            AppExt.pushScreen(context,
                InvoiceWaitingPaymentScreen(data: data,));
          },
        ),
        SizedBox(
          height: 5,
        ),
        dataTable.boldDetail(
          "Nama Pemesanan",
          "${data.orderName}",
        ),
        // _threeRow(label: "Total Bayar", value: data.totalPayment),
        SizedBox(
          height: 3,
        ),
        dataTable.boldDetail(
          "Tanggal Pemesanan",
          "${data.orderDate}",
        ),
        SizedBox(
          height: 3,
        ),
        dataTable.boldDetail(
          "Tanggal Pengiriman",
          "${data.deliveryDate}",
        ),
        /*_threeRow(
            label: "Nomor Rekening",
            value: data.accountNumber,
            widget: TextButton(
                onPressed: () => _copyText(context, data.accountNumber),
                child: Text(
                  "Salin",
                  style: AppTypo.caption
                      .copyWith(color: Theme.of(context).primaryColor),
                ))),
        SizedBox(
          height: 8,
        ),
        _threeRow(label: "Rekening Atas Nama", value: data.accountName),*/
      ],
    );
  }

  Widget _threeRow({String label, String value, Widget widget}) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: AppTypo.caption,
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: AppTypo.caption.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Expanded(
          flex: 2,
          child: widget ?? SizedBox(),
        ),
      ],
    );
  }

  void _copyText(BuildContext context, String text) {
    Clipboard.setData(new ClipboardData(text: text));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        new SnackBar(
          backgroundColor: Colors.grey[900],
          content: new Text(
            "Teks berhasil dicopy",
          ),
          duration: Duration(seconds: 1),
        ),
      );
  }
}
