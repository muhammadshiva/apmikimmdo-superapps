import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/extensions.dart' as AppExt;

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key key}) : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController _emailController;
  bool _isButtonEnabled;

  @override
  void initState() {
    _emailController = TextEditingController(text: "");
    _isButtonEnabled = false;

    _emailController.addListener(_checkEmpty);
    super.initState();

    _checkEmpty();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _checkEmpty() {
    if (_emailController.text.trim().isEmpty) {
      setState(() {
        _isButtonEnabled = false;
      });
    } else
      setState(() {
        _isButtonEnabled = true;
      });
  }

  void _handleSubmit() => BSFeedback.show(context,
          title: "Berhasil mereset password!",
          description: "Silahkan cek email anda!")
      .then((value) => AppExt.popScreen(context));

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    bool _isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    return GestureDetector(
      onTap: () => AppExt.hideKeyboard(context),
      child: Scaffold(
        appBar: AppBar(
            title: const Text("Lupa Password", style: AppTypo.subtitle2),
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
          ),
        body: Stack(
          children: <Widget>[
            _isKeyboardVisible
                ? SizedBox.shrink()
                : Align(
                    alignment: Alignment.bottomRight,
                    child: 
                    kIsWeb ? Image.network(AppImg.d_wave_br, width: _screenWidth * (45 / 100)):
                    SvgPicture.asset(
                      AppImg.d_wave_br,
                      width: _screenWidth * (45 / 100),
                    ),
                  ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(_screenWidth * (5 / 100)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Lupa Password?",
                      style: AppTypo.h1,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Masukan email dibawah ini untuk mendapatkan intruksi untuk reset password!",
                      style: AppTypo.captionAccent,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    EditText(
                      keyboardType: TextInputType.emailAddress,
                      hintText: "Alamat Email",
                      controller: _emailController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RoundedButton.contained(
                      label: "Reset Password",
                      onPressed:
                          _isButtonEnabled ? () => _handleSubmit() : null,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
