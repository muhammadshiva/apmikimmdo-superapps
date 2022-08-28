import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/data/blocs/new_cubit/add_product_supplier/add_product_supplier_cubit.dart';
import 'package:marketplace/ui/widgets/edit_text.dart';
import 'package:marketplace/ui/widgets/filled_button.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;

class AddVarianForm extends StatefulWidget {
  const AddVarianForm(
      {Key key,
        this.index,
       this.isEdit = false,
       this.varian1Type,
       this.varian1Name,
       this.varian2Type,
       this.varian2Name,
       this.varianPrice,
       this.varianStock})
      : super(key: key);

  final bool isEdit;
  final int index;
  final String varian1Type;
  final String varian1Name;
  final String varian2Type;
  final String varian2Name;
  final String varianPrice;
  final String varianStock;

  @override
  _AddVarianFormState createState() => _AddVarianFormState();
}

class _AddVarianFormState extends State<AddVarianForm> {
  final _varianName1Controller = TextEditingController();
  final _varianName2Controller = TextEditingController();
  final _varianHargaController = TextEditingController();
  final _varianStockController = TextEditingController();
  String _varianId1 = "Ukuran";
  String _varianId2 = "Rasa";

  @override
  void dispose() {
    _varianName1Controller.dispose();
    _varianName2Controller.dispose();
    _varianHargaController.dispose();
    _varianStockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${widget.isEdit ? "Ubah" : "Tambah"} Varian",
                    style: AppTypo.subtitle1,
                  ),
                  IconButton(
                    onPressed: () {
                      AppExt.popScreen(context);
                    },
                    icon: Icon(Icons.close),
                  )
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "Jenis Varian 1",
                style: AppTypo.caption,
              ),
              SizedBox(
                height: 8,
              ),
              DropdownButtonFormField<String>(
                itemHeight: 50,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300], width: 2),
                  borderRadius: BorderRadius.circular(10),
                )),
                items: ["Ukuran", "Warna", "Rasa"]
                    .map((label) => DropdownMenuItem(
                          child: Text(label.toString()),
                          value: label,
                        ))
                    .toList(),
                value: widget.varian1Type ?? "Ukuran",
                hint: Text('Varian 1'),
                onChanged: (value) {
                  _varianId1 = value;
                },
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "Nama Varian 1",
                style: AppTypo.caption,
              ),
              SizedBox(
                height: 8,
              ),
              EditText(
                controller: _varianName1Controller..text = widget.varian1Name ?? "",
                hintText: "",
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "Jenis Varian 2",
                style: AppTypo.caption,
              ),
              SizedBox(
                height: 8,
              ),
              DropdownButtonFormField<String>(
                itemHeight: 50,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300], width: 2),
                  borderRadius: BorderRadius.circular(10),
                )),
                items: ["Ukuran", "Warna", "Rasa"]
                    .map((label) => DropdownMenuItem(
                          child: Text(label.toString()),
                          value: label,
                        ))
                    .toList(),
                value: widget.varian2Type ?? "Warna",
                hint: Text('Varian 2'),
                onChanged: (value) {
                  _varianId2 = value;
                },
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "Nama Varian 2",
                style: AppTypo.caption,
              ),
              SizedBox(
                height: 8,
              ),
              EditText(
                controller: _varianName2Controller..text = widget.varian2Name ?? "",
                hintText: "",
              ),
              SizedBox(
                height: 16,
              ),
              Row(
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
                          controller: _varianHargaController..text = widget.varianPrice ?? "",
                          hintText: '',
                          keyboardType: TextInputType.number,
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
                          controller: _varianStockController..text = widget.varianStock ?? "",
                          hintText: '',
                          keyboardType: TextInputType.number,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (widget.isEdit){
                      context.read<AddProductSupplierCubit>().editVarian(
                        index: widget.index,
                        varianId1: _varianId1,
                        varianId2: _varianId2,
                        varianName2: _varianName2Controller.text,
                        varianName1: _varianName1Controller.text,
                        harga: int.parse(_varianHargaController.text),
                        stok: int.parse(_varianStockController.text),
                      );
                    } else {
                      context.read<AddProductSupplierCubit>().addVarian(
                        varianId1: _varianId1,
                        varianId2: _varianId2,
                        varianName2: _varianName2Controller.text,
                        varianName1: _varianName1Controller.text,
                        harga: int.parse(_varianHargaController.text),
                        stok: int.parse(_varianStockController.text),
                      );
                    }

                    AppExt.popScreen(context);
                  },
                  color: Theme.of(context).primaryColor,
                  child: Text(
                     widget.isEdit ? "Ubah" : "Tambah",
                    style: AppTypo.caption.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

/*int _varianId(String varian) {
    if (varian == "Ukuran") {
      return 0;
    } else if (varian == "Warna") {
      return 1;
    } else {
      return 2;
    }
  }*/
}
