// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:beamer/beamer.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:marketplace/data/blocs/shipping/shipping_address/shipping_address_cubit.dart';
// import 'package:marketplace/data/blocs/new_cubit/products/fetch_products_by_category/fetch_products_by_category_cubit.dart';
// import 'package:marketplace/data/models/models.dart';
// import 'package:marketplace/ui/screens/screens.dart';
// import 'package:marketplace/ui/screens/web/sections/web_sections.dart';
// import 'package:marketplace/ui/widgets/a_app_config.dart';
// import 'package:marketplace/ui/widgets/web/web.dart';
// import 'package:marketplace/utils/text.dart' as AppText;
// import 'package:marketplace/utils/typography.dart' as AppTypo;
// import 'package:marketplace/utils/colors.dart' as AppColor;
// import 'package:marketplace/utils/extensions.dart' as AppExt;
// import 'package:marketplace/utils/constants.dart' as AppConst;
// import 'package:marketplace/utils/transitions.dart' as AppTrans;
// import 'package:marketplace/utils/images.dart' as AppImg;
// import 'package:marketplace/utils/decorations.dart' as AppDecor;
// import 'package:url_launcher/url_launcher.dart';

// class ParentProductWeb extends StatefulWidget {
//   final int categoryId, recipentId,categoryIndex;
//   final String firstTitleRoutePage;  
//   final bool isReseller;

//   const ParentProductWeb(
//       {Key key,
//       this.categoryId,
//       this.firstTitleRoutePage,
//       this.recipentId, this.categoryIndex,this.isReseller = false})
//       : super(key: key);

//   @override
//   _ParentProductWebState createState() => _ParentProductWebState();
// }

// class _ParentProductWebState extends State<ParentProductWeb> {
//   // Recipent _selectedAddress;

//   String titleRoutePage = "";
//   int categoryIds = 0;

//   @override
//   void initState() {
//     super.initState();
//     categoryIds = widget.categoryId;
//     titleRoutePage = widget.firstTitleRoutePage;
//     // debugPrint("CATEGORY PERTAMA : $categoryIds");
//     // debugPrint("RECIPENTNYA: ${widget.recipentId}");
//   }

//   // void selectedAddressForWeb(value) {
//   //   setState(() {
//   //     _selectedAddress = value;
//   //   });
//   // }

//   void setTitleRoutePage(value) {
//     setState(() {
//       titleRoutePage = value;
//     });
//   }

//   void setCategoryIds(value) {
//     setState(() {
//       categoryIds = value;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {

//     final config = AAppConfig.of(context);
//     return Scrollbar(
//       isAlwaysShown: true,
//       child: SingleChildScrollView(
//         child: Center(
//           child: ConstrainedBox(
//             constraints: BoxConstraints(
//               maxWidth: 1366,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                     padding: EdgeInsets.only(top: 40, bottom: 30, left: 82),
//                     child: Row(children: [
//                       BreadCumbItemWeb(
//                         mouseCursor: SystemMouseCursors.click,
//                         title: "Home",
//                         route: "/",
//                       ),
//                       BreadCumbItemWeb(
//                         mouseCursor: SystemMouseCursors.basic,
//                         title: " - ",
//                       ),
//                       BreadCumbItemWeb(
//                         mouseCursor: SystemMouseCursors.basic,
//                         title: toBeginningOfSentenceCase(titleRoutePage),
//                       )
//                     ])),
//                 // Text("Home - $titleRoutePage"),
//                 Visibility(
//                   visible: widget.isReseller == true ? false : true,
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 82),
//                     child: CategoryWeb(
//                       // selectedAddress: widget.selectedAddress,
//                       isParentProductPage: true,
//                       setTitleRoutePage: setTitleRoutePage,
//                       setCategoryIds: setCategoryIds,
//                       globalCategoryIndex: widget.categoryIndex,
//                     ),
//                   ),
//                 ),
//                 // if (config.appType == AppType.panenpanen)
//                 //   Visibility(
//                 //     visible:
//                 //     titleRoutePage == "warung" ? true : false,
//                 //         // titleRoutePage == "sayuran" || 
//                 //         // titleRoutePage == "buah" ||
//                 //         // titleRoutePage == "ikan" ||
//                 //         // titleRoutePage == "ternak" ||
//                 //         // titleRoutePage == "buah" ? false : true,
//                 //     child: Column(
//                 //       children: [
//                 //         SizedBox(
//                 //           height: widget.categoryId == 5 ? 0 : 28,
//                 //         ),
//                 //         Padding(
//                 //           padding: EdgeInsets.symmetric(horizontal: 82),
//                 //           child: Divider(
//                 //             thickness: 1,
//                 //             color: AppColor.grey,
//                 //             indent: 3,
//                 //             endIndent: 4,
//                 //           ),
//                 //         ),
//                 //         SizedBox(
//                 //           height: 28,
//                 //         ),
//                 //       ],
//                 //     ),
//                 //   ),
//                 // widget.isReseller == true ?
//                 // SellersWarungSection(recipentId: widget.recipentId,)
//                 // :
//                 // ProductsByCategorySection(
//                 //           categoryId: categoryIds,
//                 //         ),

//                 SizedBox(
//                   height: 45,
//                 ),
//                 FooterWeb(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class SellerListItemWeb extends StatelessWidget {
//   final bool isCatering;
//   final bool isFromShop;
//   final int categoryId;
//   // final Recipent selectedAddress;

//   const SellerListItemWeb({
//     Key key,
//     this.isCatering = false,
//     this.isFromShop = false,
//     this.categoryId,
//     // @required this.selectedAddress,
//   }) : super(key: key);

//   void _launchUrl(BuildContext context,String _url) async {
//     if (await canLaunch(_url)) {
//       await launch(_url);
//     } else {
//       showDialog(
//         context: context,
//         useRootNavigator: false,
//         builder: (ctx){
//           return AlertFailureWeb(
//             onPressClose: (){
//               AppExt.popScreen(context);
//             },
//             title: "Gagal mengakses halaman" ,
//             description:"Halaman atau koneksi internet bermasalah" ,
//           );
//         }
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double _screenWidth = MediaQuery.of(context).size.width;
//     // debugPrint("TESSS : " + AppExt.decryptMyData("KRq5huSVVkAbcboO0iMGQYaF+hiD3PIa6ZJmRlmShraCIOhs8ZTApRpHsvv5aA7FGDXmRpqBv1p+jsE+uZNPF2ugaSAo4f0o637xwSbXsbeo1L5pZGyP7tzl4GoAqTWPg2ljIru6D35OVNFnPhJ+Lk5xhMguMHnnjHlng/TwvC7sKyMD67/+CBCuNz6iArA/Ps0ZW0cLt6dENRFubqW40vmL6bsxk45L/M/SoGKH78cNQAMirXHh+6J7SbEgVdrQTVXSL3Kdvdd5aTObTkoDRlQwI330bno/iFhdjgmW3oQBpZcN5/yvRrUQxlfd/q25pyBPfX4n60Ei3gLLAquvuSDx2lX/gK6S4TDOzc9jzdU="));
//     // 4bWfP7l2QCq6KBJSII73vYcMXZdkcsVV7PIpS+U1nYNRhaWoCe3bU9PaAvaU6KIFWlvbWfG2ua6IqToUQ6UIA8Wf5ntIT3gW5pOXjGTxXrLAPmMnb8x5sM2c4PTx9ORRtvtx2Lx2FIX0EF6FioLPLSeIuS93BS2F+DG22FNh7WOXiEl172FzYVkDTJhDoftmB0Bdd2Fe4nQMC72FKWdI+6EPpSdnFoypTBcdVooHE2F8xVgcQrDjFCCB0dQmzqY1Gwah9njW0UcKkbaD8AiAeSNQrawQxD+jCKhPwOh2FRD2wTIha98hB2F2IJdoWBkTv
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.all(
//           Radius.circular(10),
//         ),
//         boxShadow: <BoxShadow>[
//           BoxShadow(
//             color: AppColor.grey.withOpacity(0.45),
//             blurRadius: 5,
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.white,
//         borderRadius: BorderRadius.all(
//           Radius.circular(5),
//         ),
//         child: InkWell(
//           onTap: () {
//           //   if (isCatering == true) {
//           //     context.beamToNamed(
//           //           '/productseller/${AppExt.convertCategoryWeb(categoryId)}/${seller.id}?c=${AppExt.encryptMyData(json.encode(seller))}'
//           //           //  '/mitra/${seller.phonenumber}'
//           //           );
//           //   }else{
//           //     _launchUrl(context,'https://bisnisomall.com/mitra/${seller.phonenumber}');
//           //   }
//           // },
//           },
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // ClipRRect(
//               //     borderRadius: BorderRadius.only(
//               //         bottomLeft: Radius.circular(5),
//               //         bottomRight: Radius.circular(5)),
//               //     child: Image(
//               //       image: NetworkImage(
//               //         "${AppConst.STORAGE_URL}/shop/${seller.shopPhoto}",
//               //       ),
//               //       width: double.infinity,
//               //       height: 165,
//               //       fit: BoxFit.contain,
//               //       errorBuilder: (context, object, stack) => Image.asset(
//               //         AppImg.img_error,
//               //         width: double.infinity,
//               //         height: 165,
//               //       ),
//               //       frameBuilder:
//               //           (context, child, frame, wasSynchronouslyLoaded) {
//               //         if (wasSynchronouslyLoaded) {
//               //           return child;
//               //         } else {
//               //           return AnimatedSwitcher(
//               //             duration: const Duration(milliseconds: 500),
//               //             child: frame != null
//               //                 ? child
//               //                 : Container(
//               //                     width: double.infinity,
//               //                     height: 165,
//               //                     decoration: BoxDecoration(
//               //                       borderRadius: BorderRadius.circular(10),
//               //                       color: Colors.grey[200],
//               //                     ),
//               //                   ),
//               //           );
//               //         }
//               //       },
//               //     )),
//               // Column(
//               //   crossAxisAlignment: CrossAxisAlignment.start,
//               //   children: [
//               //     SizedBox(height: 5),
//               //     Padding(
//               //       padding: const EdgeInsets.symmetric(horizontal: 10),
//               //       child: Center(
//               //         child: Text(
//               //           "${seller.nameSeller}",
//               //           maxLines: kIsWeb? null : 2,
//               //           overflow: TextOverflow.ellipsis,
//               //           style: AppTypo.subtitle2
//               //               .copyWith(fontWeight: FontWeight.w700),
//               //         ),
//               //       ),
//               //     ),
//               //     SizedBox(
//               //       height: 10,
//               //     ),
//               //     Padding(
//               //       padding: EdgeInsets.symmetric(horizontal: 10),
//               //       child: Text("${seller.subdistrict}",
//               //           style: AppTypo.subtitle2
//               //               .copyWith(color: AppColor.primary, fontSize: 13)),
//               //     ),

//               //     Padding(
//               //       padding: EdgeInsets.symmetric(horizontal: 10),
//               //       child: Text("${seller.city}",
//               //           style: AppTypo.subtitle2
//               //               .copyWith(color: AppColor.primary, fontSize: 13)),
//               //     ),

//               //     // Padding(
//               //     //       padding: EdgeInsets.symmetric(horizontal: 10),
//               //     //       child: Text("${seller.province}",
//               //     //           style: AppTypo.subtitle2
//               //     //               .copyWith(color: AppColor.primary, fontSize: 13)),
//               //     //     )
//               //   ],
//               // )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
