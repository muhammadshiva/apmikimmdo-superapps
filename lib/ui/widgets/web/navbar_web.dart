// import 'package:aligned_dialog/aligned_dialog.dart';
// import 'package:animations/animations.dart';
// import 'package:beamer/beamer.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_boxicons/flutter_boxicons.dart';
// import 'package:flutter_icons/flutter_icons.dart';
// import 'package:get/get_connect/connect.dart';
// import 'package:marketplace/data/blocs/shipping/fetch_shipping_addresses/fetch_shipping_addresses_cubit.dart';
// import 'package:marketplace/data/blocs/shipping/shipping_address/shipping_address_cubit.dart';
// import 'package:marketplace/data/blocs/transaction/handle_transaction_route_web/handle_transaction_route_web_cubit.dart';
// import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
// import 'package:marketplace/data/models/models.dart';
// import 'package:marketplace/data/repositories/repositories.dart';
// import 'package:marketplace/main.dart';
// import 'package:marketplace/ui/screens/screens.dart';
// import 'package:marketplace/ui/widgets/a_app_config.dart';
// import 'package:marketplace/ui/widgets/web/cart_drawer_web.dart';
// import 'package:marketplace/ui/widgets/web/dialog_alert_web.dart';
// import 'package:marketplace/ui/widgets/web/dialog_web.dart';
// import 'package:marketplace/ui/widgets/web/otp_modal_content.dart';
// import 'package:marketplace/ui/widgets/web/sign_in_modal_content.dart';
// import 'package:marketplace/ui/widgets/web/sign_up_modal_content.dart';
// import 'package:marketplace/ui/widgets/widgets.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:marketplace/utils/text.dart' as AppText;
// import 'package:marketplace/utils/typography.dart' as AppTypo;
// import 'package:marketplace/utils/colors.dart' as AppColor;
// import 'package:marketplace/utils/extensions.dart' as AppExt;
// import 'package:marketplace/utils/constants.dart' as AppConst;
// import 'package:marketplace/utils/transitions.dart' as AppTrans;
// import 'package:marketplace/utils/images.dart' as AppImg;
// import 'package:marketplace/utils/decorations.dart' as AppDecor;

// class NavbarWeb extends StatefulWidget with PreferredSizeWidget {
//   final Function changeKeyword;

//   // final FetchShippingAddressesCubit fetchShippingAddressesCubit;
//   // final Recipent selectedAddress;
//   final bool isDataAddressFromParent;
//   @override
//   final Size preferredSize;

//   NavbarWeb(
//       {Key key,
//       // this.fetchShippingAddressesCubit,
//       // this.selectedAddress,
//       this.isDataAddressFromParent = false,
//       this.changeKeyword})
//       : preferredSize = Size.fromHeight(100),
//         super(key: key);

//   @override
//   _NavbarWebState createState() => _NavbarWebState();
// }

// class _NavbarWebState extends State<NavbarWeb> {
//   // FetchShippingAddressesCubit _fetchShippingAddressesCubit;
//   final RecipentRepositoryOld _recipentRepo = RecipentRepositoryOld();
//   int _lastShippingAddressId;
//   Recipent _selectedAddress;

//   int statusSearch = 0;

//   void _handleAddAddress() async {
//     var isChanged = await AppExt.pushScreen(
//       context,
//       AddressEntryScreen(),
//     );
//     if (isChanged ?? false) {
//       BlocProvider.of<FetchShippingAddressesCubit>(context).load();
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     // _fetchShippingAddressesCubit = FetchShippingAddressesCubit();
//     if (BlocProvider.of<UserDataCubit>(context).state.user != null) {
//       BlocProvider.of<FetchShippingAddressesCubit>(context).load();
//     }
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     // _fetchShippingAddressesCubit.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final config = AAppConfig.of(context);
//     final String appLogo = AppImg.img_logo_new;

//     return Container(
//       // elevation:config.appType == AppType.bisnisogrosir || config.appType == AppType.bisnisomarket ? 10.0 : 0,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: config.appType == AppType.sumedang ||
//                     config.appType == AppType.panenpanen
//                 ? Colors.grey.withOpacity(0.5)
//                 : Colors.transparent,
//             spreadRadius: 0,
//             blurRadius: 8,
//             offset: Offset(4, 0), // changes position of shadow
//           ),
//         ],
//       ),
//       child: Material(
//         type: MaterialType.transparency,
//         child: BlocBuilder(
//           cubit: BlocProvider.of<UserDataCubit>(context),
//           builder: (context, userstate) {
//             return Padding(
//               padding: EdgeInsets.symmetric(vertical: 10),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     width: 30,
//                   ),
//                   MouseRegion(
//                     cursor: SystemMouseCursors.click,
//                     child: GestureDetector(
//                       onTap: () => context.beamToNamed('/'),
//                       child: Image.asset(
//                         appLogo,
//                         height: 40,
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 20,
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.only(top: 7),
//                       child: EditText(
//                         hintText: "Cari merek, produk dll...",
//                         inputType: InputType.search,
//                         // initialValue: "test",
//                         onFieldSubmitted: (value) => {
//                           context.beamToNamed(
//                             '/search/$value',
//                             // data: {'keyword': value},
//                           )
//                           // debugPrint(Beamer.of(context).beamHistory)
//                           // AppExt.popUntilRoot(context),
//                           // Navigator.push(context,PageRouteBuilder(
//                           //   transitionDuration: Duration(seconds: 0),
//                           //   pageBuilder: (_, __, ___) => SearchScreen(keyword: value,))
//                         },
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 20,
//                   ),
//                   if (userstate.user != null) ...[
//                     BlocBuilder(
//                       cubit:
//                           BlocProvider.of<FetchShippingAddressesCubit>(context),
//                       builder: (context, state) => state
//                               is FetchShippingAddressesLoading
//                           ? _AddressInputButton.loading()
//                           : state is FetchShippingAddressesSuccess
//                               ? _AddressInputButton.data(
//                                   selectedAddress:
//                                       BlocProvider.of<ShippingAddressCubit>(
//                                               context)
//                                           .state
//                                           .selectedRecipent,
//                                   isDataAddressFromParent:
//                                       widget.isDataAddressFromParent,
//                                   currentSelectedAddress: _selectedAddress,
//                                   onTap: () {
//                                     _showShippingAddressesDialog(
//                                       addresses: state.shippingAddresses,
//                                       onSelected: (id) async {
//                                         await _recipentRepo.setRecipentId(
//                                             state.shippingAddresses[id].id);
//                                         BlocProvider.of<
//                                                     FetchShippingAddressesCubit>(
//                                                 context)
//                                             .load();
//                                         // widget.selectedAddressForWeb(
//                                         //     state.shippingAddresses[id]);
//                                         // BlocProvider.of<FetchShippingAddressesCubit>(context).load();
//                                         BlocProvider.of<ShippingAddressCubit>(
//                                                 context)
//                                             .set(
//                                           selectedRecipent:
//                                               state.shippingAddresses[id],
//                                         );
//                                       },
//                                       lastSelectedId:
//                                           BlocProvider.of<ShippingAddressCubit>(
//                                                   context)
//                                               .state
//                                               .selectedRecipentIdx,
//                                     );
//                                     // debugPrint("recipent id" + _lastShippingAddressId.toString());
//                                   },
//                                 )
//                               : SizedBox(),
//                     ),
//                     SizedBox(
//                       width: 20,
//                     ),
//                     Row(
//                       children: [
//                         Stack(
//                           children: [
//                             IconButton(
//                               splashRadius: 30,
//                               icon: Icon(
//                                 FlutterIcons.cart_mco,
//                                 color: config.appType == AppType.sumedang
//                                     ? Colors.black
//                                     : config.appType == AppType.panenpanen
//                                         ? AppColor.grey
//                                         : AppColor.textPrimaryInverted,
//                               ),
//                               onPressed: () {
//                                 showGlobalDrawer(
//                                     context: scaffoldMainKey.currentContext,
//                                     useRootNavigator: false,
//                                     barrierDismissible: false,
//                                     barrierColor: Colors.transparent,
//                                     direction: AxisDirection.right,
//                                     duration: Duration(milliseconds: 300),
//                                     builder: (BuildContext context) {
//                                       return CartDrawerWeb();
//                                     });
//                                 // showDialog(context: context, builder: (BuildContext context) {
//                                 //   return CartDialogWeb();
//                                 // });
//                               },
//                             ),
//                             // BlocProvider.of<UserDataCubit>(context)
//                             //                     .state
//                             //                     .countCart +
//                             //                 BlocProvider.of<UserDataCubit>(
//                             //                         context)
//                             //                     .state
//                             //                     .countBooking !=
//                             //             null &&
//                             //         BlocProvider.of<UserDataCubit>(context)
//                             //                     .state
//                             //                     .countCart +
//                             //                 BlocProvider.of<UserDataCubit>(
//                             //                         context)
//                             //                     .state
//                             //                     .countBooking >
//                             //             0
//                             //     ? new Positioned(
//                             //         right: 0,
//                             //         top: -8,
//                             //         child: Chip(
//                             //           shape:
//                             //               CircleBorder(side: BorderSide.none),
//                             //           backgroundColor: AppColor.red,
//                             //           padding: EdgeInsets.zero,
//                             //           labelPadding: BlocProvider.of<
//                             //                                   UserDataCubit>(
//                             //                               context)
//                             //                           .state
//                             //                           .countCart +
//                             //                       BlocProvider.of<
//                             //                                   UserDataCubit>(
//                             //                               context)
//                             //                           .state
//                             //                           .countBooking >
//                             //                   99
//                             //               ? EdgeInsets.all(2)
//                             //               : EdgeInsets.all(4),
//                             //           label: Text(
//                             //             "${BlocProvider.of<UserDataCubit>(context).state.countCart + BlocProvider.of<UserDataCubit>(context).state.countBooking}",
//                             //             style: AppTypo.overlineInv
//                             //                 .copyWith(fontSize: 8.sp),
//                             //             textAlign: TextAlign.center,
//                             //           ),
//                             //         ),
//                             //       )
//                             //     : SizedBox.shrink(),
//                           ],
//                         ),
//                         // SizedBox(
//                         //   width: 20,
//                         // ),
//                         // IconButton(
//                         //     splashRadius: 30,
//                         //     icon: Icon(Boxicons.bxs_chat,
//                         //         color: AppColor.textPrimaryInverted),
//                         //     onPressed: () {}),
//                         SizedBox(
//                           width: 20,
//                         ),
//                         IconButton(
//                             splashRadius: 30,
//                             icon: Icon(
//                               FlutterIcons.script_text_mco,
//                               color: config.appType == AppType.sumedang
//                                   ? Colors.black
//                                   : config.appType == AppType.panenpanen
//                                       ? AppColor.grey
//                                       : AppColor.textPrimaryInverted,
//                             ),
//                             onPressed: () {
//                               context.beamToNamed('/transactionlist');
//                               // AppExt.pushScreen(
//                               //     context, TransactionNav(isColorPrimary: true));
//                             }),
//                       ],
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                   ],
//                   SizedBox(
//                     height: 35,
//                     child: VerticalDivider(
//                       thickness: 1.5,
//                       color: AppColor.grey,
//                     ),
//                   ),
//                   SizedBox(
//                     width: 15,
//                   ),
//                   if (userstate.user != null)
//                     _ProfileDropdown(
//                       username: userstate.user.name,
//                     )
//                   else
//                     Row(
//                       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.center,

//                       children: [
//                         Wrap(
//                           children: [
//                             RoundedButton.outlined(
//                               label: "Daftar",
//                               color: config.appType == AppType.sumedang
//                                   ? AppColor.textPrimaryInverted
//                                   : AppColor.primary,
//                               textColor: config.appType == AppType.sumedang
//                                   ? AppColor.textPrimaryInverted
//                                   : AppColor.primary,
//                               onPressed: () {
//                                 showDialog(
//                                     context: context,
//                                     builder: (BuildContext context) {
//                                       return Dialog(
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(20.0),
//                                         ), //this right here
//                                         child: Container(
//                                           constraints: BoxConstraints(
//                                             maxWidth: 500,
//                                           ),
//                                           // height: 200,
//                                           child:
//                                               AuthDialog(isRegisterForm: true),
//                                         ),
//                                       );
//                                     });
//                                 // AppExt.pushScreen(context, SignUpScreen());
//                               },
//                               isUpperCase: false,
//                               isCompact: true,
//                               hoverColor: AppColor.primary.withOpacity(0.1),
//                               splashColor: AppColor.primary.withOpacity(0.1),
//                             ),
//                           ],
//                         ),
//                         SizedBox(width: 13),
//                         Wrap(
//                           children: [
//                             Center(
//                               child: RoundedButton.contained(
//                                 label: "Login",
//                                 color: config.appType == AppType.sumedang
//                                     ? AppColor.textPrimaryInverted
//                                     : AppColor.primary,
//                                 textColor: config.appType == AppType.sumedang
//                                     ? AppColor.primary
//                                     : AppColor.textPrimaryInverted,
//                                 onPressed: () {
//                                   showDialog(
//                                       context: context,
//                                       builder: (BuildContext context) {
//                                         return Dialog(
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(20.0),
//                                           ), //this right here
//                                           child: Container(
//                                             constraints: BoxConstraints(
//                                               maxWidth: 500,
//                                             ),
//                                             // height: 200,
//                                             child:
//                                                 AuthDialog(isLoginForm: true),
//                                           ),
//                                         );
//                                       });
//                                 },
//                                 isUpperCase: false,
//                                 isCompact: true,
//                                 hoverColor: Colors.white.withOpacity(0.1),
//                                 splashColor: Colors.white.withOpacity(0.1),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   SizedBox(
//                     width: 30,
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   void _showShippingAddressesDialog({
//     @required int lastSelectedId,
//     @required List<Recipent> addresses,
//     @required void Function(int id) onSelected,
//   }) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return DialogWeb(
//           width: 700,
//           onPressedClose: () {
//             AppExt.popScreen(context);
//           },
//           child: SingleChildScrollView(
//             physics: new BouncingScrollPhysics(),
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 50),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                         'Dimana lokasi anda saat ini?',
//                         style: AppTypo.subtitle1
//                             .copyWith(fontWeight: FontWeight.w700),
//                       ),
//                   SizedBox(height: 6,),
//                   Text(
//                         'Agar kami bisa merekomendasikan produk yang sesuai, pilih alamat terlebih dahulu',
//                         style: AppTypo.caption.copyWith(fontSize: 12)
//                       ),
//                   SizedBox(height: 20),
//                   addresses.length > 0
//                       ? ListView.separated(
//                           physics: NeverScrollableScrollPhysics(),
//                           shrinkWrap: true,
//                           itemCount: addresses.length,
//                           separatorBuilder: (context, index) => SizedBox(
//                             height: 25,
//                           ),
//                           itemBuilder: (context, index) {
//                             return _buildAddressesItem(
//                               isActive: index == lastSelectedId,
//                               address: addresses[index],
//                               onTap: () {
//                                 onSelected(index);
//                                 Navigator.pop(context);
//                               },
//                             );
//                           },
//                         )
//                       : Center(
//                           child: Text("Alamat kosong",
//                               style: AppTypo.body1v2Accent)),
//                   SizedBox(height: 30),
//                   RoundedButton.contained(
//                     isCompact: true,
//                     label: "Tambah Alamat Baru",
//                     onPressed: () {
//                       AppExt.popScreen(context);
//                       _handleAddAddress();
//                     },
//                     isUpperCase: false,
//                   ),
//                   SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildAddressesItem({
//     @required Recipent address,
//     @required void Function() onTap,
//     @required bool isActive,
//   }) {
//     // final double _screenWidth = MediaQuery.of(context).size.width;

//     return BasicCard(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 18,horizontal: 25),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               flex: 4,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Text(
//                     "${address.name}",
//                     style:
//                         AppTypo.body1.copyWith(fontWeight: FontWeight.w700,fontSize: 14),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text("+${address.phone}", style: AppTypo.body1.copyWith(fontSize: 14)),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                       "${address.address}", style: AppTypo.body1.copyWith(fontSize: 14)),
//                 ],
//               ),
//             ),
//             isActive ?
//             Expanded(
//               child: Icon(
//                 FlutterIcons.check_ant,
//                 color: AppColor.primary,
//                 size: 20,
//               ),
//             ):
//             Expanded(
//               child: RoundedButton.contained(
//                 label: "Pilih", 
//                 isSmall: true,
//                 isUpperCase: false,
//                 onPressed: onTap
//               ),
//             )
//             // SizedBox(
//             //   height: 15,
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class AuthDialog extends StatefulWidget {
//   final bool isRegisterForm, isLoginForm;

//   const AuthDialog({
//     Key key,
//     this.isRegisterForm = false,
//     this.isLoginForm = false,
//   }) : super(key: key);

//   @override
//   _AuthDialogState createState() => _AuthDialogState();
// }

// class _AuthDialogState extends State<AuthDialog> {
//   final GlobalKey _authKey = GlobalKey();
//   final GlobalKey _otpKey = GlobalKey();

//   Size _widgetSize;
//   Offset _widgetPos;

//   bool _isRegisterForm;
//   bool _isLoginForm;

//   bool _isAnimating;

//   String _phone;

//   @override
//   void initState() {
//     super.initState();
//     widget.isRegisterForm == true
//         ? _isRegisterForm = true
//         : _isLoginForm = true;
//     _isAnimating = false;

//     WidgetsBinding.instance
//         .addPostFrameCallback((_) => _getSizeAndPos(_authKey));
//   }

//   void _getSizeAndPos(GlobalKey key) {
//     RenderBox _widgetBox = key.currentContext.findRenderObject();
//     _widgetSize = _widgetBox.size;
//     _widgetPos = _widgetBox.localToGlobal(Offset.zero);
//     // debugPrint(_widgetSize);
//     // debugPrint(_widgetPos);
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(20.0),
//       child: AnimatedContainer(
//         curve: Curves.easeInOut,
//         // padding: const EdgeInsets.all(12.0),
//         duration: Duration(milliseconds: 200),
//         height: _widgetSize?.height,
//         child: Wrap(
//           alignment: WrapAlignment.center,
//           runAlignment: WrapAlignment.center,
//           crossAxisAlignment: WrapCrossAlignment.center,
//           children: [
//             AnimatedOpacity(
//               opacity: _isAnimating ? 0 : 1,
//               duration: Duration(milliseconds: 300),
//               child: _isRegisterForm == true
//                   ? Align(
//                       key: _authKey,
//                       alignment: Alignment.center,
//                       child: SignUpModalContent(
//                         onRegister: (phone) async {
//                           if (phone == null) {
//                             setState(() {
//                               // _isAnimating = true;
//                               _isLoginForm = true;
//                               _isRegisterForm = false;
//                             });
//                             // await Future.delayed(Duration(milliseconds: 300));
//                             // setState(() {

//                             //   // _isAnimating = false;
//                             // });
//                           } else {
//                             setState(() {
//                               _phone = phone;
//                               _isAnimating = true;
//                             });
//                             await Future.delayed(Duration(milliseconds: 300));
//                             // _getSizeAndPos();
//                             setState(() {
//                               _isRegisterForm = false;
//                               WidgetsBinding.instance.addPostFrameCallback(
//                                   (_) => _getSizeAndPos(_otpKey));
//                               _isAnimating = false;
//                             });
//                           }
//                         },
//                       ),
//                     )
//                   : _isLoginForm == true
//                       ? Align(
//                           key: _authKey,
//                           alignment: Alignment.center,
//                           child: SignInModalContent(
//                             onLogin: (phone) async {
//                               if (phone == null) {
//                                 setState(() {
//                                   // _isAnimating = true;
//                                   _isRegisterForm = true;
//                                   _isLoginForm = false;
//                                 });
//                                 // await Future.delayed(
//                                 //     Duration(milliseconds: 300));
//                                 // setState(() {

//                                 //   _isAnimating = false;
//                                 // });
//                               } else {
//                                 setState(() {
//                                   _phone = phone;
//                                   _isAnimating = true;
//                                 });
//                                 await Future.delayed(
//                                     Duration(milliseconds: 300));

//                                 // _getSizeAndPos();
//                                 setState(() {
//                                   _isLoginForm = false;
//                                   WidgetsBinding.instance.addPostFrameCallback(
//                                       (_) => _getSizeAndPos(_otpKey));
//                                   _isAnimating = false;
//                                 });
//                               }
//                             },
//                           ),
//                         )
//                       : Align(
//                           key: _otpKey,
//                           alignment: Alignment.center,
//                           child: OtpModalContent(
//                             phoneNumber: "$_phone",
//                             otpTimeout: 60,
//                             onSuccess: () => AppExt.popScreen(context),
//                             onBack: () async {
//                               setState(() {
//                                 _isAnimating = true;
//                               });
//                               await Future.delayed(Duration(milliseconds: 300));

//                               // _getSizeAndPos();
//                               setState(() {
//                                 widget.isRegisterForm
//                                     ? _isRegisterForm = true
//                                     : _isLoginForm = true;

//                                 WidgetsBinding.instance.addPostFrameCallback(
//                                     (_) => _getSizeAndPos(_authKey));
//                                 _isAnimating = false;
//                               });
//                             },
//                           ),
//                         ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _ProfileDropdown extends StatefulWidget {
//   const _ProfileDropdown({
//     Key key,
//     @required this.username,
//   }) : super(key: key);

//   final String username;

//   @override
//   __ProfileDropdownState createState() => __ProfileDropdownState();
// }

// class __ProfileDropdownState extends State<_ProfileDropdown> {
//   final GlobalKey _dropdownKey = GlobalKey();

//   OverlayEntry _floatingDropdown;
//   bool _isDropdownopened;
//   Size _dropdownSize;
//   Offset _dropdownPos;

//   @override
//   void initState() {
//     super.initState();
//     _isDropdownopened = false;
//   }

//   void _getSizeAndPos() {
//     RenderBox _widgetBox = _dropdownKey.currentContext.findRenderObject();
//     _dropdownSize = _widgetBox.size;
//     _dropdownPos = _widgetBox.localToGlobal(Offset.zero);
//   }

//   OverlayEntry _createFloatingDropdown(
//       {VoidCallback onDismiss, AAppConfig config}) {
//     return OverlayEntry(
//       builder: (context) {
//         return Stack(
//           children: [
//             Positioned.fill(
//               child: GestureDetector(
//                 onTap: onDismiss,
//                 child: Container(
//                   color: Colors.transparent,
//                 ),
//               ),
//             ),
//             Positioned(
//               left: _dropdownPos.dx,
//               width: _dropdownSize.width,
//               top: _dropdownPos.dy,
//               // height: 4 * _dropdownSize.height,
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(_dropdownSize.height / 2),
//                   boxShadow: [
//                     BoxShadow(
//                       blurRadius: 20,
//                       color: Colors.black12,
//                     ),
//                   ],
//                 ),
//                 child: Material(
//                   type: MaterialType.transparency,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       _wrap(context, isOverlay: true),
//                       config.appType == AppType.sumedang
//                           ? Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 15, vertical: 5),
//                               child: InkWell(
//                                   onTap: () {
//                                     onDismiss();
//                                     if (BlocProvider.of<UserDataCubit>(context)
//                                             .state
//                                             .user.reseller ==
//                                         null) {
//                                       // context.beamToNamed('/shopsumedang/create');
//                                       showDialog(
//                                           context: context,
//                                           builder: (context) {
//                                             return AlertMaintenanceWeb(
//                                               onPressClose: () {
//                                                 AppExt.popScreen(context);
//                                               },
//                                               title:
//                                                   "Nantikan updatenya segera, hanya di Bisnisomall!",
//                                               description:
//                                                   "Halaman belum bisa diakses",
//                                             );
//                                           });
//                                     } else {
//                                       context.beamToNamed(
//                                           '/account/shop/productlist');
//                                     }
//                                   },
//                                   child: Text("Toko Anda",
//                                       style: AppTypo.subtitle2)),
//                             )
//                           : SizedBox(),
//                       InkWell(
//                         onTap: () {
//                           onDismiss();
//                           context.beamToNamed('/account/profile');
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 15, vertical: 5),
//                           child: Text(
//                             "Akun",
//                             style: AppTypo.subtitle2,
//                           ),
//                         ),
//                       ),
//                       config.appType == AppType.panenpanen &&
//                               BlocProvider.of<UserDataCubit>(context)
//                                       .state
//                                       .user
//                                       ?.roleId ==
//                                   '5'
//                           ? InkWell(
//                               onTap: () {
//                                 onDismiss();
//                                 context.beamToNamed('/my-warung');
//                               },
//                               child: Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 15, vertical: 5),
//                                   child: Text("Reseller",
//                                       style: AppTypo.subtitle2)),
//                             )
//                           : BlocProvider.of<UserDataCubit>(context)
//                                       .state
//                                       .user.reseller!=
//                                   null
//                               ? BlocProvider.of<UserDataCubit>(context)
//                                           .state
//                                           .user
//                                           ?.roleId ==
//                                       '4'
//                                   ? InkWell(
//                                       onTap: () {
//                                         onDismiss();
//                                         context.beamToNamed(
//                                             '/account/shop/productlist');
//                                       },
//                                       child: Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 15, vertical: 5),
//                                           child: Text("Supplier",
//                                               style: AppTypo.subtitle2)),
//                                     )
//                                   : InkWell(
//                                       onTap: () {
//                                         onDismiss();
//                                         context.beamToNamed(
//                                             '/account/shop/productlist');
//                                       },
//                                       child: Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 15, vertical: 5),
//                                           child: Text("Toko",
//                                               style: AppTypo.subtitle2)),
//                                     )
//                               : SizedBox.shrink(),
//                       Padding(
//                         padding: const EdgeInsets.all(15),
//                         child: RoundedButton.contained(
//                           label: "Logout",
//                           color: AppColor.danger,
//                           textColor: Colors.white,
//                           onPressed: () {
//                             BlocProvider.of<UserDataCubit>(context).logout();
//                             onDismiss();
//                             BlocProvider.of<HandleTransactionRouteWebCubit>(
//                                     context)
//                                 .changeCheckCheckout(false);
//                             BlocProvider.of<HandleTransactionRouteWebCubit>(
//                                     context)
//                                 .changeCheckChoosePayment(false);
//                             BlocProvider.of<HandleTransactionRouteWebCubit>(
//                                     context)
//                                 .changeCheckPayment(false);
//                             BlocProvider.of<HandleTransactionRouteWebCubit>(
//                                     context)
//                                 .changeCheckPaymentWeb(false);
//                             context.beamToNamed('/');
//                           },
//                           isUpperCase: false,
//                           isCompact: true,
//                           hoverColor: Colors.black.withOpacity(0.1),
//                           splashColor: AppColor.danger.withOpacity(0.5),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final config = AAppConfig.of(context);
//     return _wrap(context, key: _dropdownKey, config: config);
//   }

//   InkWell _wrap(BuildContext context,
//       {Key key, bool isOverlay = false, AAppConfig config}) {
//     return InkWell(
//       key: key,
//       onTap: () {
//         if (_isDropdownopened) {
//           _floatingDropdown.remove();
//           _isDropdownopened = false;
//         } else {
//           _getSizeAndPos();
//           _floatingDropdown = _createFloatingDropdown(
//               onDismiss: () {
//                 _floatingDropdown.remove();
//                 _isDropdownopened = false;
//               },
//               config: config);
//           Overlay.of(context).insert(_floatingDropdown);
//           _isDropdownopened = true;
//         }
//       },
//       borderRadius: BorderRadius.circular(50),
//       highlightColor: Colors.black.withOpacity(0.1),
//       hoverColor: Colors.black.withOpacity(0.05),
//       child: Padding(
//         padding: const EdgeInsets.all(7).copyWith(right: 20),
//         child: Row(
//           // crossAxisAlignment: CrossAxisAlignment.center,
//           // mainAxisAlignment: MainAxisAlignment.center,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(17),
//               child: BlocProvider.of<UserDataCubit>(context).state.user != null
//                   ? Image.asset(
//                       AppImg.img_empty_user,
//                       width: 34,
//                       height: 34,
//                     )
//                   : Image.network(
//                       "${AppConst.STORAGE_URL}/user/avatar/${BlocProvider.of<UserDataCubit>(context).state.user.avatar}",
//                       height: 34,
//                       width: 34,
//                       frameBuilder:
//                           (context, child, frame, wasSynchronouslyLoaded) {
//                         if (wasSynchronouslyLoaded) {
//                           return child;
//                         } else {
//                           return AnimatedSwitcher(
//                             duration: const Duration(milliseconds: 1000),
//                             child: frame != null
//                                 ? Container(
//                                     width: 34,
//                                     height: 34,
//                                     color: Color(0xFFD1F5B9),
//                                     child: child,
//                                   )
//                                 : Container(
//                                     width: 34,
//                                     height: 34,
//                                     color: Color(0xFFD1F5B9),
//                                     child: Image.asset(
//                                       AppImg.img_empty_user,
//                                       width: 34,
//                                       height: 34,
//                                     ),
//                                   ),
//                           );
//                         }
//                       },
//                       errorBuilder: (context, url, error) => Container(
//                         width: 34,
//                         height: 34,
//                         color: Color(0xFFD1F5B9),
//                         child: Image.asset(
//                           AppImg.img_empty_user,
//                           width: 34,
//                           height: 34,
//                         ),
//                       ),
//                     ),
//             ),
//             // CircleAvatar(
//             //   maxRadius: 17,
//             //   backgroundImage: BlocProvider.of<UserDataCubit>(context)
//             //               .state
//             //               .user
//             //               ?.avatar ==
//             //           null
//             //       ?
//             //        AssetImage(AppImg.img_empty_user)
//             //       : NetworkImage(
//             //           "${AppConst.STORAGE_URL}/user/avatar/${BlocProvider.of<UserDataCubit>(context).state.user.avatar}",),
//             // ),
//             SizedBox(
//               width: 15,
//             ),
//             RichText(
//               text: TextSpan(
//                 style: AppTypo.body1.copyWith(
//                   color: Colors.black,
//                   // isOverlay
//                   //     ? Colors.black
//                   //     : config.appType == AppType.sumedang
//                   //         ? Colors.black
//                   //         : Colors.white,
//                 ),
//                 children: [
//                   TextSpan(
//                     text: "Halo, ",
//                     style: AppTypo.body1.copyWith(
//                       color: Colors.black,
//                       // isOverlay
//                       //     ? Colors.black
//                       //     : config.appType == AppType.sumedang
//                       //         ? Colors.black
//                       //         : Colors.white,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   TextSpan(
//                     text: "${widget.username}",
//                   ),
//                 ],
//               ),
//             ),

//             // Text(
//             //   " Halo, " + userstate.user.name,
//             //   style: AppTypo.h2Accent.copyWith(
//             //       fontSize: 14.sp,
//             //       color: AppColor.textPrimaryInverted),
//             // )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _AddressInputButton extends StatelessWidget {
//   const _AddressInputButton.loading() : this._(isLoading: true);

//   const _AddressInputButton.data({
//     Key key,
//     @required Recipent selectedAddress,
//     @required bool isDataAddressFromParent,
//     @required Recipent currentSelectedAddress,
//     @required VoidCallback onTap,
//   }) : this._(
//           key: key,
//           selectedAddress: selectedAddress,
//           isDataAddressFromParent: isDataAddressFromParent,
//           currentSelectedAddress: currentSelectedAddress,
//           onTap: onTap,
//           isLoading: false,
//         );

//   const _AddressInputButton._({
//     this.key,
//     this.selectedAddress,
//     this.isDataAddressFromParent,
//     this.currentSelectedAddress,
//     this.onTap,
//     this.isLoading,
//   }) : super(key: key);

//   final Key key;
//   final Recipent selectedAddress;
//   final bool isDataAddressFromParent;
//   final Recipent currentSelectedAddress;
//   final VoidCallback onTap;
//   final bool isLoading;

//   @override
//   Widget build(BuildContext context) {
//     // final config = AAppConfig.of(context);
//     return Material(
//       type: MaterialType.button,
//       color: Color(0XFFF4F4F4),
//       borderRadius: BorderRadius.circular(10),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(10),
//         onTap: isLoading ? null : onTap,
//         child: Container(
//           width: 300,
//           padding: EdgeInsets.symmetric(
//             horizontal: 12,
//             vertical: 7,
//           ),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       "Alamat",
//                       style: AppTypo.overline.copyWith(color: AppColor.grey),
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: kIsWeb ? null : 1,
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                         color:
//                             isLoading ? Colors.grey[200] : Colors.transparent,
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       child: Text(
//                         "",
//                         // isLoading
//                         //     ? "Loading..."
//                         //     : isDataAddressFromParent
//                         //         ? selectedAddress != null
//                         //             ? "${selectedAddress.recipentLocation.city}, ${selectedAddress.recipentLocation.province}"
//                         //             : "Alamat belum ditentukan"
//                         //         : currentSelectedAddress != null
//                         //             ? "${currentSelectedAddress.recipentLocation.city}, ${currentSelectedAddress.recipentLocation.province}"
//                         //             : "Alamat belum ditentukan",
//                         style: AppTypo.caption.copyWith(
//                             color: AppColor.textPrimary
//                                 .withOpacity(isLoading ? 0 : 1)),
//                         overflow: TextOverflow.ellipsis,
//                         // maxLines: kIsWeb? null : 2,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(width: 10),
//               if (isLoading)
//                 SizedBox(
//                   width: 20,
//                   height: 20,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 3,
//                   ),
//                 )
//               else
//                 Icon(
//                   Icons.edit,
//                   color: AppColor.primary,
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
