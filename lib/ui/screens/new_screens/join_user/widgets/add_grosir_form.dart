import 'package:flutter/material.dart';
import 'package:marketplace/data/blocs/new_cubit/add_product_supplier/add_product_supplier_cubit.dart';
import 'package:marketplace/ui/widgets/edit_text.dart';
import 'package:marketplace/ui/widgets/filled_button.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:flutter_bloc/flutter_bloc.dart';


class AddGrosirForm extends StatefulWidget {
  const AddGrosirForm({Key key, this.isEdit = false, this.index, this.harga, this.minimum}) : super(key: key);

  final bool isEdit;
  final int index;
  final String harga;
  final String minimum;

  @override
  _AddGrosirFormState createState() => _AddGrosirFormState();
}

class _AddGrosirFormState extends State<AddGrosirForm> {

  final _hargaController = TextEditingController();
  final _minimumBeliController = TextEditingController();

  @override
  void dispose() {
    _hargaController.dispose();
    _minimumBeliController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.isEdit ? "Ubah Harga Grosir" :"Tambah Harga Grosir",
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
                "Harga",
                style: AppTypo.caption,
              ),
              SizedBox(
                height: 8,
              ),
              EditText(
                controller: _hargaController..text = widget.harga ?? "",
                hintText: "",
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "Minimum Pembelian",
                style: AppTypo.caption,
              ),
              SizedBox(
                height: 8,
              ),
              EditText(
                controller: _minimumBeliController..text = widget.minimum ?? "",
                hintText: "",
              ),
              SizedBox(height: 16,),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    final _harga = int.parse(_hargaController.text);
                    final _minimum = int.parse(_minimumBeliController.text);
                    if (widget.isEdit){
                      context.read<AddProductSupplierCubit>().editGrosir(harga: _harga, minimum: _minimum, index: widget.index);
                    } else {
                      context.read<AddProductSupplierCubit>().addGrosir(harga: _harga, minimum: _minimum);
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
}
