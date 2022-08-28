// import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marketplace/ui/widgets/edit_text.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;

class AddHargaStokProduct extends StatelessWidget {
  const AddHargaStokProduct({
    Key key,
    @required this.hargaController,
    @required this.stockController,
  }) : super(key: key);

  final TextEditingController hargaController;
  final TextEditingController stockController;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Harga",
                style: AppTypo.caption,
              ),
              SizedBox(
                height: 8,
              ),
              EditText(
                  controller: hargaController,
                  hintText: '',
                  keyboardType: TextInputType.number,
                  inputType: InputType.price,
                inputFormatter: [
                  ThousandsFormatter()  
                ],
              )
            ],
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Stok",
                style: AppTypo.caption,
              ),
              SizedBox(
                height: 8,
              ),
              EditText(
                  controller: stockController,
                  hintText: '',
                  keyboardType: TextInputType.number)
            ],
          ),
        ),
      ],
    );
  }
}
