import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/data/blocs/new_cubit/add_product_supplier/add_product_supplier_cubit.dart';
import 'package:marketplace/data/models/new_models/category.dart';


class AddKategoriProduct extends StatelessWidget {
  const AddKategoriProduct({
    Key key,
    @required this.name,
    this.categories, this.checkCategory,
  }) : super(key: key);

  final String name;
  final List<Category> categories;
  final Function(String value) checkCategory;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if (categories != null){
          _showCategoryDialog(context: context, items: categories);
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 8, left: 8, bottom: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey[350])
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(name ?? ""),
            ),
            Expanded(
              flex: 1,
              child: Align(alignment: Alignment.centerRight, child: Icon(Icons.arrow_drop_down)),
            )
          ],
        ),
      ),
    );
  }

  void _showCategoryDialog({
    @required BuildContext context,
    @required List<Category> items,
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
              itemCount: items.length,
              separatorBuilder: (context, index) => Divider(
                height: 0.5,
                thickness: 0.5,
              ),
              itemBuilder: (context, index) {
                return ListTile(
                  visualDensity: VisualDensity.compact,
                  trailing: Icon(FlutterIcons.chevron_right_mco),
                  title: Text(items[index].name),
                  onTap: () {
                    context.read<AddProductSupplierCubit>().addKategori(items[index].name, items[index].id);
                    checkCategory(items[index].name);
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