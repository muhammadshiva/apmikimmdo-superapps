import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marketplace/data/blocs/new_cubit/wallets/fetch_wallets/fetch_wallet_cubit.dart';
import 'package:marketplace/ui/screens/new_screens/saldo/detail_saldo/detail_saldo_penjualan_screen.dart';
import 'package:marketplace/ui/screens/new_screens/saldo/history_saldo/widgets/bs_saldo_tanggal.dart';
import 'package:marketplace/ui/widgets/edit_text.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/colors.dart' as AppColor;

class HistorySaldoScreen extends StatefulWidget {
  const HistorySaldoScreen({Key key}) : super(key: key);

  @override
  _HistorySaldoScreenState createState() => _HistorySaldoScreenState();
}

class _HistorySaldoScreenState extends State<HistorySaldoScreen> {
  FetchWalletCubit _fetchWalletCubit;

  @override
  void dispose() {
    _fetchWalletCubit.close();
    super.dispose();
  }

  @override
  void initState() {
    _fetchWalletCubit = FetchWalletCubit()..fetchWalletHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocProvider(
      create: (context) => _fetchWalletCubit,
      child: Scaffold(
        backgroundColor: Color(0xFFF7F7F7),
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          title: Text(
            "Riwayat",
            style: AppTypo.subtitle2,
          ),
          actions: [],
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              AppExt.popScreen(context);
            },
          ),
          bottom: PreferredSize(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                height: 50.0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 8,
                      child: EditText(
                        hintText: "Cari Produk",
                        inputType: InputType.search,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {
                          BsSaldoTanggal().showBsStatus(context);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.filter_alt_outlined,
                              color: Colors.grey,
                            ),
                            Text(
                              "Filter",
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              preferredSize: Size.fromHeight(50.0)),
        ),
        body: SafeArea(
          child: BlocBuilder(
            cubit: _fetchWalletCubit,
            builder: (context, state) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: state is FetchWalletLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : state is FetchWalletFailure
                      ? Center(
                          child: Text("Terjadi kesalahan!"),
                        )
                      : state is FetchWalletSuccess
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: state.wallets.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    AppExt.pushScreen(
                                        context,
                                        DetailSaldoPenjualanScreen(
                                            logId: state.wallets[index].id));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 12),
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                        color: AppColor.white,
                                        borderRadius: BorderRadius.circular(6)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              "images/icons/ic_dompet.svg",
                                              width: 16,
                                              height: 16,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  state.wallets[index].title,
                                                  style: AppTypo.caption
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                /*Text(
                                                  state.wallets[index].date,
                                                  style: AppTypo.caption
                                                      .copyWith(
                                                          color: Colors.grey),
                                                ),*/
                                              ],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              children: [
                                                state.wallets[index].type ==
                                                        "in"
                                                    ? Icon(EvaIcons.minus,
                                                        size: 12,
                                                        color: AppColor.red)
                                                    : Icon(EvaIcons.plus,
                                                        size: 12,
                                                        color: AppColor
                                                            .textPrimary),
                                                SizedBox(width: 2),
                                                Text(
                                                  state.wallets[index].amount,
                                                  style: AppTypo.caption
                                                      .copyWith(
                                                          color: state
                                                                      .wallets[
                                                                          index]
                                                                      .type ==
                                                                  "in"
                                                              ? AppColor.red
                                                              : AppColor
                                                                  .textPrimary,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              state.wallets[index].date,
                                              style: AppTypo.caption
                                                  .copyWith(color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : SizedBox(),
            ),
          ),
        ),
      ),
    );
  }
}
