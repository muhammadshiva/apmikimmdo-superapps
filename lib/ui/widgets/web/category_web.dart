import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:beamer/beamer.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/blocs/fetch_categories/fetch_categories_cubit.dart';
import 'package:marketplace/data/models/models.dart' as models;
import 'package:marketplace/ui/screens/screens.dart';
import 'package:marketplace/ui/widgets/a_app_config.dart';
import 'package:marketplace/ui/widgets/basic_card.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:websafe_svg/websafe_svg.dart';
import 'package:marketplace/ui/widgets/web/web.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/constants.dart' as AppConst;
import 'package:marketplace/utils/transitions.dart' as AppTrans;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/decorations.dart' as AppDecor;

//CATEGORY
//1.SAYURAN 2.BUAH 3.IKAN 4.TERNAK 5.WARUNG 6.CATERING

/*final List<Map<String, dynamic>> sumedangAllCategory = [
  {"icon": AppImg.ic_handcraft, "label": "Dapur"},
  {"icon": AppImg.ic_handcraft, "label": "Kamera"},
  {"icon": AppImg.ic_handcraft, "label": "Kecantikan"},
  {"icon": AppImg.ic_handcraft, "label": "Kerajinan"},
  {"icon": AppImg.ic_food_sumedang, "label": "Makanan"},
  {"icon": AppImg.ic_food_sumedang, "label": "Minuman"},
  {"icon": AppImg.ic_tshirt, "label": "Pakaian"},
  {"icon": AppImg.ic_sneakers, "label": "Perawatan Tubuh"},
  {"icon": AppImg.ic_sneakers, "label": "Sepatu"},
];*/

/*final List<Map<String, dynamic>> panenCategory = [
  {
    "icon": AppImg.ic_vegetables,
    "label": "Sayuran",
    "route": "/product/sayuran"
  },
  {"icon": AppImg.ic_fruit, "label": "Buah", "route": "/product/buah"},
  {"icon": AppImg.ic_fish, "label": "Ikan", "route": "/product/ikan"},
  {"icon": AppImg.ic_chicken, "label": "Ternak", "route": "/product/ternak"},
  {"icon": AppImg.ic_shop, "label": "Warung", "route": "/product/warung"},
  {"icon": AppImg.ic_food, "label": "Catering", "route": "/product/catering"},
];*/

/*final List<Map<String, dynamic>> sumedangCategory = [
  {"icon": AppImg.ic_menu, "label": "Lihat Semua", "route": "-"},
  {
    "icon": AppImg.ic_food_sumedang,
    "label": "Makanan",
    "route": "/product/buah"
  },
  {"icon": AppImg.ic_handcraft, "label": "Kerajinan", "route": "/product/ikan"},
  {"icon": AppImg.ic_tshirt, "label": "Pakaian", "route": "/product/ternak"},
  {"icon": AppImg.ic_sneakers, "label": "Sepatu", "route": "/product/warung"},
];*/

/*final List<Map<String, dynamic>> bisnisoCategory = [
  {
    "icon": AppImg.ic_bisniso_category,
    "label": "Kategori",
    "route": "/listshopbisniso"
  },
  {
    "icon": AppImg.ic_food_sumedang,
    "label": "Makanan",
    "route": "/bisnisoproduct/Makanan"
  },
  {
    "icon": AppImg.ic_tshirt,
    "label": "Fashion",
    "route": "/bisnisoproduct/Fashion"
  },
  {
    "icon": AppImg.ic_handcraft,
    "label": "Kerajinan",
    "route": "/bisnisoproduct/Kerajinan"
  },
  {
    "icon": AppImg.ic_house,
    "label": "Rumah Tangga",
    "route": "/bisnisoproduct/Rumah-Tangga"
  },
  {
    "icon": AppImg.ic_drugs,
    "label": "Kesehatan",
    "route": "/bisnisoproduct/Kesehatan"
  },
  {
    "icon": AppImg.ic_worktool,
    "label": "Pertukangan",
    "route": "/bisnisoproduct/Pertukangan"
  },
  {
    "icon": AppImg.ic_sneakers,
    "label": "Sepatu",
    "route": "/bisnisoproduct/Sepatu"
  },
];*/

class CategoryWeb extends StatefulWidget {
  final bool isParentProductPage;

  // final Recipent selectedAddress;
  final int globalCategoryIndex;
  final Function setTitleRoutePage, setCategoryIds;

  const CategoryWeb(
      {Key key,
      // this.selectedAddress,
      this.isParentProductPage,
      this.setTitleRoutePage,
      this.setCategoryIds,
      this.globalCategoryIndex})
      : super(key: key);

  @override
  _CategoryWebState createState() => _CategoryWebState();
}

class _CategoryWebState extends State<CategoryWeb> {
  FetchCategoriesCubit _fetchCategoriesCubit;

  bool _isSelected = false;
  bool _isBack = false;
  int _passFromGlobalCategoryIndex = 0;
  int _categoryId = 0;

  List<models.Category> _categoryWeb = [];

  @override
  void initState() {
    _passFromGlobalCategoryIndex = widget.globalCategoryIndex;
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
    final config = AAppConfig.of(context);
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => _fetchCategoriesCubit,
          ),
        ],
        child: MultiBlocListener(
            listeners: [
              BlocListener(
                cubit: _fetchCategoriesCubit,
                listener: (context, state) {
                  if (state is FetchCategoriesSuccess) {
                    for (var i = 0; i < state.categories.length; i++) {
                      _categoryWeb.add(models.Category(
                          index: i,
                          id: state.categories[i].id,
                          name: state.categories[i].name,
                          slug: state.categories[i].slug,
                          icon: state.categories[i].icon));
                    }
                  }
                  return;
                },
              ),
            ],
            child: BasicCard(
              width: double.infinity,
              hasShadow: true,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 28.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Kategori",
                        style: AppTypo.h3.copyWith(
                          fontWeight: FontWeight.w600,
                        )),
                    SizedBox(height: 18),
                    BlocBuilder(
                        cubit: _fetchCategoriesCubit,
                        builder: (context, state) => state
                                is FetchCategoriesLoading
                            ? categoryWebLoading(context)
                            : state is FetchCategoriesSuccess
                                ? state.categories.length > 0
                                    ? Column(
                                        children: [
                                          config.appType == AppType.panenpanen
                                              ? categoryWebPanenPanen(context)
                                              : config.appType ==
                                                      AppType.sumedang
                                                  ? categoryWebSumedang(context)
                                                  : SizedBox(),
                                        ],
                                      )
                                    : Center(
                                        child: EmptyData(
                                          subtitle:
                                              "Nantikan Updatenya Segera, hanya di PanenPanen !",
                                          // subtitle:
                                          //     "Kategori produk belum ada"
                                        ),
                                      )
                                : state is FetchCategoriesFailure
                                    ? Center(
                                        child: Column(
                                          children: [
                                            SizedBox(height: 10),
                                            Text(
                                              "Kategori produk gagal dimuat",
                                              style: AppTypo.body2,
                                            ),
                                            SizedBox(height: 15),
                                            SizedBox(
                                              width: 40,
                                              child: RoundedButton.outlined(
                                                isSmall: true,
                                                isCompact: true,
                                                isUpperCase: false,
                                                label: "Coba Lagi",
                                                onPressed: () =>
                                                    _fetchCategoriesCubit
                                                        .load(),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : SizedBox())
                  ],
                ),
              ),
            )));
  }

  Widget categoryWebPanenPanen(BuildContext context) {
    return GridView.builder(
        // padding: EdgeInsets.symmetric(horizontal: 82, vertical: 10),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 180,
            mainAxisExtent: 70,
            crossAxisSpacing: 70,
            mainAxisSpacing: 20),
        itemCount: _categoryWeb.length < 5 ? _categoryWeb.length : 5,
        itemBuilder: (BuildContext ctx, idx) {
          return BasicItemCategory(
              width: 162,
              color: _passFromGlobalCategoryIndex == idx ||
                      _isSelected == true && _categoryWeb[idx].index == idx
                  ? AppColor.primary.withOpacity(0.1)
                  : AppColor.textPrimaryInverted,
              borderColor: _passFromGlobalCategoryIndex == idx ||
                      _isSelected == true && _categoryWeb[idx].index == idx
                  ? AppColor.primary
                  : null,
              borderWidth: _passFromGlobalCategoryIndex == idx ||
                      _isSelected == true && _categoryWeb[idx].index == idx
                  ? 2
                  : 1,
              // iconColor: _passFromGlobalCategoryIndex == idx ||
              // _isSelected == true && _categoryWeb[idx].index == idx
              //     ? AppColor.textPrimaryInverted
              //     : AppColor.primary,
              icon:
                  "https://end.bisniso.id/storage/icon/${_categoryWeb[idx].icon}",
              label: Text(
                _categoryWeb[idx].name,
                style: AppTypo.subtitle1.copyWith(
                    fontSize: 18,
                    fontWeight: _passFromGlobalCategoryIndex == idx ||
                            _isSelected == true &&
                                _categoryWeb[idx].index == idx
                        ? FontWeight.w700
                        : FontWeight.w400,
                    color: _passFromGlobalCategoryIndex == idx ||
                            _isSelected == true &&
                                _categoryWeb[idx].index == idx
                        ? AppColor.primary
                        : AppColor.textPrimary),
                textAlign: TextAlign.center,
              ),
              onTap: () {
                // if (widget.isParentProductPage == true) {
                //   setState(() {
                //     _categoryId = idx ;
                //     _isSelected = true;
                //     _passFromGlobalCategoryIndex = idx;
                //   });
                //   widget.setTitleRoutePage(_categoryWeb[idx].name);
                //   // widget.setCategoryIds(idx == 4 ?  idx + 2 : idx + 1);
                //   if (_isBack == false) {
                //     setState(() {
                //       _isBack = true;
                //     });
                //   }
                //   context.beamToNamed(
                //     '/product/${_categoryWeb[idx].code}/${_categoryWeb[idx].id}/${_categoryWeb[idx].index}?recid=${BlocProvider.of<ShippingAddressCubit>(context).state.selectedRecipent != null ? AppExt.encryptMyData(jsonEncode(BlocProvider.of<ShippingAddressCubit>(context).state.selectedRecipent.id)) : AppExt.encryptMyData(jsonEncode(null))}',
                //   );
                // } else {
                //   context.beamToNamed(
                //     '/product/${_categoryWeb[idx].code}/${_categoryWeb[idx].id}/${_categoryWeb[idx].index}?recid=${BlocProvider.of<ShippingAddressCubit>(context).state.selectedRecipent != null ? AppExt.encryptMyData(jsonEncode(BlocProvider.of<ShippingAddressCubit>(context).state.selectedRecipent.id)) : AppExt.encryptMyData(jsonEncode(null))}',
                //   );
                // }
              });
        });
  }

  Widget categoryWebSumedang(BuildContext context) {
    return SizedBox(width: MediaQuery.of(context).size.width, child: SizedBox()
        // Wrap(
        //   // direction: Axis.horizontal,
        //   alignment: WrapAlignment.spaceBetween,
        //   runSpacing: 34,
        //   spacing: 34,
        //   children: [
        //     for (var i = 0; i < _categoryWeb.length; i++)
        //       BasicItemCategory(
        //           width: 162,
        //           color: _passFromGlobalCategoryId == i + 1 ||
        //                   (_isSelected == true && _categoryId == i + 1)
        //               ? AppColor.primary
        //               : AppColor.textPrimaryInverted,
        //           icon: _categoryWeb[i].icon != null
        //               ? "${AppConst.STORAGE_URL}/icon/${_categoryWeb[i].icon}"
        //               : null,
        //           label: Text(
        //             _categoryWeb[i].name,
        //             style: AppTypo.subtitle1.copyWith(
        //                 fontSize: 18,
        //                 color: _passFromGlobalCategoryId == i + 1 ||
        //                         (_isSelected == true && _categoryId == i + 1)
        //                     ? AppColor.textPrimaryInverted
        //                     : AppColor.textPrimary),
        //             textAlign: TextAlign.center,
        //           ),
        //           onTap: () {
        //             if (widget.isParentProductPage == true) {
        //               setState(() {
        //                 _categoryId = i + 1;
        //                 _isSelected = true;
        //                 _passFromGlobalCategoryId = i + 1;
        //               });
        //               widget.setTitleRoutePage(_categoryWeb[i].name);
        //               widget.setCategoryIds(i + 1);
        //               context.beamToNamed(
        //                 '/productsumedang/${_categoryWeb[i].code}/${_categoryWeb[i].id}',
        //               );
        //             } else {
        //               context.beamToNamed(
        //                 '/productsumedang/${_categoryWeb[i].code}/${_categoryWeb[i].id}',
        //               );
        //             }
        //             // if (idx + 1 == 1) {
        //             //   showDialog(
        //             //       context: context,
        //             //       builder: (BuildContext context) {
        //             //         return DialogWeb(
        //             //             width: 825,
        //             //             height: 350,
        //             //             hasTitle: true,
        //             //             title: "Semua kategori",
        //             //             onPressedClose: () {
        //             //               AppExt.popScreen(context);
        //             //             },
        //             //             child: StaggeredGridView.countBuilder(
        //             //               padding: EdgeInsets.symmetric(
        //             //                   horizontal: 40, vertical: 30),
        //             //               shrinkWrap: true,
        //             //               crossAxisCount: 4,
        //             //               itemCount: sumedangAllCategory.length,
        //             //               itemBuilder: (BuildContext context, int index) {
        //             //                 return BasicItemCategory(
        //             //                   icon: sumedangAllCategory[index]['icon'],
        //             //                   label: Text(
        //             //                       sumedangAllCategory[index]['label']),
        //             //                 );
        //             //               },
        //             //               staggeredTileBuilder: (int index) =>
        //             //                   new StaggeredTile.fit(1),
        //             //               mainAxisSpacing: 32,
        //             //               crossAxisSpacing: 16,
        //             //             ));
        //             //       });
        //             // } else {
        //             //   if (widget.isParentProductPage == true) {
        //             //     setState(() {
        //             //       _categoryId = idx + 1;
        //             //       _isSelected = true;
        //             //       _passFromGlobalCategoryId = idx + 1;
        //             //     });
        //             //     widget.setTitleRoutePage(sumedangCategory[idx]['label']);
        //             //     widget.setCategoryIds(idx + 1);
        //             //     context.beamToNamed(
        //             //       '/product/ikan',
        //             //     );
        //             //   } else {
        //             //     context.beamToNamed(
        //             //       '/product/ikan',
        //             //     );
        //             //   }
        //             // }
        //           }),
        //   ],
        // ),
        );
  }

  Widget categoryWebIchc(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      // child: Wrap(
      //   // direction: Axis.horizontal,
      //   alignment: WrapAlignment.spaceBetween,
      //   runSpacing: 34,
      //   spacing: 34,
      //   children: [
      //     for (var i = 0; i < _categoryWeb.length; i++)
      //       BasicItemCategory(
      //         width: 162,
      //         color: _passFromGlobalCategoryId == i + 1 ||
      //                 (_isSelected == true && _categoryId == i + 1)
      //             ? AppColor.primary
      //             : AppColor.textPrimaryInverted,
      //         icon: _categoryWeb[i].icon != null
      //             ? "${AppConst.STORAGE_URL}/icon/${_categoryWeb[i].icon}"
      //             : null,
      //         label: Text(
      //           _categoryWeb[i].name,
      //           style: AppTypo.subtitle1.copyWith(
      //               fontSize: 18,
      //               color: _passFromGlobalCategoryId == i + 1 ||
      //                       (_isSelected == true && _categoryId == i + 1)
      //                   ? AppColor.textPrimaryInverted
      //                   : AppColor.textPrimary),
      //           textAlign: TextAlign.center,
      //         ),
      //         onTap: () {
      //           if (widget.isParentProductPage == true) {
      //             setState(() {
      //               _categoryId = i + 1;
      //               _isSelected = true;
      //               _passFromGlobalCategoryId = i + 1;
      //             });
      //             widget.setTitleRoutePage(_categoryWeb[i].name);
      //             widget.setCategoryIds(i + 1);
      //             context.beamToNamed(
      //               '/productichc/${_categoryWeb[i].code}/${_categoryWeb[i].id}',
      //             );
      //           } else {
      //             context.beamToNamed(
      //               '/productichc/${_categoryWeb[i].code}/${_categoryWeb[i].id}',
      //             );
      //           }
      //         },
      //       ),
      //   ],
      // ),
    );
  }

  Wrap categoryWebLoading(BuildContext context) {
    return Wrap(
      runSpacing: 34,
      spacing: 34,
      children: [
        for (var i = 0; i < 6; i++)
          BasicItemCategory(
            width: 162,
            height: 50,
            color: AppColor.grey,
            noContent: true,
          )
      ],
    );
  }
}
