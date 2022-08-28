import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/fetch_transaction_detail/fetch_transaction_detail_cubit.dart';
import 'package:marketplace/ui/screens/new_screens/transaksi_detail/widgets/invoice_pesanan_user.dart';
import 'package:marketplace/ui/widgets/fetch_conditions.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;

import 'widgets/detail_pengiriman.dart';
import 'widgets/detail_pesanan_list.dart';
import 'widgets/ringkasan_pembayaran.dart';
import 'widgets/status_pesanan_widget.dart';

class TransaksiDetailScreen extends StatefulWidget {
  const TransaksiDetailScreen({Key key, @required this.id}) : super(key: key);

  final int id;

  @override
  _TransaksiDetailScreenState createState() => _TransaksiDetailScreenState();
}

class _TransaksiDetailScreenState extends State<TransaksiDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FetchTransactionDetailCubit>().fetchDetail(orderId: widget.id);
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
        child: BlocBuilder<FetchTransactionDetailCubit,
            FetchTransactionDetailState>(
          builder: (context, state) {
            if (state is FetchTransactionDetailSuccess) {
              final items = state.items;
              return SingleChildScrollView(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatusPesananWidget(status: items.status,orderId: items.id,),
                    Divider(
                      thickness: 1,
                    ),
                    InvoicePesananUser(
                      data: items,
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    DetailPesananList(
                      data: items,
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    RingkasanPembayaran(
                      data: items,
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    DetailPengiriman(data: items)
                  ],
                ),
              );
            }
            if (state is FetchTransactionDetailFailure) {
              return Center(
                child: state.type == ErrorType.network
                    ? NoConnection(onButtonPressed: () {
                        context
                            .read<FetchTransactionDetailCubit>()
                            .fetchDetail(orderId: widget.id);
                      })
                    : ErrorFetch(
                        message: state.message,
                        onButtonPressed: () {
                          context
                              .read<FetchTransactionDetailCubit>()
                              .fetchDetail(orderId: widget.id);
                        },
                      ),
              );
            }
            return Center(child: CircularProgressIndicator(),);
          },
        ),
      ),
    );
  }
}
