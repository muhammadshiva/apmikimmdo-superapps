import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/data/blocs/new_cubit/add_product_supplier/add_product_supplier_cubit.dart';
import 'package:marketplace/ui/screens/new_screens/join_user/widgets/add_varian_form.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;

class AddVarianList extends StatelessWidget {
  const AddVarianList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<AddProductSupplierCubit, AddProductSupplierState>(
          builder: (context, state) {
            return Column(
              children: [
                for (var i = 0; i < state.varianId1.length; i++)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${state.varianName1[i]} ${state.varianName2[i].isNotEmpty ? ", ${state.varianName2[i]}" : ""}",
                              style: AppTypo.subtitle2
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            RichText(
                              text: TextSpan(
                                  text:
                                      'Rp ${AppExt.toRupiah(state.varianHarga[i])}',
                                  style: AppTypo.caption,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '  Stok ${state.varianStok[i]}',
                                      style: AppTypo.caption
                                          .copyWith(color: Colors.grey),
                                    )
                                  ]),
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              AppExt.pushScreen(
                                  context,
                                  AddVarianForm(
                                    index: i,
                                    isEdit: true,
                                    varian1Name: state.varianName1[i],
                                    varian1Type: state.varianId1[i],
                                    varian2Type: state.varianId2[i],
                                    varian2Name: state.varianName2[i],
                                    varianPrice:
                                        state.varianHarga[i].toString(),
                                    varianStock: state.varianStok[i].toString(),
                                  ));
                            },
                            child: Text("Ubah",
                                style: AppTypo.caption.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w600)),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                            onTap: () {
                              context
                                  .read<AddProductSupplierCubit>()
                                  .removeVariant(i);
                            },
                            child: Text("Hapus",
                                style: AppTypo.caption.copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            );
          },
        ),
        SizedBox(
          height: 8,
        ),
        GestureDetector(
          onTap: () {
            AppExt.pushScreen(context, AddVarianForm());
          },
          child: Row(
            children: [
              Icon(
                Icons.add_circle_outlined,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                "Tambah Varian",
                style: AppTypo.caption
                    .copyWith(color: Theme.of(context).primaryColor),
              )
            ],
          ),
        ),
      ],
    );
  }
}
