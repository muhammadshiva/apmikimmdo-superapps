import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/fetch_transaction_supplier/fetch_transaction_supplier_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/transaksi_filter_supplier_status/transaksi_filter_supplier_status_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/transaksi_filter_supplier_tanggal/transaksi_filter_supplier_tanggal_cubit.dart';
import 'package:marketplace/ui/widgets/filled_button.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;

class BsTransaksiSupplierStatus {
  Future<void> showBsStatus(BuildContext context) async {
    await showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * (15 / 100),
                  height: 7,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(7.5 / 2),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  // shrinkWrap: true,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Pilih Status",
                        style: AppTypo.subtitle2
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    RadioStatusItem(),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            "Tampilkan",
                            style:
                            AppTypo.subtitle1.copyWith(color: Colors.white),
                          ),
                          onPressed: () {
                            final status = context
                                .read<TransaksiFilterSupplierStatusCubit>()
                                .state
                                .index;
                            final tanggal = context
                                .read<TransaksiFilterSupplierTanggalCubit>()
                                .state;
                            context
                                .read<FetchTransactionSupplierCubit>()
                                .fetchFilterTransaction(
                                status: status,
                                tanggalIndex: tanggal.indexStatus,
                                from: tanggal.startDate,
                                to: tanggal.endDate);
                            AppExt.popScreen(context);
                          }),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}

class RadioStatusItem extends StatelessWidget {
  List<Widget> radioListStatus() {
    List<String> _status = [
      "Semua Status",
      "Pesanan Baru",
      "Pesanan Diproses",
      "Pesanan Dalam Perjalanan",
      "Pesanan Tiba",
      "Pesanan Selesai",
      "Pesanan Dibatalkan"
    ];

    List<Widget> widgets = [];
    for (var status in _status) {
      widgets.add(
        BlocBuilder<TransaksiFilterSupplierStatusCubit, TransaksiFilterSupplierStatusState>(
          builder: (context, state) {
            return RadioListTile(
              value: status,
              groupValue: state.kategori,
              title: Text(status, style: AppTypo.caption),
              onChanged: (val) {
                context.read<TransaksiFilterSupplierStatusCubit>().chooseStatus(val,
                    _status.indexWhere((element) => element.contains(val)));
              },
              selected: state.kategori == status,
              controlAffinity: ListTileControlAffinity.trailing,
            );
          },
        ),
      );
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: radioListStatus(),
    );
  }
}
