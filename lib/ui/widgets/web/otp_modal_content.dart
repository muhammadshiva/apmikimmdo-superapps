import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:marketplace/data/blocs/authentication/authentication_bloc.dart';
import 'package:marketplace/data/blocs/otp/otp_bloc.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/repositories/repositories.dart';
import 'package:marketplace/ui/screens/main_screen.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/transitions.dart' as AppTrans;
import 'package:marketplace/utils/extensions.dart' as AppExt;

class OtpModalContent extends StatefulWidget {
  final String phoneNumber;
  final int otpTimeout;
  final VoidCallback onSuccess;
  final VoidCallback onBack;

  const OtpModalContent({
    Key key,
    @required this.phoneNumber,
    @required this.otpTimeout,
    this.onSuccess,
    this.onBack,
  }) : super(key: key);

  @override
  _OtpModalContentState createState() => _OtpModalContentState();
}

class _OtpModalContentState extends State<OtpModalContent> {
  OtpBloc _otpBloc;

  TextEditingController _otpController;
  bool _isButtonEnabled;
  Timer _timer;
  int _start;

  @override
  void initState() {
    _otpBloc = OtpBloc(userDataCubit: BlocProvider.of<UserDataCubit>(context));

    _start = widget.otpTimeout;

    _otpController = TextEditingController(text: "");
    _isButtonEnabled = false;
    _otpController.addListener(_checkEmpty);

    super.initState();
    _checkEmpty();
    // _startOtp();
    _startTimer();
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

  void _checkEmpty() {
    if (_otpController.text.trim().isEmpty) {
      setState(() {
        _isButtonEnabled = false;
      });
    } else
      setState(() {
        _isButtonEnabled = true;
      });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _otpBloc,
      child: BlocListener<OtpBloc, OtpState>(
        listener: (context, state) {
          if (state is OtpRetrySuccess) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('Kode verifikasi telah dikirim'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          if (state is OtpRetryFailure) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.message}'),
                backgroundColor: AppColor.danger,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          if (state is OtpSuccess) {
            widget.onSuccess();
          }
          if (state is OtpFailure) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.message}'),
                backgroundColor: AppColor.danger,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15).copyWith(bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    iconSize: 35,
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    // splashRadius: 10,
                    icon: Icon(
                      Boxicons.bx_arrow_back,
                    ),
                    onPressed: widget.onBack,
                  ),
                  IconButton(
                    iconSize: 40,
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    // splashRadius: 10,
                    icon: Icon(
                      Boxicons.bx_x,
                    ),
                    onPressed: () => AppExt.popScreen(context),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30).copyWith(top: 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Periksa Whatsapp anda",
                    style: AppTypo.h3,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  RichText(
                    text: TextSpan(
                      style: AppTypo.captionAccent,
                      children: <TextSpan>[
                        TextSpan(text: 'Kode OTP dikirim ke'),
                        TextSpan(
                            text: ' 62${widget.phoneNumber}, ',
                            style: AppTypo.captionAccent
                                .copyWith(fontWeight: FontWeight.w700)),
                        TextSpan(
                            text:
                                'masukkan kode tersebut ke dalam form dibawah ini'),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: EditText(
                      maxLength: 4,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      hintText: "4 digit angka",
                      controller: _otpController,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: BlocBuilder<OtpBloc, OtpState>(
                      builder: (context, state) => RoundedButton.contained(
                        label: "Lanjutkan",
                        isUpperCase: false,
                        onPressed: _isButtonEnabled
                            ? () {
                                AppExt.hideKeyboard(context);
                                _otpBloc.add(OtpSubmited(
                                    otp: _otpController.text,
                                    phoneNumber: widget.phoneNumber));
                              }
                            : null,
                        isLoading: state is OtpLoading,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  BlocBuilder<OtpBloc, OtpState>(
                    builder: (context, state) =>
                        AppTrans.FadeTransitionSwitcher(
                      fillColor: Colors.transparent,
                      child: state is OtpLoading
                          ? SizedBox.shrink()
                          : Center(
                              child: _start > 0
                                  ? Text(
                                      "Mohon tunggu dalam $_start detik\nuntuk kirim ulang",
                                      style: AppTypo.body2Accent,
                                      textAlign: TextAlign.center,
                                    )
                                  : InkWell(
                                      onTap: () {
                                        AppExt.hideKeyboard(context);
                                        _otpBloc.add(OtpRetry(
                                            phoneNumber: widget.phoneNumber));
                                        _start = widget.otpTimeout;
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _otpBloc.close();
    _timer.cancel();
    _otpController.dispose();
    super.dispose();
  }
}
