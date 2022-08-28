import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/data/blocs/new_cubit/add_product_supplier/add_product_supplier_cubit.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;

import 'add_grosir_form.dart';

class AddGrosirList extends StatelessWidget {
  const AddGrosirList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<AddProductSupplierCubit, AddProductSupplierState>(
          builder: (context, state) {
            return state.grosirHarga.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < state.grosirHarga.length; i++)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Rp ${AppExt.toRupiah(state.grosirHarga[i])}",
                                    style: AppTypo.subtitle2
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Minimum Pembelian ${state.grosirMinimumBeli[i]}",
                                    style: AppTypo.caption,
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
                                        AddGrosirForm(
                                          index: i,
                                          isEdit: true,
                                          harga:
                                              state.grosirHarga[i].toString(),
                                          minimum: state.grosirMinimumBeli[i]
                                              .toString(),
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
                                        .removeGrosir(i);
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
                  )
                : SizedBox();
          },
        ),
        SizedBox(
          height: 8,
        ),
        GestureDetector(
          onTap: () {
            AppExt.pushScreen(context, AddGrosirForm());
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
                "Tambah Harga Grosir",
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
