import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:marketplace/data/blocs/new_cubit/add_product_supplier/add_product_supplier_cubit.dart';
import 'package:marketplace/ui/widgets/edit_text.dart';

class AddBeratProduct extends StatelessWidget {
  const AddBeratProduct({
    Key key,
    @required this.beratController
  }) : super(key: key);

  final TextEditingController beratController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: EditText(
            controller: beratController,
            hintText: "Masukkan Berat",
              keyboardType: TextInputType.number
          ),
        ),
        SizedBox(
          width: 16,
        ),
        /*Expanded(
          child: SizedBox(),
        )*/
        /*Expanded(
          child: DropdownButtonFormField<String>(
            itemHeight: 50,
            decoration: InputDecoration(
                border: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.grey[300], width: 2),
              borderRadius: BorderRadius.circular(10),
            )),
            items: ["G", "Kg"]
                .map((label) => DropdownMenuItem(
                      child: Text(label.toString()),
                      value: label,
                    ))
                .toList(),
            hint: Text('Satuan'),
            onChanged: (value) {
              context.read<AddProductSupplierCubit>().addSatuan(value);
            },
          ),
        )*/
        BlocBuilder<AddProductSupplierCubit, AddProductSupplierState>(
            builder: (context, state) {
          return Expanded(
            child: InkWell(
              onTap: () {
                _showSatuanDialog(context: context, satuan: ["gr", "kg"]);
              },
              child: Container(
                height: 47,
                padding: EdgeInsets.only(top: 8, left: 8, bottom: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey[350])),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(state.satuan ?? "Satuan"),
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.arrow_drop_down)),
                    )
                  ],
                ),
              ),
            ),
          );
        })

        /*child: InkWell(
            onTap: (){

            },
            child: TextFormField(
              enabled: false,
              decoration: InputDecoration(
                counter: SizedBox.shrink(),
                fillColor: Colors.grey[300],
                suffixIcon: Icon(Icons.arrow_drop_down),
                enabledBorder: OutlineInputBorder(
                  borderRadius: kIsWeb
                      ? BorderRadius.circular(10)
                      : BorderRadius.circular(30),
                  borderSide: BorderSide(color: AppColor.editText, width: 0.0),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: kIsWeb
                      ? BorderRadius.circular(10)
                      : BorderRadius.circular(30),
                  borderSide: BorderSide(color: AppColor.editText, width: 0.0),
                )
              ),
            ),
          ),*/ /*
            );
          },
        )*/
      ],
    );
  }

  void _showSatuanDialog({
    @required BuildContext context,
    @required List<String> satuan,
    // @required void Function(int id) onSelected,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)), //this right here
          child: Container(
            child: ListView.separated(
              // padding: EdgeInsets.symmetric(vertical: 5),
              shrinkWrap: true,
              itemCount: satuan.length,
              separatorBuilder: (context, index) => Divider(
                height: 0.5,
                thickness: 0.5,
              ),
              itemBuilder: (context, index) {
                return ListTile(
                  visualDensity: VisualDensity.compact,
                  trailing: Icon(FlutterIcons.chevron_right_mco),
                  title: Text(satuan[index]),
                  onTap: () {
                    context
                        .read<AddProductSupplierCubit>()
                        .addSatuan(satuan[index]);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
