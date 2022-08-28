import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/blocs/new_cubit/search/search_cubit.dart';
import 'package:marketplace/data/models/models.dart';

import 'package:marketplace/ui/screens/web/screens/web_screens.dart';
import 'package:marketplace/ui/widgets/web/footer_web.dart';
import 'package:marketplace/ui/widgets/web/product_list_web.dart';
import 'package:marketplace/ui/widgets/web/web.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/constants.dart' as AppConst;
import 'package:marketplace/utils/transitions.dart' as AppTrans;
import 'package:url_launcher/url_launcher.dart';


class ParentSearchWeb extends StatefulWidget {
  final String keyword;
  const ParentSearchWeb({Key key, this.keyword}) : super(key: key);

  @override
  _ParentSearchWebState createState() => _ParentSearchWebState();
}

class _ParentSearchWebState extends State<ParentSearchWeb> {
  SearchCubit _searchCubitProduct;
  SearchCubit _searchCubitCatering;
  SearchCubit _searchCubitWarung;
  Completer<void> _refreshCompleter;
  //Subcategori ID = 0->produk,1->warung,2->catering
  int subCategoryId = 0;
  //Produk
  int _totalSearchProduct = 0;
  String nameSearchProduct = "Produk";
  //Warung
  int _totalSearchWarung = 0;
  String nameSearchWarung = "Warung";
  //Catering
  int _totalSearchCatering = 0;
  String nameSearchCatering = "Catering";

  String _keywordText = "";

  @override
  void initState() {
    _refreshCompleter = Completer<void>();
    _searchCubitProduct = SearchCubit();
    _searchCubitCatering = SearchCubit();
    _searchCubitWarung = SearchCubit();
    _searchCubitProduct.search(keyword: widget.keyword);
    _searchCubitCatering.search(keyword: widget.keyword);
    _searchCubitWarung.search(keyword: widget.keyword);
    _keywordText = widget.keyword;
    super.initState();
  }

  @override
  void dispose() {
    _searchCubitProduct.close();
    _searchCubitCatering.close();
    _searchCubitWarung.close();
    super.dispose();
  }

  void _launchUrl(BuildContext context, String _url) async {
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      showDialog(
          context: context,
          useRootNavigator: false,
          builder: (ctx) {
            return AlertFailureWeb(
              onPressClose: () {
                AppExt.popScreen(context);
              },
              title: "Gagal mengakses halaman",
              description: "Halaman atau koneksi internet bermasalah",
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => _searchCubitProduct,
          ),
          BlocProvider(
            create: (_) => _searchCubitCatering,
          ),
          BlocProvider(
            create: (_) => _searchCubitWarung,
          ),
        ],
        child: Center()
      //   MultiBlocListener(
      //     listeners: [
      //       BlocListener(
      //           cubit: _searchCubitProduct,
      //           listener: (_, state) {
      //             if (state is SearchSuccess) {
      //               setState(() {
      //                 _totalSearchProduct = state.result.product.length;
      //               });
      //             }
      //           }),
      //       BlocListener(
      //           cubit: _searchCubitWarung,
      //           listener: (_, state) {
      //             if (state is SearchSuccess) {
      //               setState(() {
      //                 _totalSearchWarung = state.result.shop.length;
      //               });
      //             }
      //           }),
      //       BlocListener(
      //           cubit: _searchCubitCatering,
      //           listener: (_, state) {
      //             if (state is SearchSuccess) {
      //               setState(() {
      //                 _totalSearchCatering = state.result.catering.length;
      //               });
      //             }
      //           })
      //     ],
      //     child: Scrollbar(
      //         isAlwaysShown: true,
      //         child: Center(
      //           child: ConstrainedBox(
      //             constraints: BoxConstraints(
      //               maxWidth: 1366
      //             ),
      //             child: ListView(
      //             children: [
      //               //TAB INDICATOR
      //               Padding(
      //                 padding: EdgeInsets.only(left: 82,right: 82,top: 40),
      //                 child: Container(
      //                   decoration: BoxDecoration(
      //                       color: AppColor.textPrimaryInverted,
      //                       border: Border(bottom: BorderSide(color: AppColor.grey))),
      //                   width: double.infinity,
      //                   child: Row(
      //                     children: [
      //                       InkWell(
      //                         onTap: () {
      //                           setState(() {
      //                             subCategoryId = 0;
      //                           });
      //                         },
      //                         child: Container(
      //                             decoration: BoxDecoration(
      //                                 color: AppColor.textPrimaryInverted,
      //                                 border: Border(
      //                                     bottom: BorderSide(
      //                                         color: subCategoryId == 0
      //                                             ? AppColor.primary
      //                                             : Colors.transparent))),
      //                             padding: EdgeInsets.symmetric(
      //                                 horizontal: 20, vertical: 5),
      //                             // color: Colors.blue,
      //                             child: Text("Produk",
      //                                 style: AppTypo.subtitle1.copyWith(
      //                                     color: subCategoryId == 0
      //                                         ? AppColor.primary
      //                                         : AppColor.grey,
      //                                     fontWeight: FontWeight.bold))),
      //                       ),
      //                       InkWell(
      //                         onTap: () {
      //                           setState(() {
      //                             subCategoryId = 1;
      //                           });
      //                         },
      //                         child: Container(
      //                             decoration: BoxDecoration(
      //                                 color: AppColor.textPrimaryInverted,
      //                                 border: Border(
      //                                     bottom: BorderSide(
      //                                         color: subCategoryId == 1
      //                                             ? AppColor.primary
      //                                             : Colors.transparent))),
      //                             padding: EdgeInsets.symmetric(
      //                                 horizontal: 20, vertical: 5),
      //                             // color: Colors.yellow,
      //                             child: Text("Warung",
      //                                 style: AppTypo.subtitle1.copyWith(
      //                                     color: subCategoryId == 1
      //                                         ? AppColor.primary
      //                                         : AppColor.grey,
      //                                     fontWeight: FontWeight.bold))),
      //                       ),
      //                       InkWell(
      //                         onTap: () {
      //                           setState(() {
      //                             subCategoryId = 2;
      //                           });
      //                         },
      //                         child: Container(
      //                             decoration: BoxDecoration(
      //                                 color: AppColor.textPrimaryInverted,
      //                                 border: Border(
      //                                     bottom: BorderSide(
      //                                         color: subCategoryId == 2
      //                                             ? AppColor.primary
      //                                             : Colors.transparent))),
      //                             padding: EdgeInsets.symmetric(
      //                                 horizontal: 20, vertical: 5),
      //                             // color: Colors.green,
      //                             child: Text("Catering",
      //                                 style: AppTypo.subtitle1.copyWith(
      //                                     color: subCategoryId == 2
      //                                         ? AppColor.primary
      //                                         : AppColor.grey,
      //                                     fontWeight: FontWeight.bold))),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //               Padding(
      //                   padding: EdgeInsets.only(left: 82,right: 82,top:42),
      //                   child: RichText(
      //                       text:TextSpan(
      //                         text: "Menampilkan ${subCategoryId == 0 ? _totalSearchProduct : subCategoryId == 1 ? _totalSearchWarung : _totalSearchCatering} ${subCategoryId == 0 ? nameSearchProduct : subCategoryId == 1 ? nameSearchWarung : nameSearchCatering} untuk pencarian ",
      //                         style: AppTypo.body1.copyWith(fontSize: 14),
      //                         children: <TextSpan>[
      //                           TextSpan(
      //                           text: ' "$_keywordText"',
      //                           style: AppTypo.body1
      //                               .copyWith(fontWeight: FontWeight.w700,fontSize: 14),
      //                         ),
      //                         ]
      //                       )
      //                       )),
      //               subCategoryId == 0
      //                   ? BlocBuilder(
      //                       cubit: _searchCubitProduct,
      //                       builder: (context, state) =>
      //                           AppTrans.SharedAxisTransitionSwitcher(
      //                             fillColor: Colors.transparent,
      //                             transitionType: SharedAxisTransitionType.vertical,
      //                             child: state is SearchLoading
      //                                 ? CircularProgressIndicator()
      //                                 : state is SearchFailure
      //                                     ? Center(
      //                                         child: state.type == ErrorType.network
      //                                             ? NoConnection(onButtonPressed: () {
      //                                                 _searchCubitProduct.search(
      //                                                     keyword: widget.keyword);
      //                                               })
      //                                             : ErrorFetch(
      //                                                 message: state.message,
      //                                                 onButtonPressed: () {
      //                                                   _searchCubitProduct.search(
      //                                                       keyword: widget.keyword);
      //                                                 },
      //                                               ),
      //                                       )
      //                                     : state is SearchSuccess
      //                                         ? state.result.product.length > 0
      //                                             ? GridView.builder(
      //                                                 padding: EdgeInsets.symmetric(
      //                                                     horizontal: 82,
      //                                                     vertical: 20),
      //                                                 shrinkWrap: true,
      //                                                 gridDelegate:
      //                                                     SliverGridDelegateWithMaxCrossAxisExtent(
      //                                                         maxCrossAxisExtent: 200,
      //                                                         mainAxisExtent: 300,
      //                                                         crossAxisSpacing: 20,
      //                                                         mainAxisSpacing: 20),
      //                                                 itemCount:
      //                                                     state.result.product.length,
      //                                                 itemBuilder:
      //                                                     (BuildContext ctx, index) {
      //                                                   Products _item = state
      //                                                       .result.product[index];
      //                                                   return ProductListItemWeb(
      //                                                     product: _item,
      //                                                     isPromo: _item.disc > 0,
      //                                                     // selectedAddress: widget.selectedAddress
      //                                                   );
      //                                                 })
      //                                             : Center(
      //                                                 child: EmptyData(
      //                                                     subtitle:
      //                                                         "Produk tidak ditemukan"),
      //                                               )
      //                                         : SizedBox.shrink(),
      //                           ))
      //                   : subCategoryId == 1
      //                       ? BlocBuilder(
      //                           cubit: _searchCubitWarung,
      //                           builder: (context, state) =>
      //                               AppTrans.SharedAxisTransitionSwitcher(
      //                                 fillColor: Colors.transparent,
      //                                 transitionType:
      //                                     SharedAxisTransitionType.vertical,
      //                                 child: state is SearchLoading
      //                                     ? CircularProgressIndicator()
      //                                     : state is SearchFailure
      //                                         ? Center(
      //                                             child: state.type ==
      //                                                     ErrorType.network
      //                                                 ? NoConnection(
      //                                                     onButtonPressed: () {
      //                                                     _searchCubitProduct.search(
      //                                                         keyword:
      //                                                             widget.keyword);
      //                                                   })
      //                                                 : ErrorFetch(
      //                                                     message: state.message,
      //                                                     onButtonPressed: () {
      //                                                       _searchCubitProduct
      //                                                           .search(
      //                                                               keyword: widget
      //                                                                   .keyword);
      //                                                     },
      //                                                   ),
      //                                           )
      //                                         : state is SearchSuccess
      //                                             ? state.result.shop.length > 0
      //                                                 ? GridView.builder(
      //                                                     padding:
      //                                                         EdgeInsets.symmetric(
      //                                                             horizontal: 82,
      //                                                             vertical: 20),
      //                                                     shrinkWrap: true,
      //                                                     gridDelegate:
      //                                                         SliverGridDelegateWithMaxCrossAxisExtent(
      //                                                              maxCrossAxisExtent: 650,
      //                                         mainAxisExtent: 115,
      //                                         crossAxisSpacing: 20,
      //                                         mainAxisSpacing: 20),
      //                                                     itemCount: state
      //                                                         .result.shop.length,
      //                                                     itemBuilder:
      //                                                         (BuildContext ctx,
      //                                                             index) {
      //                                                       Seller _item = state
      //                                                           .result.shop[index];
      //                                                       return InkWell(
      //                                     onTap: () {
      //                                       _launchUrl(context,
      //                                           'https://bisnisomall.com/mitra/${_item.phonenumber}');
      //                                     },
      //                                     child: BasicCard(
      //                                         child: Padding(
      //                                       padding: const EdgeInsets.fromLTRB(
      //                                           28, 15, 28, 0),
      //                                       child: Column(
      //                                         crossAxisAlignment:
      //                                             CrossAxisAlignment.start,
      //                                         children: [
      //                                           Text(_item.nameSeller,
      //                                               style: AppTypo.subtitle1
      //                                                   .copyWith(
      //                                                       fontWeight:
      //                                                           FontWeight
      //                                                               .w700)),
      //                                           SizedBox(
      //                                             height: 5,
      //                                           ),
      //                                           Text(
      //                                             "${_item.addressSeller} RT${_item.rt}/RW${_item.rw}, ${_item.subdistrict}, ${_item.city}",
      //                                             maxLines: kIsWeb ? null : 2,
      //                                             style:
      //                                                 AppTypo.caption.copyWith(
      //                                               fontSize: 12,
      //                                               color: AppColor.grey,
      //                                             ),
      //                                           ),
      //                                           // Text("+${_item.phonenumber}",style: AppTypo.body1.copyWith(fontSize: 14),),
      //                                           SizedBox(
      //                                             height: 20,
      //                                           ),
      //                                           RichText(
      //                                               text: TextSpan(
      //                                                   text:
      //                                                       'Jumlah Pelanggan ',
      //                                                   style: AppTypo.caption
      //                                                       .copyWith(
      //                                                           fontSize: 12,
      //                                                           color: AppColor
      //                                                               .grey),
      //                                                   children: <TextSpan>[
      //                                                 TextSpan(
      //                                                     text:
      //                                                         '${_item.totalMember} orang',
      //                                                     style: AppTypo.caption
      //                                                         .copyWith(
      //                                                             fontSize: 12,
      //                                                             fontWeight:
      //                                                                 FontWeight
      //                                                                     .w700,
      //                                                             color: AppColor
      //                                                                 .primary)),
      //                                               ])),
      //                                           // Text(
      //                                           //   "Jumlah${_item.subdistrict}, ${_item.city}",style: AppTypo.body1.copyWith(fontSize: 14,color:AppColor.grey )
      //                                           // )
      //                                         ],
      //                                       ),
      //                                     )),
      //                                   );
                                                            
      //                                                       // SellerListItemWeb(
      //                                                       //   seller: _item,
      //                                                       //   isCatering: false,
      //                                                       //   isFromShop: true,
      //                                                       // );
      //                                                     })
      //                                                 : Center(
      //                                                     child: EmptyData(
      //                                                         subtitle:
      //                                                             "Warung tidak ditemukan"),
      //                                                   )
      //                                             : SizedBox.shrink(),
      //                               ))
      //                       : subCategoryId == 2
      //                           ? BlocBuilder(
      //                               cubit: _searchCubitCatering,
      //                               builder: (context, state) =>
      //                                   AppTrans.SharedAxisTransitionSwitcher(
      //                                     fillColor: Colors.transparent,
      //                                     transitionType:
      //                                         SharedAxisTransitionType.vertical,
      //                                     child: state is SearchLoading
      //                                         ? CircularProgressIndicator()
      //                                         : state is SearchFailure
      //                                             ? Center(
      //                                                 child: state.type ==
      //                                                         ErrorType.network
      //                                                     ? NoConnection(
      //                                                         onButtonPressed: () {
      //                                                         _searchCubitProduct
      //                                                             .search(
      //                                                                 keyword: widget
      //                                                                     .keyword);
      //                                                       })
      //                                                     : ErrorFetch(
      //                                                         message: state.message,
      //                                                         onButtonPressed: () {
      //                                                           _searchCubitProduct
      //                                                               .search(
      //                                                                   keyword: widget
      //                                                                       .keyword);
      //                                                         },
      //                                                       ),
      //                                               )
      //                                             : state is SearchSuccess
      //                                                 ? state.result.catering
      //                                                             .length >
      //                                                         0
      //                                                     ? GridView.builder(
      //                                                         padding:
      //                                                             EdgeInsets
      //                                                                 .symmetric(
      //                                                                     horizontal:
      //                                                                         82,
      //                                                                     vertical:
      //                                                                         20),
      //                                                         shrinkWrap: true,
      //                                                         gridDelegate:
      //                                                             SliverGridDelegateWithMaxCrossAxisExtent(
      //                                                                 maxCrossAxisExtent: 200,
      //                                                                 mainAxisExtent: 300,
      //                                                                 crossAxisSpacing:
      //                                                                     20,
      //                                                                 mainAxisSpacing:
      //                                                                     20),
      //                                                         itemCount: state.result
      //                                                             .catering.length,
      //                                                         itemBuilder:
      //                                                             (BuildContext ctx,
      //                                                                 index) {
      //                                                           Seller _item = state
      //                                                               .result
      //                                                               .catering[index];
      //                                                           return SellerListItemWeb(
      //                                                             seller: _item,
      //                                                             isCatering: true,
      //                                                             isFromShop: false,
      //                                                           );
      //                                                         })
      //                                                     : Center(
      //                                                         child: EmptyData(
      //                                                             subtitle:
      //                                                                 "Catering tidak ditemukan"),
      //                                                       )
      //                                                 : SizedBox.shrink(),
      //                                   ))
      //                           : SizedBox.shrink(),
      //               SizedBox(height: 90),
      //               FooterWeb()
      //             ],
      //       ),
      //           ),
      //         ),
      //     ),
      //   ),
      // ),
      )
    );
  }
}
