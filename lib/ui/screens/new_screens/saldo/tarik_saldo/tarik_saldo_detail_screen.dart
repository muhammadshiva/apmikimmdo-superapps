import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/data/blocs/new_cubit/wallets/withdraw_wallet/withdraw_wallet_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/ui/screens/new_screens/saldo/tarik_saldo/tarik_saldo_success_screen.dart';
import 'package:marketplace/ui/screens/new_screens/saldo/tarik_saldo/tarik_saldo_verifikasi_screen.dart';
import 'package:marketplace/ui/widgets/rounded_button.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/colors.dart' as AppColor;

class TarikSaldoDetailScreen extends StatefulWidget {
  const TarikSaldoDetailScreen({Key key, this.walletWithdrawData})
      : super(key: key);

  final WalletWithdrawData walletWithdrawData;

  @override
  _TarikSaldoDetailScreenState createState() => _TarikSaldoDetailScreenState();
}

class _TarikSaldoDetailScreenState extends State<TarikSaldoDetailScreen> {
  WithdrawWalletCubit _withdrawWalletCubit;
  WalletWithdrawData walletWithdrawData;

  @override
  void initState() {
    walletWithdrawData = widget.walletWithdrawData;
    _withdrawWalletCubit = WithdrawWalletCubit();
    super.initState();
  }

  @override
  void dispose() {
    _withdrawWalletCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (_) => _withdrawWalletCubit,
      child: BlocListener(
        cubit: _withdrawWalletCubit,
        listener: (context, state) {
          if (state is WithdrawWalletSuccess) {
            AppExt.pushScreen(
                context,
                TarikSaldoVerifikasiScreen(
                  walletWithdrawData: WalletWithdrawData(
                    saldo: walletWithdrawData.saldo,
                    noRek: walletWithdrawData.noRek,
                    paymentMethod: walletWithdrawData.paymentMethod,
                    atasNama: walletWithdrawData.atasNama,
                    logId: state.data.logId
                  ),
                ));
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    textTheme: TextTheme(headline6: AppTypo.subtitle2),
                    iconTheme: IconThemeData(color: Colors.black),
                    backgroundColor: Colors.white,
                    centerTitle: true,
                    forceElevated: false,
                    pinned: true,
                    shadowColor: Colors.black54,
                    floating: true,
                    title: Text("Tarik Saldo"),
                    brightness: Brightness.dark,
                  ),
                ];
              },
              body: SingleChildScrollView(
                  physics: new BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: _screenWidth * (8 / 100), vertical: 20),
                    child: Column(
                      children: [
                        Text(
                            "${AppExt.toRupiah(widget.walletWithdrawData.saldo)},-",
                            style: AppTypo.LatoBold.copyWith(
                              fontSize: 18,
                            )),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Saldo yang di tarik",
                          style: AppTypo.body2Lato
                              .copyWith(color: Color(0xFFABABAF), fontSize: 14),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Nama",
                                style: AppTypo.body2Lato
                                    .copyWith(color: AppColor.inactiveSwitch),
                              ),
                              Text(widget.walletWithdrawData.atasNama,
                                  style: AppTypo.LatoBold.copyWith(
                                    fontSize: 14,
                                  ))
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Bank",
                                style: AppTypo.body2Lato
                                    .copyWith(color: AppColor.inactiveSwitch),
                              ),
                              Text(widget.walletWithdrawData.paymentMethod.name,
                                  style: AppTypo.LatoBold.copyWith(
                                    fontSize: 14,
                                  ))
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "No. Rekening",
                                style: AppTypo.body2Lato
                                    .copyWith(color: AppColor.inactiveSwitch),
                              ),
                              Text(widget.walletWithdrawData.noRek.toString(),
                                  style: AppTypo.LatoBold.copyWith(
                                    fontSize: 14,
                                  ))
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        RoundedButton.contained(
                            label: "Tarik",
                            isUpperCase: false,
                            onPressed: () {
                              _withdrawWalletCubit.withDrawWallet(
                                  amount: walletWithdrawData.saldo,
                                  paymentMethodId:
                                      walletWithdrawData.paymentMethod.id,
                                  accountNumber: walletWithdrawData.noRek,
                                  accountName: walletWithdrawData.atasNama);
                            })
                      ],
                    ),
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
