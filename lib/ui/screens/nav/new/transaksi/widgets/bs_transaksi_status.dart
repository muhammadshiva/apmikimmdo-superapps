import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/fetch_transaction/fetch_transaction_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/fetch_transaction_new/fetch_transaction_new_bloc.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/transaksi_filter_kategori/transaksi_filter_kategori_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/transaksi_filter_status/transaksi_filter_status_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/transaksi_filter_tanggal/transaksi_filter_tanggal_cubit.dart';
import 'package:marketplace/ui/widgets/filled_button.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;

class BsTransaksiStatus {
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
                                .read<TransaksiFilterStatusCubit>()
                                .state
                                .index;
                            final kategori = context
                                .read<TransaksiFilterKategoriCubit>()
                                .state;
                            final tanggal = context
                                .read<TransaksiFilterTanggalCubit>()
                                .state;
                            context
                                .read<FetchTransactionNewBloc>()
                                .add(TransactionFetched(status: status,
                                kategoriId: kategori.kategoriId,
                                tanggalIndex: tanggal.indexStatus,
                                from: tanggal.startDate,
                                to: tanggal.endDate));
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
    Map<int, String> _status = {
      0: "Semua Status",
      2: "Menunggu Konfirmasi",
      3: "Sedang Diproses",
      4: "Sedang Dikirim",
      5: "Tiba di Tujuan",
      6: "Selesai",
      7: "Tidak Berhasil",
    };

    List<Widget> widgets = [];
    for (var index in _status.keys) {
      widgets.add(
        BlocBuilder<TransaksiFilterStatusCubit, TransaksiFilterStatusState>(
          builder: (context, state) {
            return RadioListTile(
              value: _status[index],
              groupValue: state.kategori,
              title: Text(_status[index], style: AppTypo.caption),
              onChanged: (val) {
                context.read<TransaksiFilterStatusCubit>().chooseStatus(val, index);
              },
              selected: state.kategori == _status[index],
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
