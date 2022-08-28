import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/fetch_transaction_supplier/fetch_transaction_supplier_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/transaksi_filter_supplier_status/transaksi_filter_supplier_status_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/transaksi_filter_supplier_tanggal/transaksi_filter_supplier_tanggal_cubit.dart';
import 'package:marketplace/ui/widgets/filled_button.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;

class BsTransaksiSupplierTanggal {
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
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        "Pilih Status",
                        style: AppTypo.subtitle2
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    RadioTanggalTransaksi(),
                    Divider(),
                    BlocBuilder<TransaksiFilterSupplierTanggalCubit,
                        TransaksiFilterSupplierTanggalState>(
                      builder: (context, state) {
                        return state.status.contains("Manual")
                            ? Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text("Mulai Dari", style: AppTypo.caption),
                                    Text(
                                      DateFormat("dd MMM yyyy", 'in_ID')
                                          .format(state.startDate ??
                                          DateTime.now().subtract(
                                              Duration(days: 1))), style: AppTypo.caption.copyWith(fontWeight: FontWeight.w600),),
                                  ],
                                ),
                                onTap: () {
                                  _showDatePicker(context,
                                      initialDateTime: state.startDate ??
                                          DateTime.now().subtract(
                                              Duration(days: 1)),
                                      onDateTimeChanged: (val) {
                                        context
                                            .read<
                                            TransaksiFilterSupplierTanggalCubit>()
                                            .changeStartDate(val);
                                      });
                                },
                              ),
                              GestureDetector(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text("Sampai", style: AppTypo.caption),
                                    Text(
                                        DateFormat("dd MMM yyyy", 'in_ID')
                                            .format(state.endDate ??
                                            DateTime.now()), style: AppTypo.caption.copyWith(fontWeight: FontWeight.w600)),
                                  ],
                                ),
                                onTap: () => _showDatePicker(context,
                                    initialDateTime: state.endDate ??
                                        DateTime.now()
                                            .subtract(Duration(days: 1)),
                                    onDateTimeChanged: (val) {
                                      context
                                          .read<TransaksiFilterSupplierTanggalCubit>()
                                          .changeEndDate(val);
                                    }),
                              ),
                            ],
                          ),
                        )
                            : SizedBox();
                      },
                    ),
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

  void _showDatePicker(BuildContext context,
      {DateTime initialDateTime, Function(DateTime) onDateTimeChanged}) {
    // showCupertinoModalPopup is a built-in function of the cupertino library
    showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
          height: 330,
          color: const Color.fromARGB(255, 255, 255, 255),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 8),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => AppExt.popScreen(context),
                      child: Icon(
                        Icons.close,
                        size: 30,
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Material(
                      child: Text(
                        "Pilih Tanggal",
                        style: AppTypo.caption
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              SizedBox(
                height: 200,
                child: CupertinoDatePicker(
                    initialDateTime: initialDateTime,
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: onDateTimeChanged),
              ),

              // Close the modal
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
                      AppExt.popScreen(context);
                    }),
              )
            ],
          ),
        ));
  }
}

class RadioTanggalTransaksi extends StatelessWidget {
  const RadioTanggalTransaksi({Key key}) : super(key: key);

  List<Widget> radioListStatus() {
    List<String> _status = [
      "Semua Tanggal Transaksi",
      "90 Hari Terakhir",
      "30 Hari Terakhir",
      "Pilih Tanggal Manual",
    ];

    List<Widget> widgets = [];
    for (var i = 0; i < _status.length; i++) {
      widgets.add(
        BlocBuilder<TransaksiFilterSupplierTanggalCubit, TransaksiFilterSupplierTanggalState>(
          builder: (context, state) {
            return RadioListTile(
              value: _status[i],
              groupValue: state.status,
              title: Text(_status[i]),
              onChanged: (val) {
                context.read<TransaksiFilterSupplierTanggalCubit>().changeStatus(val, i);
              },
              selected: state.status == _status[i],
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
