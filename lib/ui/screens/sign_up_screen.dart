import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:marketplace/data/blocs/sign_up/sign_up_bloc.dart';
import 'package:marketplace/ui/screens/screens.dart';
import 'package:marketplace/ui/widgets/a_app_config.dart';

import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:url_launcher/url_launcher.dart';

class SignUpScreen extends StatefulWidget {
  final bool isFromRoot;

  const SignUpScreen({Key key, this.isFromRoot = false}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  SignUpBloc _signUpBloc;

  TextEditingController _nameController, _phoneNumberController;
  bool _isButtonEnabled;

  @override
  void initState() {
    _signUpBloc = SignUpBloc();

    _nameController = TextEditingController(text: "");
    _phoneNumberController = TextEditingController(text: "");
    _isButtonEnabled = false;

    _nameController.addListener(_checkEmpty);
    _phoneNumberController.addListener(_checkEmpty);

    super.initState();
    _checkEmpty();
  }

  void _checkEmpty() {
    if (_nameController.text.trim().isEmpty ||
        _phoneNumberController.text.trim().isEmpty ||
        _phoneNumberController.text.trim().length < 9) {
      setState(() {
        _isButtonEnabled = false;
      });
    } else
      setState(() {
        _isButtonEnabled = true;
      });
  }

  void _handleSubmit() {
    AppExt.hideKeyboard(context);

    _signUpBloc.add(SignUpButtonPressed(
      name: _nameController.text,
      phoneNumber: _phoneNumberController.text,
    ));
  }

  void _launchUrl(String _url) async {
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      BSFeedback.show(
        context,
        icon: Boxicons.bx_x_circle,
        color: AppColor.red,
        title: "Gagal mengakses halaman",
        description: "Halaman atau koneksi internet bermasalah",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = AAppConfig.of(context);
    final String appLogo = config.appType == AppType.apmikimmdo
        ? AppImg.img_logo
        : AppImg.img_logo_placeholder;

    double _screenWidth = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (context) => _signUpBloc,
      child: GestureDetector(
        onTap: () => AppExt.hideKeyboard(context),
        child: Scaffold(
          appBar: AppBar(
              brightness: Brightness.light,
              iconTheme: IconThemeData(color: AppColor.black),
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              title: const Text("Daftar Sekarang", style: AppTypo.subtitle2)),
          body: BlocListener<SignUpBloc, SignUpState>(
            listener: (context, state) {
              if (state is SignUpSuccess) {
                AppExt.pushScreen(
                    context,
                    OtpScreen(
                      phoneNumber: state.phoneNumber,
                      otpTimeout: state.otpTimeOut,
                      isFromRoot: widget.isFromRoot,
                      isSignUp: true,
                    ));
              } else if (state is SignUpFailure) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${state.error}'),
                    duration: Duration(seconds: 2),
                    backgroundColor: AppColor.danger,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: _screenWidth * (5 / 100)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: _screenWidth * (5 / 100),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Image.asset(
                            appLogo,
                            width: _screenWidth * (30 / 100),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: _screenWidth * (5 / 100),
                      ),
                      const Text(
                        "Buat Akun",
                        style: AppTypo.h1,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Dapatkan lebih banyak pelanggan tetap dengan bergabung bersama ekosistem kami.",
                        style: AppTypo.captionAccent,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      EditText(
                        keyboardType: TextInputType.name,
                        hintText: "Nama",
                        controller: _nameController,
                      ),
                      const SizedBox(
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
                        height: 30,
                      ),
                      RichText(
                        text: TextSpan(
                          style: AppTypo.captionAccent,
                          children: [
                            TextSpan(
                              text:
                                  'Dengan membuat akun berarti anda setuju dengan ',
                            ),
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => kIsWeb
                                    ? _launchUrl(
                                        "https://admasolusi.com/privacy")
                                    : AppExt.pushScreen(
                                        context,
                                        WebviewAdmaPrivacyScreen(
                                            link:
                                                "https://admasolusi.com/privacy")),
                              text: 'Ketentuan layanan ',
                              style: AppTypo.captionAccent.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.primary),
                            ),
                            TextSpan(
                              text: 'dan ',
                            ),
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => kIsWeb
                                    ? _launchUrl(
                                        "https://admasolusi.com/privacy")
                                    : AppExt.pushScreen(
                                        context,
                                        WebviewAdmaPrivacyScreen(
                                            link:
                                                "https://admasolusi.com/privacy")),
                              text: 'kebijakan privasi',
                              style: AppTypo.captionAccent.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.primary),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      BlocBuilder<SignUpBloc, SignUpState>(
                        builder: (context, state) => RoundedButton.contained(
                          label: "Buat Akun",
                          onPressed:
                              _isButtonEnabled ? () => _handleSubmit() : null,
                          isLoading: state is SignUpLoading,
                        ),
                      ),
                      SizedBox(
                        height: _screenWidth * (10 / 100),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Sudah mempunyai akun? ",
                            style: AppTypo.caption,
                          ),
                          GestureDetector(
                            onTap: () => AppExt.popScreen(context),
                            child: Text(
                              "Login Disini",
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

  @override
  void dispose() {
    _signUpBloc.close();
    _nameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }
}
