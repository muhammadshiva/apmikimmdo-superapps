import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/fetch_transaction/fetch_transaction_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/fetch_transaction_new/fetch_transaction_new_bloc.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/transaksi_filter_kategori/transaksi_filter_kategori_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/transaksi_filter_kategori_search/transaksi_filter_kategori_search_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/transaksi_filter_status/transaksi_filter_status_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/transaksi_filter_tanggal/transaksi_filter_tanggal_cubit.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/ui/screens/nav/new/transaksi/widgets/bs_transaksi_status.dart';
import 'package:marketplace/ui/screens/nav/new/transaksi/widgets/bs_transaksi_tanggal.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/extensions.dart' as AppExt;

import 'filter_element.dart';

class FilterList extends StatelessWidget {
  const FilterList({
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
                        (TransaksiFilterStatusCubit cubit) => cubit.state.kategori) !=
                    "Semua Status";
                final isFilterTanggalFilled = context.select(
                        (TransaksiFilterTanggalCubit cubit) =>
                            cubit.state.status) !=
                    "Semua Tanggal Transaksi";
                final isFilterKategoriFilled = !context
                    .select((TransaksiFilterKategoriCubit cubit) =>
                        cubit.state)
                    .kategori.contains("Semua Kategori");
                if (isFilterStatusFilled ||
                    isFilterTanggalFilled ||
                    isFilterKategoriFilled) {
                  return FilterElement(
                      onTap: () {
                        context.read<TransaksiFilterStatusCubit>().resetStatus();
                        context.read<TransaksiFilterTanggalCubit>().reset();
                        context.read<TransaksiFilterKategoriCubit>().reset();
                        context.read<FetchTransactionNewBloc>().add(TransactionFetched());
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
            BlocBuilder<TransaksiFilterStatusCubit, TransaksiFilterStatusState>(
              builder: (context, state) {
                return FilterElement(
                  onTap: () {
                    BsTransaksiStatus().showBsStatus(context);
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
            BlocBuilder<TransaksiFilterKategoriCubit,
                TransaksiFilterKategoriState>(
              builder: (context, state) {
                return FilterElement(
                  onTap: () {
                    context.read<TransaksiFilterKategoriSearchCubit>().reset();
                    BsKategori().showBsStatus(context, onPressed: (){
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
                    });
                  },
                  isFilterFilled: !state.kategori.contains("Semua Kategori"),
                  child: Text(
                    state.kategori,
                    style: AppTypo.caption.copyWith(color: state.kategori.contains("Semua Kategori") ? Colors.grey : Theme.of(context).primaryColor),
                  ),
                );
              },
            ),
            SizedBox(
              width: 8,
            ),
            BlocBuilder<TransaksiFilterTanggalCubit,
                TransaksiFilterTanggalState>(
              builder: (context, state) {
                return FilterElement(
                  onTap: () {
                    BsTransaksiTanggal().showBsStatus(context);
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
