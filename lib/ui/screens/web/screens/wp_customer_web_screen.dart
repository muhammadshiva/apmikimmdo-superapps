// import 'dart:convert';

// import 'package:animations/animations.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_boxicons/flutter_boxicons.dart';
// import 'package:flutter_icons/flutter_icons.dart';
// import 'package:beamer/beamer.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:marketplace/api/api.dart';
// import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
// import 'package:marketplace/data/blocs/new_cubit/search/search_cubit.dart';
// import 'package:marketplace/data/blocs/warung_panen/fetch_wp_customers/fetch_wp_customers_cubit.dart';
// import 'package:marketplace/data/models/models.dart';
// import 'package:marketplace/ui/widgets/basic_card.dart';
// import 'package:marketplace/ui/widgets/edit_text.dart';
// import 'package:marketplace/ui/widgets/loading_dialog.dart';
// import 'package:marketplace/ui/widgets/rounded_button.dart';
// import 'package:marketplace/ui/widgets/web/dialog_alert_web.dart';
// import 'package:marketplace/ui/widgets/web/dialog_web.dart';
// import 'package:marketplace/ui/widgets/web/footer_web.dart';
// import 'package:marketplace/utils/typography.dart' as AppTypo;
// import 'package:marketplace/utils/colors.dart' as AppColor;
// import 'package:marketplace/utils/extensions.dart' as AppExt;
// import 'package:marketplace/utils/constants.dart' as AppConst;
// import 'package:marketplace/utils/transitions.dart' as AppTrans;
// import 'package:marketplace/utils/images.dart' as AppImg;
// import 'package:marketplace/utils/validator.dart';
// import 'package:url_launcher/url_launcher.dart';

// class WpCustomerWebScreen extends StatefulWidget {
//   const WpCustomerWebScreen({Key key}) : super(key: key);

//   @override
//   _WpCustomerWebScreenState createState() => _WpCustomerWebScreenState();
// }

// class _WpCustomerWebScreenState extends State<WpCustomerWebScreen> {
//   FetchWpCustomersCubit _fetchWpCustomersCubit;
//   TextEditingController _searchController;

//   FocusNode _focusNode;
//   String _copywriting;

//   @override
//   void initState() {
//     _fetchWpCustomersCubit = FetchWpCustomersCubit()..load();
//     _focusNode = FocusNode();
//     _searchController = TextEditingController(text: "");
//     // _copywriting =
//     //     BlocProvider.of<UserDataCubit>(context).state.seller.copywriting == null
//     //         ? ''
//     //         : BlocProvider.of<UserDataCubit>(context)
//     //             .state
//     //             .seller
//     //             .copywriting
//     //             .replaceMapPattern(
//     //             {
//     //               "{nama}":
//     //                   "${BlocProvider.of<UserDataCubit>(context).state.seller.nameSeller}",
//     //               "{alamat}":
//     //                   "${BlocProvider.of<UserDataCubit>(context).state.seller.addressSeller}",
//     //               "{telp}":
//     //                   "${BlocProvider.of<UserDataCubit>(context).state.user.phonenumber}",
//     //               '{link}':
//     //                   '${AppConst.WEB_URL_DOMAIN}/${AppConst.WP_URL_PATH_ID}/${BlocProvider.of<UserDataCubit>(context).state.user.phonenumber}',
//     //             },
//     //           );
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _fetchWpCustomersCubit.close();
//     _searchController.dispose();
//     super.dispose();
//   }

//   _searchOnChanged(String keyword) {
//     _fetchWpCustomersCubit.search(keyword: keyword);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (context) => _fetchWpCustomersCubit,
//         ),
//       ],
//       child: ListView(
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 82, vertical: 40),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   flex: 1,
//                   child: BasicCard(
//                     child: Padding(
//                       padding: EdgeInsets.all(15),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "",
//                             // "Reseller - ${BlocProvider.of<UserDataCubit>(context).state.seller.nameSeller.capitalize()}",
//                             style: AppTypo.subtitle1.copyWith(
//                                 fontSize: 18, fontWeight: FontWeight.w700),
//                           ),
//                           SizedBox(height: 5),
//                           Text(
//                             "",
//                               // "${BlocProvider.of<UserDataCubit>(context).state.seller.addressSeller} - ${BlocProvider.of<UserDataCubit>(context).state.seller.subdistrict.subdistrictName} - ${BlocProvider.of<UserDataCubit>(context).state.seller.subdistrict.city}, ${BlocProvider.of<UserDataCubit>(context).state.seller.subdistrict.province} ",
//                               style: AppTypo.body1v2),
//                           SizedBox(height: 25),
//                           RoundedButton.outlined(
//                             isUpperCase: false,
//                             label: "Bagikan Reseller",
//                             onPressed: () async => await launch(
//                                 "https://api.whatsapp.com/send?text=$_copywriting"),
//                             leading: Icon(
//                               Boxicons.bxl_whatsapp,
//                               size: 20,
//                               color: AppColor.primary,
//                             ),
//                           ),
//                           SizedBox(height: 15),
//                           Divider(
//                             thickness: 1,
//                             color: Colors.grey,
//                             indent: 1,
//                             endIndent: 1,
//                           ),
//                           SizedBox(height: 15),
//                           InkWell(
//                             onTap: () {
//                               context.beamToNamed('/edit-warung');
//                             },
//                             child: Text(
//                               "Ubah Data Reseller",
//                               style: AppTypo.subtitle2v2,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 30),
//                 Expanded(
//                     flex: 3,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Daftar Pelanggan",
//                           style: AppTypo.h2.copyWith(fontSize: 24),
//                         ),
//                         SizedBox(height: 10),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Expanded(
//                               flex: 1,
//                               child: EditText(
//                                 hintText: "Cari nama pelanggan anda",
//                                 inputType: InputType.search,
//                                 controller: _searchController,
//                                 focusNode: _focusNode,
//                                 onChanged: _searchOnChanged,
//                               ),
//                             ),
//                             Expanded(
//                               flex: 2,
//                               child: BlocBuilder(
//                                 cubit: _fetchWpCustomersCubit,
//                                 builder: (context, state) => state
//                                         is FetchWpCustomersSuccess
//                                     ? state.data.length > 0
//                                         ? Align(
//                                             alignment: Alignment.centerRight,
//                                             child: Text(
//                                               "${state.data.length} Pelanggan",
//                                               style: AppTypo.subtitle1v2
//                                                   .copyWith(
//                                                       fontWeight:
//                                                           FontWeight.w700),
//                                             ),
//                                           )
//                                         : SizedBox.shrink()
//                                     : SizedBox.shrink(),
//                               ),
//                             )
//                           ],
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 20),
//                           child: Divider(
//                             thickness: 1,
//                             color: Colors.grey,
//                             indent: 1,
//                             endIndent: 1,
//                           ),
//                         ),
//                         BlocBuilder(
//                           cubit: _fetchWpCustomersCubit,
//                           builder: (context, state) =>
//                               AppTrans.SharedAxisTransitionSwitcher(
//                             transitionType: SharedAxisTransitionType.vertical,
//                             fillColor: Colors.transparent,
//                             child: state is FetchWpCustomersSuccess
//                                 ? state.data.length > 0
//                                     ? Center(
//                                         child: GridView.builder(
//                                           padding: EdgeInsets.all(10),
//                                           shrinkWrap: true,
//                                           physics:
//                                               NeverScrollableScrollPhysics(),
//                                           itemCount: state.data.length,
//                                           gridDelegate:
//                                               const SliverGridDelegateWithMaxCrossAxisExtent(
//                                             maxCrossAxisExtent: 600,
//                                             mainAxisExtent: 200,
//                                             crossAxisSpacing: 10,
//                                             mainAxisSpacing: 10,
//                                           ),
//                                           itemBuilder: (
//                                             context,
//                                             index,
//                                           ) {
//                                             final TokoSayaCustomer _item =
//                                                 state.data[index];
//                                             return CardWpCustomer(
//                                                 customer: _item);
//                                           },
//                                         ),
//                                       )
//                                     : Center(
//                                         child: Container(
//                                           padding: EdgeInsets.only(
//                                               bottom: kToolbarHeight),
//                                           child: Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             children: [
//                                               Image.asset(
//                                                 AppImg.img_not_found,
//                                                 width: 50,
//                                                 height: 50,
//                                                 fit: BoxFit.contain,
//                                               ),
//                                               SizedBox(
//                                                 height: 20,
//                                               ),
//                                               Text(
//                                                 "Belum ada pelanggan",
//                                                 style: AppTypo.h3.copyWith(
//                                                     fontWeight:
//                                                         FontWeight.w500),
//                                                 textAlign: TextAlign.center,
//                                               ),
//                                               SizedBox(
//                                                 height: 5,
//                                               ),
//                                               Text(
//                                                 "Belum ada pelanggan yang melakukan pembelian",
//                                                 style: AppTypo.body1v2,
//                                                 textAlign: TextAlign.center,
//                                               ),
//                                               SizedBox(
//                                                 height: 30,
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       )
//                                 : state is FetchWpCustomersLoading
//                                     ? Center(
//                                         child: CircularProgressIndicator(
//                                             valueColor:
//                                                 new AlwaysStoppedAnimation<
//                                                     Color>(AppColor.primary)),
//                                       )
//                                     : state is FetchWpCustomersFailure
//                                         ? Center(
//                                             child: Container(
//                                               padding: EdgeInsets.only(
//                                                   bottom: kToolbarHeight),
//                                               child: state.type ==
//                                                       ErrorType.network
//                                                   ? Column(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .center,
//                                                       children: [
//                                                         Image.asset(
//                                                           AppImg
//                                                               .img_no_connection,
//                                                           width: 60,
//                                                           height: 30,
//                                                           fit: BoxFit.contain,
//                                                         ),
//                                                         SizedBox(
//                                                           height: 20,
//                                                         ),
//                                                         Text(
//                                                           "Tidak ada koneksi internet",
//                                                           style: AppTypo.h3
//                                                               .copyWith(
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w700),
//                                                           textAlign:
//                                                               TextAlign.center,
//                                                         ),
//                                                         SizedBox(
//                                                           height: 5,
//                                                         ),
//                                                         Text(
//                                                           "Cek paket data/koneksi wifi kamu lalu coba lagi..",
//                                                           style: AppTypo
//                                                               .overlineAccent,
//                                                           textAlign:
//                                                               TextAlign.center,
//                                                         ),
//                                                         SizedBox(
//                                                           height: 20,
//                                                         ),
//                                                         RoundedButton.contained(
//                                                           isCompact: true,
//                                                           label: "Coba Lagi",
//                                                           onPressed: () =>
//                                                               _fetchWpCustomersCubit
//                                                                   .load(),
//                                                         ),
//                                                       ],
//                                                     )
//                                                   : Column(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .center,
//                                                       children: [
//                                                         // Icon(
//                                                         Icon(
//                                                           FlutterIcons
//                                                               .error_outline_mdi,
//                                                           size: 45,
//                                                           color: AppColor
//                                                               .primaryDark,
//                                                         ),
//                                                         SizedBox(
//                                                           height: 10,
//                                                         ),
//                                                         SizedBox(
//                                                           width: 250,
//                                                           child: Text(
//                                                             state.message,
//                                                             style: AppTypo
//                                                                 .overlineAccent,
//                                                             textAlign: TextAlign
//                                                                 .center,
//                                                           ),
//                                                         ),
//                                                         SizedBox(
//                                                           height: 7,
//                                                         ),
//                                                         OutlineButton(
//                                                           child:
//                                                               Text("Coba lagi"),
//                                                           onPressed: () =>
//                                                               _fetchWpCustomersCubit
//                                                                   .load(),
//                                                           textColor: AppColor
//                                                               .primaryDark,
//                                                           color:
//                                                               AppColor.danger,
//                                                         ),
//                                                       ],
//                                                     ),
//                                             ),
//                                           )
//                                         : SizedBox.shrink(),
//                           ),
//                         )
//                       ],
//                     ))
//               ],
//             ),
//           ),
//           FooterWeb()
//         ],
//       ),
//     );
//   }
// }

// class CardWpCustomer extends StatelessWidget {
//   const CardWpCustomer({Key key, @required this.customer}) : super(key: key);

//   final TokoSayaCustomer customer;

//   @override
//   Widget build(BuildContext context) {
//     return BasicCard(
//       child: Padding(
//         padding: const EdgeInsets.all(25),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "${customer.name}",
//                     maxLines: kIsWeb ? 2 : 2,
//                     overflow: TextOverflow.ellipsis,
//                     style:
//                         AppTypo.body1v2.copyWith(fontWeight: FontWeight.w700),
//                   ),
//                   SizedBox(
//                     height: 5,
//                   ),
//                   Text("${customer.phone}", style: AppTypo.caption),
//                   SizedBox(
//                     height: 15,
//                   ),
//                   Text(
//                     "${customer.address}, RT ${customer.rt}/RW ${customer.rw},\n${customer.subdistrict}, ${customer.city}",
//                     style:
//                         AppTypo.caption.copyWith(color: AppColor.textSecondary),
//                     maxLines: kIsWeb ? null : 3,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 5,
//             ),
//             Align(
//               alignment: Alignment.bottomRight,
//               child: Container(
//                 width: 140,
//                 height: 50,
//                 child: RoundedButton.contained(
//                   isUpperCase: false,
//                   label: "Hubungi",
//                   onPressed: () async => await launch(
//                       "https://api.whatsapp.com/send?phone=${customer.phone}"),
//                   leading: Icon(
//                     Boxicons.bxl_whatsapp,
//                     size: 20,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
