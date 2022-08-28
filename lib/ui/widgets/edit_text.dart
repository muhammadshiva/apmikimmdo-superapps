import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:get/get.dart';

enum InputType { text, password, search, field, phone, option, price }

class EditText extends StatefulWidget {
  final String hintText;
  final String initialValue;
  final InputType inputType;
  final TextEditingController controller;
  final Function onChanged;
  final Function onFieldSubmitted;
  final Function validator;
  final AutovalidateMode autoValidateMode;
  final TextInputType keyboardType;
  final String prefixText;
  final TextAlign textAlign;
  final bool enabled;
  final Color fillColor;
  final void Function() onTap;
  final bool isLoading;
  final bool autofocus;
  final bool readOnly;
  final bool isDense;
  final bool isHint;
  final EdgeInsets padding;
  final TextStyle textStyle;
  final int maxLength;
  final List<TextInputFormatter> inputFormatter;
  final FocusNode focusNode;

  const EditText({
    Key key,
    @required this.hintText,
    this.inputType = InputType.text,
    this.controller,
    this.onChanged,
    this.keyboardType,
    this.prefixText,
    this.textAlign,
    this.enabled = true,
    this.fillColor = AppColor.textPrimaryInverted,
    this.onTap,
    this.isLoading = false,
    this.autofocus = false,
    this.readOnly = false,
    this.isDense = false,
    this.isHint,
    this.padding,
    this.textStyle,
    this.maxLength,
    this.inputFormatter,
    this.onFieldSubmitted,
    this.initialValue,
    this.focusNode,
    this.validator,
    this.autoValidateMode = AutovalidateMode.disabled,
  }) : super(key: key);

  @override
  _EditTextState createState() => _EditTextState();
}

class _EditTextState extends State<EditText> {
  bool _obscureText;
  FocusNode _focus = new FocusNode();

  @override
  void initState() {
    super.initState();
    _obscureText = widget.inputType == InputType.password ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: widget.inputFormatter,
      autofocus: widget.autofocus,
      onTap: widget.onTap ?? null,
      readOnly: widget.inputType == InputType.option || widget.readOnly == true,
      focusNode: widget.focusNode ?? _focus,
      textAlign: widget.textAlign ?? TextAlign.start,
      maxLength: widget.maxLength,
      maxLines: widget.inputType == InputType.field ? 5 : 1,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      autovalidateMode: widget.autoValidateMode,
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: widget.validator,
      initialValue: widget.initialValue,
      controller: widget.controller,
      style: widget.textStyle != null
          ? widget.enabled
              ? widget.textStyle
              : widget.textStyle.copyWith(color: Colors.grey)
          : widget.enabled
              ? AppTypo.body2
              : AppTypo.body2.copyWith(color: Colors.grey),
      obscureText: _obscureText,
      decoration: InputDecoration(
          counter: SizedBox.shrink(),
          isDense: widget.isDense,
          prefixIcon: widget.inputType == InputType.price
              ? Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5))),
                  child: Padding(
                      padding: EdgeInsets.only(top: 13, left: 17, bottom: 15),
                      child: Text(
                        'Rp',
                        style: AppTypo.body2.copyWith(color: AppColor.grey),
                      )),
                )
              : widget.inputType == InputType.phone
                  ? _focus.hasFocus || widget.controller.text.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.fromLTRB(20, 14, 5, 14),
                          child: Text(
                            '+62',
                            style: AppTypo.body2.copyWith(color: Colors.grey),
                          ))
                      : null
                  : null,
          // prefixIcon: ,
          contentPadding: widget.padding ??
              EdgeInsets.fromLTRB(
                  20,
                  14,
                  widget.inputType == InputType.password ||
                          widget.inputType == InputType.option ||
                          widget.inputType == InputType.search
                      ? 4
                      : 20,
                  14),
          hintText: widget.inputType == InputType.phone && _focus.hasFocus
              ? null
              : widget.hintText,
          hintStyle: widget.isHint == false
              ? null
              : TextStyle(
                  fontFamily: "Inter",
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal,
                  color: AppColor.inactiveSwitch,
                ),
          filled: true,
          fillColor: widget.enabled ? widget.fillColor : Colors.grey[300],
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColor.editText, width: 0.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
                color: AppColor.silverFlashSale,
                width: widget.inputType != InputType.search ? 2 : 0),
          ),
          enabled: widget.enabled,
          focusedBorder: OutlineInputBorder(
            borderRadius: !context.isPhone
                ? BorderRadius.circular(10)
                : BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColor.silverFlashSale, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: !context.isPhone
                ? BorderRadius.circular(10)
                : BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColor.danger, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: !context.isPhone
                ? BorderRadius.circular(10)
                : BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColor.danger, width: 1),
          ),
          suffixIcon: widget.isLoading
              ? SizedBox(
                  width: 0,
                  height: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            AppColor.primary)),
                  ))
              : widget.inputType == InputType.password ||
                      widget.inputType == InputType.option
                  ? Container(
                      margin: EdgeInsets.only(right: 15),
                      child: new GestureDetector(
                        onTap: widget.inputType == InputType.password
                            ? () => setState(() => _obscureText = !_obscureText)
                            : null,
                        child: widget.inputType == InputType.password
                            ? new Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: AppColor.editTextIcon,
                              )
                            : widget.inputType == InputType.option
                                ? new Icon(
                                    FlutterIcons.chevron_down_mco,
                                    color: AppColor.editTextIcon,
                                  )
                                : SizedBox.shrink(),
                      ),
                    )
                  : widget.inputType == InputType.search
                      ? Icon(
                          EvaIcons.search,
                          color: AppColor.primary,
                          size: 22,
                        )
                      : null),
    );
  }
}
