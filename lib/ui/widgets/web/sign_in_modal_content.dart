import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:marketplace/data/blocs/sign_in/sign_in_bloc.dart';
import 'package:marketplace/ui/screens/screens.dart';
import 'package:marketplace/ui/widgets/a_app_config.dart';
import 'package:marketplace/ui/widgets/widgets.dart';

import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/colors.dart' as AppColor;

class SignInModalContent extends StatefulWidget {
  const SignInModalContent({Key key, this.onLogin}) : super(key: key);

  final void Function(String) onLogin;

  @override
  _SignInModalContentState createState() => _SignInModalContentState();
}

class _SignInModalContentState extends State<SignInModalContent> {
  SignInBloc _signInBloc;

  TextEditingController _phoneNumberController;
  TextEditingController _unameController;
  TextEditingController _passController;
  bool _isButtonEnabled;

  String _phoneNumber;

  @override
  void initState() {
    _signInBloc = SignInBloc();

    _phoneNumberController = TextEditingController(text: "");
    _unameController = TextEditingController(text: "");
    _passController = TextEditingController(text: "");
    _isButtonEnabled = false;

    _phoneNumberController.addListener(_checkEmpty);
    super.initState();

    _checkEmpty();
  }

  void _checkEmpty() {
    if (_phoneNumberController.text.trim().isEmpty ||
        _phoneNumberController.text.trim().length < 9) {
      setState(() {
        _isButtonEnabled = false;
      });
    } else
      setState(() {
        _isButtonEnabled = true;
      });
  }

  void _handleSubmit() async {
    // final prefs = await SharedPreferences.getInstance();
    // prefs.setString(tokenKey, "1380|4A6TDSbfTTNhvmbGHnITJTinabUNhAgSPpgAjRFy");
    AppExt.hideKeyboard(context);
    if (_phoneNumberController.text == _phoneNumber) {
      widget.onLogin(_phoneNumberController.text);
    } else {
      _signInBloc.add(
        SignInButtonPressed(phoneNumber: _phoneNumberController.text),
      );
    }
    setState(() {
      _phoneNumber = _phoneNumberController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = AAppConfig.of(context);
    return BlocProvider<SignInBloc>(
      create: (context) => _signInBloc,
      child: GestureDetector(
        onTap: () => AppExt.hideKeyboard(context),
        child: BlocListener<SignInBloc, SignInState>(
          listener: (context, state) {
            if (state is SignInOtpRequested) {
              widget.onLogin(_phoneNumberController.text);
              return;
            }
            if (state is SignInFailure) {
              setState(() {
                _phoneNumber = null;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${state.error}'),
                  backgroundColor: AppColor.danger,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              return;
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15).copyWith(bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Spacer(),
                    // IconButton(
                    //   iconSize: 35,
                    //   padding: EdgeInsets.zero,
                    //   visualDensity: VisualDensity.compact,
                    //   // splashRadius: 10,
                    //   icon: Icon(
                    //     Boxicons.bx_arrow_back,
                    //   ),
                    //   onPressed: () => AppExt.popScreen(context),
                    // ),
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
                    Text(
                      config.appType == AppType.bisnisomarket
                          ? "Masuk ke Akun Saya"
                          : "Masuk",
                      style: AppTypo.h1,
                    ),
                    Text(
                        "Dapatkan produk berkualitas dengan harga yang lebih murah di Apmikimmdo!",
                        style: AppTypo.captionAccent),
                    const SizedBox(
                      height: 30,
                    ),
                    if (config.appType == AppType.bisnisomarket) ...[
                      EditText(
                        keyboardType: TextInputType.text,
                        hintText: "Username atau Email",
                        inputType: InputType.text,
                        controller: this._unameController,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      EditText(
                        keyboardType: TextInputType.text,
                        hintText: "Kata Sandi",
                        inputType: InputType.password,
                        controller: this._passController,
                      ),
                    ] else
                      EditText(
                        keyboardType: TextInputType.phone,
                        hintText: "Nomor WhatsApp",
                        inputType: InputType.phone,
                        controller: this._phoneNumberController,
                      ),
                    SizedBox(
                      height: 20,
                    ),
                    BlocBuilder<SignInBloc, SignInState>(
                      builder: (context, state) => RoundedButton.contained(
                        key: const Key('signInScreen_signIn_roundedButton'),
                        label: "Masuk",
                        onPressed: this._isButtonEnabled
                            ? () => this._handleSubmit()
                            : null,
                        isLoading: state is SignInLoading,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          config.appType == AppType.bisnisomarket
                              ? "Belum jadi member?  "
                              : "Belum punya akun?  ",
                          style: AppTypo.caption,
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () => widget.onLogin(null),
                            child: Text(
                              "Daftar",
                              style: AppTypo.caption.copyWith(
                                color: AppColor.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row buildBottom(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Ada keluhan?  ",
          style: AppTypo.caption,
        ),
        GestureDetector(
          onTap: () => AppExt.pushScreen(
            context,
            ForgetPasswordScreen(),
            AppExt.RouteTransition.fade,
          ),
          child: Text(
            "Klik Disini",
            style: AppTypo.caption.copyWith(
              color: AppColor.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _signInBloc.close();
    _phoneNumberController.dispose();
    super.dispose();
  }
}
