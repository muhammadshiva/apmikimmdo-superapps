import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/fetch_transaction_menunggu_pembayaran_detail/fetch_transaction_menunggu_pembayaran_detail_cubit.dart';
import 'package:marketplace/ui/screens/new_screens/transaksi_detail/widgets/invoice_pesanan_user.dart';
import 'package:marketplace/ui/widgets/fetch_conditions.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;

import 'widgets/detail_menunggu_pembayaran_header.dart';
import 'widgets/detail_pengiriman.dart';
import 'widgets/detail_pesanan_list.dart';
import 'widgets/ringkasan_pembayaran.dart';
import 'widgets/status_pesanan_widget.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class TransaksiMenungguPembayaranDetailScreen extends StatefulWidget {
  const TransaksiMenungguPembayaranDetailScreen({Key key, @required this.id})
      : super(key: key);

  final int id;

  @override
  _TransaksiMenungguPembayaranDetailScreenState createState() =>
      _TransaksiMenungguPembayaranDetailScreenState();
}

class _TransaksiMenungguPembayaranDetailScreenState
    extends State<TransaksiMenungguPembayaranDetailScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<FetchTransactionMenungguPembayaranDetailCubit>()
        .fetchDetail(orderId: widget.id);
    debugPrint("ORDER ID : ${widget.id.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Detail Pesanan",
          style: AppTypo.subtitle2,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: BlocBuilder<FetchTransactionMenungguPembayaranDetailCubit,
            FetchTransactionMenungguPembayaranDetailState>(
          builder: (context, state) {
            if (state is FetchTransactionMenungguPembayaranDetailSuccess) {
              final items = state.items;
              return Container(
                padding: EdgeInsets.all(12),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StatusPesananWidget(status: items.status, orderId: items.id),
                      Divider(
                        thickness: 1,
                      ),
                      DetailMenungguPembayaranHeader(
                        data: items,
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      DetailPesananList(
                        data: items,
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      RingkasanPembayaran(
                        data: items,
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      DetailPengiriman(data: items)
                    ],
                  ),
                ),
              );
            }
            if (state is FetchTransactionMenungguPembayaranDetailFailure) {
              return Center(
                child: state.type == ErrorType.network
                    ? NoConnection(onButtonPressed: () {
                        context
                            .read<
                                FetchTransactionMenungguPembayaranDetailCubit>()
                            .fetchDetail(orderId: widget.id);
                      })
                    : ErrorFetch(
                        message: state.message,
                        onButtonPressed: () {
                          context
                              .read<
                                  FetchTransactionMenungguPembayaranDetailCubit>()
                              .fetchDetail(orderId: widget.id);
                        },
                      ),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
