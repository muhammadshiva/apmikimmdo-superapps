import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/blocs/new_cubit/wallets/fetch_wallets/fetch_wallet_cubit.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/ui/screens/new_screens/saldo/detail_saldo/detail_saldo_komisi_screen.dart';
import 'package:marketplace/ui/screens/new_screens/saldo/detail_saldo/detail_saldo_penarikan_screen.dart';
import 'package:marketplace/ui/screens/new_screens/saldo/detail_saldo/detail_saldo_penjualan_screen.dart';
import 'package:marketplace/ui/screens/new_screens/saldo/home/widgets/greenBG.dart';
import 'package:marketplace/ui/screens/new_screens/saldo/home/widgets/saldo_option_section.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/colors.dart' as AppColor;

class SaldoHomeScreen extends StatefulWidget {
  const SaldoHomeScreen({Key key, this.user}) : super(key: key);
  final User user;

  @override
  _SaldoHomeScreenState createState() => _SaldoHomeScreenState();
}

class _SaldoHomeScreenState extends State<SaldoHomeScreen> {
  FetchWalletCubit _fetchWalletCubit;

  @override
  void initState() {
    _fetchWalletCubit = FetchWalletCubit()..fetchWalletHistory();
    super.initState();
  }

  @override
  void dispose() {
    _fetchWalletCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Size deviceSize = MediaQuery.of(context).size;
    final userDataCubit = BlocProvider.of<UserDataCubit>(context).state.user;

    return BlocProvider(
      create: (context) => _fetchWalletCubit,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: AppColor.white,
            centerTitle: true,
            elevation: 0.0,
            title: Text("Dompet", style: AppTypo.subtitle2),
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: AppColor.black),
                onPressed: () {
                  AppExt.popScreen(context);
                })),
        body: SafeArea(
          child: Column(
            children: [
              Stack(
                children: [
                  GreenBG(
                    walletsBalance: widget.user.walletBalance,
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SaldoOptionSection(),
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                child: Text("Transaksi Terakhir",
                    style: AppTypo.subtitle2
                        .copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: BlocBuilder(
                  cubit: _fetchWalletCubit,
                  builder: (context, state) => Container(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                    child: state is FetchWalletLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : state is FetchWalletFailure
                            ? Center(
                                child: Text('Terjadi kesalahan!'),
                              )
                            : state is FetchWalletSuccess
                                ? ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: state.wallets.length,
                                    separatorBuilder: (context, _) {
                                      return SizedBox(
                                        height: 15,
                                        child: Divider(thickness: 1),
                                      );
                                    },
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: (){
                                          if (state.wallets[index].type == "commission")
                                            AppExt.pushScreen(context, DetailSaldoKomisiScreen(
                                              logId: state.wallets[index].id,
                                            ));
                                          if (state.wallets[index].type == "withdrawal")
                                            AppExt.pushScreen(context, DetailSaldoPenarikanScreen()); 
                                          if (state.wallets[index].type == "sale")
                                            AppExt.pushScreen(context, DetailSaldoPenjualanScreen()); 
                                        },
                                        child: Container(
                                          margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
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
                                                        style: AppTypo.caption,
                                                      ),
                                                      Text(
                                                        state.wallets[index].date,
                                                        style: AppTypo.caption
                                                            .copyWith(
                                                                color:
                                                                    Colors.grey),
                                                      ),
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
                                                              "withdrawal"
                                                          ? Icon(EvaIcons.minus,
                                                              size: 12,
                                                              color: AppColor
                                                                  .textPrimary)
                                                          : Icon(EvaIcons.plus,
                                                              size: 12,
                                                              color: AppColor
                                                                  .textPrimary),
                                                      SizedBox(width: 2),
                                                      Text(
                                                        state.wallets[index]
                                                            .amount,
                                                        style: AppTypo.caption
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    state.wallets[index].date,
                                                    style: AppTypo.caption
                                                        .copyWith(
                                                            color: Colors.grey),
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
            ],
          ),
        ),
      ),
    );
  }
}
