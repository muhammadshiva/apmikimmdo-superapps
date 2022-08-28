import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marketplace/data/blocs/authentication/authentication_bloc.dart';
import 'package:marketplace/data/blocs/debug/ui_debug_switcher/ui_debug_switcher_cubit.dart';
import 'package:marketplace/data/blocs/direct_sign_in/direct_sign_in_cubit.dart';
import 'package:marketplace/data/blocs/sign_in/sign_in_bloc.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/repositories/repositories.dart';

import 'package:marketplace/ui/screens/screens.dart';
import 'package:marketplace/ui/widgets/a_app_config.dart';
import 'package:marketplace/ui/widgets/widgets.dart';

import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/transitions.dart' as AppTrans;
import 'package:marketplace/utils/routes.dart' as AppRoute;
import 'package:marketplace/utils/validator.dart';

class SignInScreen extends StatefulWidget {
  final bool isFromRoot;

  const SignInScreen({Key key, this.isFromRoot = false}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  SignInBloc _signInBloc;
  DirectSignInCubit _directSignInCubit;

  TextEditingController _phoneNumberController;
  bool _isButtonEnabled;

  String _phoneNumber;

  @override
  void initState() {
    _signInBloc = SignInBloc();
    _directSignInCubit =
        DirectSignInCubit(BlocProvider.of<UserDataCubit>(context));

    _phoneNumberController = TextEditingController(text: "");
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
      AppExt.pushScreen(
          context,
          OtpScreen(
            phoneNumber: _phoneNumberController.text,
            otpTimeout: 50,
            isFromRoot: widget.isFromRoot,
          ));
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
    final String appLogo = config.appType == AppType.apmikimmdo
        ? AppImg.img_logo
        : AppImg.img_logo_placeholder;

    final double _screenWidth = MediaQuery.of(context).size.width;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => _signInBloc),
          BlocProvider(create: (context) => _directSignInCubit),
        ],
        child: GestureDetector(
          onTap: () => AppExt.hideKeyboard(context),
          child: Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: kIsWeb ? false : true,
                brightness: Brightness.light,
                iconTheme: IconThemeData(color: AppColor.black),
                backgroundColor: Colors.white,
                elevation: 0,
                centerTitle: true,
                title: const Text("Masuk", style: AppTypo.subtitle2)),
            body: BlocListener<SignInBloc, SignInState>(
              listener: (context, state) {
                if (state is SignInOtpRequested) {
                  AppExt.pushScreen(
                      context,
                      OtpScreen(
                        phoneNumber: state.phoneNumber,
                        otpTimeout: state.otpTimeOut,
                        isFromRoot: widget.isFromRoot,
                      ));
                  return;
                }
                if (state is SignInFailure) {
                  setState(() {
                    _phoneNumber = null;
                  });
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${state.error}'),
                      backgroundColor: AppColor.danger,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }
              },
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: _screenWidth * (10 / 100)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: _screenWidth * (10 / 100),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Image.asset(
                                  appLogo,
                                  width: _screenWidth * (30 / 100),
                                ),
                                // Image.asset(
                                //   AppImg.img_logo_polinema,
                                //   width: _screenWidth * (13 / 100),
                                // ),
                              ],
                            ),
                            SizedBox(
                              height: _screenWidth * (5 / 100),
                            ),
                            Text(
                                "Dapatkan produk UMKM berkualitas hanya di APMIKIMMDO Superapps",
                                style: AppTypo.body1Lato),
                            SizedBox(
                              height: 56,
                            ),
                            Text("No Telepon (Whatsapp)",
                                style: AppTypo.body1.copyWith(fontSize: 14)),
                            SizedBox(
                              height: 10,
                            ),
                            EditText(
                              keyboardType: TextInputType.phone,
                              hintText: "Nomor WhatsApp",
                              inputType: InputType.phone,
                              controller: this._phoneNumberController,
                              inputFormatter: [
                                FilteringTextInputFormatter.deny(
                                    RegExp(r'^0+')),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            BlocBuilder<SignInBloc, SignInState>(
                              builder: (context, state) =>
                                  RoundedButton.contained(
                                key: const Key(
                                    'signInScreen_signIn_roundedButton'),
                                label: "Masuk",
                                onPressed: this._isButtonEnabled
                                    ? () => this._handleSubmit()
                                    : null,
                                isLoading: state is SignInLoading,
                              ),
                            ),
                            SizedBox(
                              height: _screenWidth * (5 / 100),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Belum punya akun?  ",
                                  style: AppTypo.caption,
                                ),
                                GestureDetector(
                                  onTap: () => AppExt.pushScreen(
                                    context,
                                    SignUpScreen(
                                      isFromRoot: widget.isFromRoot,
                                    ),
                                    AppExt.RouteTransition.fade,
                                  ),
                                  child: Text(
                                    "Daftar",
                                    style: AppTypo.caption.copyWith(
                                      color: AppColor.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: _screenWidth * (5 / 100),
                            ),
                            BlocConsumer(
                              cubit: _directSignInCubit,
                              listener: (context, state) {},
                              builder: (context, _directState) {
                                return UiDebugSwitcher(
                                  child: Column(
                                    children: [
                                      Opacity(
                                        opacity:
                                            _directState is DirectSignInLoading
                                                ? 1
                                                : 0,
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        _directState is DirectSignInFailure
                                            ? "${_directState.message}"
                                            : "",
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextField(
                                        decoration: InputDecoration(
                                          enabled: _directState
                                              is! DirectSignInLoading,
                                          border: OutlineInputBorder(),
                                          prefix: Text("+62"),
                                          labelText: "Login with number",
                                        ),
                                        keyboardType: TextInputType.phone,
                                        onSubmitted: (val) => _directSignInCubit
                                            .signInWithPhone(val),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      TextField(
                                        decoration: InputDecoration(
                                          enabled: _directState
                                              is! DirectSignInLoading,
                                          border: OutlineInputBorder(),
                                          labelText: "Login with token",
                                        ),
                                        onSubmitted: (val) => _directSignInCubit
                                            .signInWithToken(val),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
    _directSignInCubit.close();
    _phoneNumberController.dispose();
    super.dispose();
  }
}
