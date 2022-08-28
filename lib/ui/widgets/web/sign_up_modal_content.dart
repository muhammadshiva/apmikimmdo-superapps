import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:marketplace/data/blocs/sign_up/sign_up_bloc.dart';
import 'package:marketplace/ui/widgets/a_app_config.dart';
import 'package:marketplace/ui/widgets/edit_text.dart';
import 'package:marketplace/ui/widgets/rounded_button.dart';

import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/colors.dart' as AppColor;

class SignUpModalContent extends StatefulWidget {
  const SignUpModalContent({ Key key, this.onRegister }) : super(key: key);

  final void Function(String) onRegister;

  @override
  _SignUpModalContentState createState() => _SignUpModalContentState();
}

class _SignUpModalContentState extends State<SignUpModalContent> {
  SignUpBloc _signUpBloc;
  TextEditingController _nameController, _phoneNumberController;
  bool _isButtonEnabled;

  String _name,_phoneNumber;

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

  void _handleSubmit() async {
    AppExt.hideKeyboard(context);

    if (_phoneNumberController.text == _phoneNumber) {
      widget.onRegister(_phoneNumberController.text);
    } else {
      _signUpBloc.add(SignUpButtonPressed(
      name: _nameController.text,
      phoneNumber: _phoneNumberController.text,
    ));
    }
    setState(() {
      _phoneNumber = _phoneNumberController.text;
    });
  }

  @override
  void dispose() {
    _signUpBloc.close();
    _nameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = AAppConfig.of(context);
    return BlocProvider<SignUpBloc>(
      create: (context) => _signUpBloc,
      child: GestureDetector(
        onTap: () => AppExt.hideKeyboard(context),
        child: BlocListener<SignUpBloc, SignUpState>(
          listener: (context, state) {
            if (state is SignUpSuccess) {
              widget.onRegister(_phoneNumberController.text);
              return;
            }
            if (state is SignUpFailure) {
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
                    const Text(
                      "Buat Akun",
                      style: AppTypo.h1,
                    ),
                    // const SizedBox(
                    //   height: 5,
                    // ),
                    config.appType ==AppType.panenpanen ?
                    Text(
                        "Sebelum melakukan transaksi di marketplace, yuk isi data kamu disini",
                        style: AppTypo.captionAccent)
                    :
                    Text(
                        "Sebelum melakukan transaksi di sloka, yuk isi data kamu disini",
                        style: AppTypo.captionAccent),
                    const SizedBox(
                      height: 30,
                    ),
                    EditText(
                      keyboardType: TextInputType.text,
                      hintText: "Nama",
                      inputType: InputType.text,
                      controller: this._nameController,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    EditText(
                      keyboardType: TextInputType.phone,
                      hintText: "Nomor WhatsApp",
                      inputType: InputType.phone,
                      controller: this._phoneNumberController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    BlocBuilder<SignUpBloc, SignUpState>(
                      builder: (context, state) => RoundedButton.contained(
                        key: const Key('signUpScreen_signUp_roundedButton'),
                        label: "Daftar",
                        onPressed: this._isButtonEnabled
                            ? () => this._handleSubmit()
                            : null,
                        isLoading: state is SignUpLoading,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Sudah mempunyai akun?  ",
                          style: AppTypo.caption,
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () =>widget.onRegister(null),
                            child: Text(
                              "Masuk",
                              style: AppTypo.caption.copyWith(
                                color: AppColor.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
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
}