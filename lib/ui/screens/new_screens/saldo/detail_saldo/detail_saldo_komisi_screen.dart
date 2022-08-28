import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/data/blocs/new_cubit/wallets/fetch_wallet_detail/fetch_wallet_detail_cubit.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;

class DetailSaldoKomisiScreen extends StatefulWidget {
  const DetailSaldoKomisiScreen({ Key key, this.logId }) : super(key: key);
  final int logId;

  @override
  State<DetailSaldoKomisiScreen> createState() => _DetailSaldoKomisiScreenState();
}

class _DetailSaldoKomisiScreenState extends State<DetailSaldoKomisiScreen> {

  FetchWalletDetailCubit _fetchWalletDetailCubit;

  @override
  void initState() {
    _fetchWalletDetailCubit = FetchWalletDetailCubit()
      ..fetchWalletDetail(historyId: widget.logId);
    super.initState();
  }

  @override
  void dispose() {
    _fetchWalletDetailCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _fetchWalletDetailCubit,
      child: Scaffold(
        backgroundColor: Color(0xFFF7F7F7),
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          title: Text(
            "Detail Transaksi Komisi",
            style: AppTypo.subtitle2,
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              AppExt.popScreen(context);
            },
          ),
        ),
        body: BlocBuilder(
          cubit: _fetchWalletDetailCubit,
          builder: (context, state) => 
          state is FetchWalletDetailLoading
              ? Center(
                      child: CircularProgressIndicator(),
                    )
              : state is FetchWalletDetailFailure
                  ? Center(
                      child: Text("Terjadi kesalahan!"),
                    )
                  : state is FetchWalletDetailSuccess
                      ? SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              Material(
                                elevation: 3,
                                borderRadius: BorderRadius.circular(5),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "+ ${state.wallet.amount},-",
                                        style: AppTypo.subtitle1.copyWith(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                          ),
                                          Text(
                                            "Berhasil diterima",
                                          )
                                        ],
                                      ),
                                      Text(
                                        "${state.wallet.date}",
                                        style: AppTypo.disableText,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Material(
                                elevation: 3,
                                borderRadius: BorderRadius.circular(5),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Rincian Penjualan Barang",
                                        style: AppTypo.subtitle2.copyWith(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Image.network(
                                              "${state.wallet.productCover}",
                                              width: 70,
                                              height: 70,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    "${state.wallet.productName}"),
                                                Text(
                                                  "${state.wallet.productPrice},-",
                                                  style: AppTypo.caption
                                                      .copyWith(
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            "${state.wallet.orderDate}",
                                            style: AppTypo.disableText,
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Divider(
                                        thickness: 1.5,
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        "Terjual",
                                        style: AppTypo.subtitle2.copyWith(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "${state.wallet.quantity}x",
                                            style: AppTypo.caption.copyWith(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Expanded(
                                            flex: 5,
                                            child: Text(
                                                "${state.wallet.productName}"),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              "${state.wallet.totalPrice},-",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Divider(
                                        thickness: 1.5,
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        "Komisi",
                                        style: AppTypo.subtitle2.copyWith(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "${state.wallet.quantity}x",
                                            style: AppTypo.caption.copyWith(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Expanded(
                                            flex: 5,
                                            child: Text("Rp 5.000,- / pcs"),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              "${state.wallet.amount},-",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                      )
                      : SizedBox(),
        ),
      ),
    );
  }
}