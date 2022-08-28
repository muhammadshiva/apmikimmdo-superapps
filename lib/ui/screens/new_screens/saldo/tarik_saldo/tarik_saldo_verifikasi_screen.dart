import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/data/blocs/new_cubit/wallets/withdraw_wallet_otp/withdraw_wallet_otp_bloc.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/ui/widgets/filled_button.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:pin_code_fields/pin_code_fields.dart';

import 'tarik_saldo_success_screen.dart';

class TarikSaldoVerifikasiScreen extends StatefulWidget {
  const TarikSaldoVerifikasiScreen({Key key, this.walletWithdrawData})
      : super(key: key);

  final WalletWithdrawData walletWithdrawData;

  @override
  _TarikSaldoVerifikasiScreenState createState() =>
      _TarikSaldoVerifikasiScreenState();
}

class _TarikSaldoVerifikasiScreenState
    extends State<TarikSaldoVerifikasiScreen> {
  WithdrawWalletOtpBloc _withdrawWalletOtpBloc;

  Timer _timer;

  bool disableButton = true;
  int confirmationCode = 0;
  int _start = 60;

  @override
  void initState() {
    _withdrawWalletOtpBloc = WithdrawWalletOtpBloc();
    _startTimer();
    super.initState();
  }

  void _startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _withdrawWalletOtpBloc.close();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _withdrawWalletOtpBloc,
      child: BlocListener<WithdrawWalletOtpBloc, WithdrawWalletOtpState>(
        listener: (context, state) {
          if (state is WithdrawWalletOtpSuccess) {
            AppExt.pushScreen(
                context,
                TarikSaldoSuccessScreen(
                  walletWithdrawData: widget.walletWithdrawData,
                ));
          }
          if (state is WithdrawWalletOtpFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 1),
                  content: Text(state.message),
                ),
              );
          }
          if (state is WithdrawWalletResendOtpSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.grey[900],
                  duration: Duration(seconds: 1),
                  content: Text("Kode OTP telah dikirim"),
                ),
              );
          }
          if (state is WithdrawWalletResendOtpFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.grey[900],
                  duration: Duration(seconds: 1),
                  content: Text(state.message),
                ),
              );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text(
              "Tarik Saldo",
              style: AppTypo.subtitle2,
            ),
            elevation: 0,
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
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Kode verifikasi (OTP) dikirim pada whatsapp anda",
                    style: AppTypo.subtitle2,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  PinCodeTextField(
                    appContext: context,
                    length: 4,
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.underline,
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                    ),
                    autoFocus: true,
                    onCompleted: (v) {
                      debugPrint("Completed $v");
                      setState(() {
                        disableButton = false;
                        confirmationCode = int.parse(v);
                      });
                    },
                    onChanged: (String value) {},
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  BlocBuilder<WithdrawWalletOtpBloc, WithdrawWalletOtpState>(
                    builder: (context, state) {
                      return RoundedButton.contained(
                        label: "Lanjut",
                        isUpperCase: false,
                        disabled: disableButton,
                        isLoading: state is WithdrawWalletOtpLoading,
                        onPressed: () {
                          _withdrawWalletOtpBloc.add(WithdrawWalletOtpSubmitted(
                              logId: widget.walletWithdrawData.logId,
                              confirmationCode: confirmationCode));
                        },
                        color: Theme.of(context).primaryColor,
                      );
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  BlocBuilder<WithdrawWalletOtpBloc, WithdrawWalletOtpState>(
                    builder: (context, state) =>
                        state is WithdrawWalletOtpLoading
                            ? SizedBox.shrink()
                            : Center(
                                child: _start > 0
                                    ? Text(
                                        "Kirim Ulang dalam $_start detik",
                                        style: AppTypo.body2Accent,
                                        textAlign: TextAlign.center,
                                      )
                                    : InkWell(
                                        onTap: () {
                                          AppExt.hideKeyboard(context);
                                          _withdrawWalletOtpBloc.add(
                                              WithdrawWalletOtpResend(
                                                  logId: widget
                                                      .walletWithdrawData
                                                      .logId));
                                          _start = 60;
                                          _startTimer();
                                        },
                                        radius: 20,
                                        borderRadius: BorderRadius.circular(10),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Text(
                                            "Kirim Ulang",
                                            style: AppTypo.button.copyWith(
                                                color: AppColor.primary),
                                          ),
                                        ),
                                      ),
                              ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
