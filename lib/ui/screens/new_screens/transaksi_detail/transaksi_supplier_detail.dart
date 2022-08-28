import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/fetch_transaction_supplier_detail/fetch_transaction_supplier_detail_cubit.dart';
import 'package:marketplace/ui/screens/new_screens/transaksi_detail/widgets/invoice_pesanan_user.dart';
import 'package:marketplace/ui/screens/new_screens/transaksi_detail/widgets/supplier/detail_pengiriman_supplier.dart';
import 'package:marketplace/ui/screens/new_screens/transaksi_detail/widgets/supplier/detail_pesanan_list_supplier.dart';
import 'package:marketplace/ui/screens/new_screens/transaksi_detail/widgets/supplier/ringkasan_pembayaran_supplier.dart';
import 'package:marketplace/ui/screens/new_screens/transaksi_detail/widgets/supplier/invoice_pesanan_supplier.dart';
import 'package:marketplace/ui/widgets/fetch_conditions.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;

import 'widgets/detail_pengiriman.dart';
import 'widgets/detail_pesanan_list.dart';
import 'widgets/ringkasan_pembayaran.dart';
import 'widgets/status_pesanan_widget.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class TransaksiSupplierDetailScreen extends StatefulWidget {
  const TransaksiSupplierDetailScreen({Key key, @required this.id}) : super(key: key);

  final int id;

  @override
  _TransaksiSupplierDetailScreenState createState() => _TransaksiSupplierDetailScreenState();
}

class _TransaksiSupplierDetailScreenState extends State<TransaksiSupplierDetailScreen> {

  @override
  void initState() {
    super.initState();
    context.read<FetchTransactionSupplierDetailCubit>().fetchDetail(orderId: widget.id);
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
        child: BlocBuilder<FetchTransactionSupplierDetailCubit, FetchTransactionSupplierDetailState>(
          builder: (context, state) {
            if (state is FetchTransactionSupplierDetailSuccess){
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
                    InvoicePesananSupplier(data: items,),
                    Divider(
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    DetailPesananListSupplier(data: items,),
                    Divider(
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    RingkasanPembayaranSupplier(data: items,),
                    Divider(
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    DetailPengirimanSupplier(data: items)
                  ],
                ),
              );
            }
            if (state is FetchTransactionSupplierDetailFailure){
              return Center(
                child: state.type == ErrorType.network
                    ? NoConnection(onButtonPressed: () {
                  context.read<FetchTransactionSupplierDetailCubit>().fetchDetail(orderId: widget.id);
                })
                    : ErrorFetch(
                  message: state.message,
                  onButtonPressed: () {
                    context.read<FetchTransactionSupplierDetailCubit>().fetchDetail(orderId: widget.id);
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