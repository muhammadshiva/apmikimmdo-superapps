import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/fetch_transaction_supplier/fetch_transaction_supplier_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/transaksi_filter_supplier_status/transaksi_filter_supplier_status_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/transaksi_filter_supplier_tanggal/transaksi_filter_supplier_tanggal_cubit.dart';
import 'package:marketplace/ui/screens/new_screens/transaksi_supplier/widgets/bs_transaksi_supplier_status.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/ui/screens/new_screens/transaksi_supplier/widgets/bs_transaksi_supplier_tanggal.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/extensions.dart' as AppExt;

import '../../../nav/new/transaksi/widgets/filter_element.dart';

class FilterSupplierList extends StatelessWidget {
  const FilterSupplierList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 1,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Row(
          children: [
            Builder(
              builder: (context) {
                final isFilterStatusFilled = context.select(
                        (TransaksiFilterSupplierStatusCubit cubit) => cubit.state.kategori) !=
                    "Semua Status";
                final isFilterTanggalFilled = context.select(
                        (TransaksiFilterSupplierTanggalCubit cubit) =>
                    cubit.state.status) !=
                    "Semua Tanggal Transaksi";
                if (isFilterStatusFilled ||
                    isFilterTanggalFilled) {
                  return FilterElement(
                      onTap: () {
                        context.read<TransaksiFilterSupplierStatusCubit>().resetStatus();
                        context.read<TransaksiFilterSupplierTanggalCubit>().reset();
                        context.read<FetchTransactionSupplierCubit>().fetch();
                      },
                      isFilterFilled: true,
                      allowedIcon: false,
                      child: Icon(
                        Icons.close,
                        color: Theme.of(context).primaryColor,
                      ));
                }
                return SizedBox();
              },
            ),
            SizedBox(
              width: 8,
            ),
            BlocBuilder<TransaksiFilterSupplierStatusCubit, TransaksiFilterSupplierStatusState>(
              builder: (context, state) {
                return FilterElement(
                  onTap: () {
                    BsTransaksiSupplierStatus().showBsStatus(context);
                  },
                  isFilterFilled: state.kategori != "Semua Status",
                  child: Text(
                    state.kategori,
                    style: AppTypo.caption.copyWith(
                        color: state.kategori == "Semua Status"
                            ? Colors.grey
                            : Theme.of(context).primaryColor),
                  ),
                );
              },
            ),
            SizedBox(
              width: 8,
            ),
            BlocBuilder<TransaksiFilterSupplierTanggalCubit,
                TransaksiFilterSupplierTanggalState>(
              builder: (context, state) {
                return FilterElement(
                  onTap: () {
                    BsTransaksiSupplierTanggal().showBsStatus(context);
                  },
                  isFilterFilled: state.status != "Semua Tanggal Transaksi",
                  child: Text(
                    state.status,
                    style: AppTypo.caption.copyWith(
                        color: state.status == "Semua Tanggal Transaksi"
                            ? Colors.grey
                            : Theme.of(context).primaryColor),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
