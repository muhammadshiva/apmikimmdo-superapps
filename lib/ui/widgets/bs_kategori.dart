import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marketplace/data/blocs/fetch_categories/fetch_categories_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/fetch_transaction/fetch_transaction_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/transaksi_filter_kategori/transaksi_filter_kategori_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/transaksi_filter_kategori_search/transaksi_filter_kategori_search_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/transaksi_filter_status/transaksi_filter_status_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/transaction/transaksi_filter_tanggal/transaksi_filter_tanggal_cubit.dart';
import 'package:marketplace/ui/widgets/filled_button.dart';
import 'package:marketplace/utils/constants.dart' as AppConst;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/colors.dart' as AppColor;

class BsKategori {
  Future<void> showBsStatus(BuildContext context,
      {void Function() onPressed}) async {
    await showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * (15 / 100),
                  height: 7,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(7.5 / 2),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  // shrinkWrap: true,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Kategori",
                        style: AppTypo.subtitle2
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextField(
                      style: TextStyle(height: 1.0, color: Colors.black),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Cari Kategori",
                          labelStyle: AppTypo.caption,
                          prefixIcon: Icon(Icons.search)),
                      onChanged: (value) => context
                          .read<TransaksiFilterKategoriSearchCubit>()
                          .search(value),
                    ),
                    BsKategoriItem(),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                          color: AppColor.primary,
                          child: Text(
                            "Tampilkan",
                            style: AppTypo.subtitle1
                                .copyWith(color: AppColor.white),
                          ),
                          onPressed: onPressed),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}

class BsKategoriItem extends StatefulWidget {
  const BsKategoriItem({Key key}) : super(key: key);

  @override
  State<BsKategoriItem> createState() => _BsKategoriItemState();
}

class _BsKategoriItemState extends State<BsKategoriItem> {
  FetchCategoriesCubit _fetchCategoriesCubit;

  int valIdCategory = 0;

  @override
  void initState() {
    _fetchCategoriesCubit = FetchCategoriesCubit()..load();
    super.initState();
  }

  @override
  void dispose() {
    _fetchCategoriesCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _fetchCategoriesCubit,
      child: SizedBox(
          height: MediaQuery.of(context).size.height - 300,
          child: BlocBuilder(
            cubit: _fetchCategoriesCubit,
            builder: (context, state) {
              return state is FetchCategoriesLoading
                  ? Center(child: CircularProgressIndicator())
                  : state is FetchCategoriesFailure
                      ? Center(
                          child: Text("Kategori gagal dimuat"),
                        )
                      : state is FetchCategoriesSuccess
                          ? state.categories.length > 0
                              ? ListView.separated(
                                  separatorBuilder: (ctx, index) => SizedBox(),
                                  itemCount: state.categories.length,
                                  itemBuilder: (ctx, index) {
                                    return Column(
                                      children: [
                                        BlocBuilder<
                                            TransaksiFilterKategoriCubit,
                                            TransaksiFilterKategoriState>(
                                          builder: (context, kategori) {
                                            return RadioListTile(
                                              value:
                                                  state.categories[index].name,
                                              groupValue: kategori.kategori,
                                              onChanged: (value) {
                                                debugPrint(value);
                                                context
                                                    .read<
                                                        TransaksiFilterKategoriCubit>()
                                                    .chooseStatus(
                                                        value,
                                                        state.categories[index]
                                                            .id);
                                              },
                                              title: Text(
                                                  state.categories[index].name),
                                              /*secondary: SvgPicture.network(
                                                "${AppConst.STORAGE_URL}/icon/${state.categories[index].icon}",
                                                height: 35,
                                                placeholderBuilder: (context) =>
                                                    Container(
                                                  width: 35,
                                                  height: 35,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.grey[300],
                                                  ),
                                                ),
                                              ),*/
                                              secondary: Image.network(
                                                state.categories[index].icon,
                                                height: 35,
                                                frameBuilder: (context,
                                                    child,
                                                    frame,
                                                    wasSynchronouslyLoaded) {
                                                  if (wasSynchronouslyLoaded) {
                                                    return child;
                                                  } else {
                                                    return AnimatedSwitcher(
                                                      duration: const Duration(
                                                          milliseconds: 300),
                                                      child: frame != null
                                                          ? child
                                                          : Container(
                                                              width: 35,
                                                              height: 35,
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
                                                            ),
                                                    );
                                                  }
                                                },
                                              ),
                                              controlAffinity:
                                                  ListTileControlAffinity
                                                      .trailing,
                                            );
                                          },
                                        )
                                      ],
                                    );
                                  },
                                )
                              : Center(
                                  child: Text("Kategori kosong"),
                                )
                          : SizedBox.shrink();

              // for (var i = 0; i < state.length; i++)
              //   BlocBuilder<TransaksiFilterKategoriCubit, List<String>>(
              //     builder: (context, value) {
              //       return CheckboxListTile(
              //         value: value.contains(state.values.elementAt(i)),
              //         selected: value.contains(state.values.elementAt(i)),
              //         onChanged: (val) {
              //           if (val) {
              //             context
              //                 .read<TransaksiFilterKategoriCubit>()
              //                 .addKategori(state.values.elementAt(i));
              //           } else {
              //             context
              //                 .read<TransaksiFilterKategoriCubit>()
              //                 .removeKategori(state.values.elementAt(i));
              //           }
              //         },
              //         title: Text(
              //           state.values.elementAt(i),
              //           style: AppTypo.caption,
              //         ),
              //         secondary: SvgPicture.asset(
              //           state.keys.elementAt(i),
              //           height: 30,
              //           width: 30,
              //         ),
              //       );
              //     },
              //   ),
            },
          )),
    );
  }
}
