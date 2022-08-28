import 'dart:convert';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:marketplace/data/models/cart.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/models/new_models/alamat_pelanggan.dart';
import 'package:marketplace/data/repositories/cart_repository.dart';
import 'package:marketplace/ui/screens/new_screens/new_screens.dart';
import 'package:marketplace/ui/screens/new_screens/web/warung_panen_public/wpp_alamat_pelanggan_screen.dart';
import 'package:marketplace/ui/screens/new_screens/web/warung_panen_public/wpp_checkout_web_screen.dart';
import 'package:marketplace/ui/screens/new_screens/web/warung_panen_public/wpp_choose_subdistrict_coverage_web_screen.dart';
import 'package:marketplace/ui/screens/new_screens/web/warung_panen_public/wpp_homepage_web_screen.dart';
import 'package:marketplace/ui/screens/new_screens/web/warung_panen_public/wpp_invoice_payment_web_screen.dart';
import 'package:marketplace/ui/screens/new_screens/web/warung_panen_public/wpp_list_warung_web_screen.dart';
import 'package:marketplace/ui/screens/new_screens/web/warung_panen_public/wpp_payment_detail_web_screen.dart';
import 'package:marketplace/ui/screens/new_screens/web/warung_panen_public/wpp_payment_web_screen.dart';
import 'package:marketplace/ui/screens/new_screens/web/warung_panen_public/wpp_cart_web_screen.dart';
import 'package:marketplace/ui/screens/new_screens/web/warung_panen_public/wpp_product_detail_web_screen.dart';
import 'package:marketplace/ui/screens/web/screens/web_screens.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;

final boxData = GetStorage();
final CartRepository _repo = CartRepository();

class HomeLocation extends BeamLocation {
  @override
  List<String> get pathBlueprints => [
        '/',
      ];

  @override
  List<BeamPage> pagesBuilder(BuildContext context) => [
        BeamPage(key: ValueKey('home'), child: WppHomepageWebScreen()),
      ];
}

class WarungPanenPublicLocation extends BeamLocation {
  @override
  List<String> get pathBlueprints => [
        '/wpp/listwarung/:subdistrictId',
        '/wpp/subdistrictcheck',
        '/wpp/dashboard/:slug',
        '/wpp/productdetail/:slugwarung/:slugproduct/:productId',
        '/wpp/cart',
        '/wpp/customeraddress',
        '/wpp/checkout',
        '/wpp/payment',
        '/wpp/paymentdetail',
        '/wpp/invoice',
      ];

  @override
  List<BeamPage> pagesBuilder(BuildContext context) {
    List<NewCart> listCart = [];
    AlamatPelangganWithCart alamatPelangganWithCart;
    WppCheckoutTempWeb checkoutTempWeb;
    WppInvoice wppInvoice;


    if (state.uri.pathSegments.contains('customeraddress')) {
      final List<dynamic> data =
          json.decode(AppExt.decryptMyData(state.queryParameters['dt']));
      listCart = data.map((e) => NewCart.fromJson(e)).toList();
    }

    if (state.uri.pathSegments.contains('checkout')) {
      final Map<String,dynamic> data =
          json.decode(AppExt.decryptMyData(state.queryParameters['dt']));
      alamatPelangganWithCart =  AlamatPelangganWithCart.fromJson(data);
    }

    if (state.uri.pathSegments.contains('payment')) {
      final Map<String,dynamic> data =
          json.decode(AppExt.decryptMyData(state.queryParameters['dt']));
      checkoutTempWeb =  WppCheckoutTempWeb.fromJson(data);
    }

    if (state.uri.pathSegments.contains('paymentdetail')) {
      final Map<String,dynamic> data =
          json.decode(AppExt.decryptMyData(state.queryParameters['dt']));
      wppInvoice =  WppInvoice.fromJson(data);
    }

    if (state.uri.pathSegments.contains('invoice')) {
      final Map<String,dynamic> data =
          json.decode(AppExt.decryptMyData(state.queryParameters['dt']));
      wppInvoice =  WppInvoice.fromJson(data);
    }

    return [
      ...HomeLocation().pagesBuilder(context),
      if (state.uri.pathSegments.contains('listwarung'))
        BeamPage(
            key: ValueKey('listwarung'),
            child: WppListWarungWebScreen(
              subdistrictId: int.parse(state.pathParameters['subdistrictId']),
            )),
      if (state.uri.pathSegments.contains('subdistrictcheck'))
        BeamPage(
            key: ValueKey('subdistrictcheck'),
            child: WppChooseSubdistrictCoverageWebScreen()),
      if (state.uri.pathSegments.contains('dashboard'))
        BeamPage(
            key: ValueKey('dashboard'),
            child: WppDashboardWarungWebScreen(
              slugReseller: state.pathParameters['slug'],
            )),
      if (state.uri.pathSegments.contains('productdetail'))
        BeamPage(
            key: ValueKey('${state.pathParameters['productId']}'),
            child: WppProductDetailWebScreen(
                slugWarung: state.pathParameters['slugwarung'],
                slugProduct: state.pathParameters['slugproduct'],
                productId: int.parse(state.pathParameters['productId']))),
      if (state.uri.pathSegments.contains('cart'))
        BeamPage(key: ValueKey('cart'), child: WppCartWebScreen()),
      if (state.uri.pathSegments.contains('customeraddress'))
        BeamPage(
            key: ValueKey('customeraddress'),
            child: WppAlamatPelangganScreen(
              cart: listCart,
            )),
      if (state.uri.pathSegments.contains('checkout'))
        BeamPage(
            key: ValueKey('checkout'),
            child: WppCheckoutWebScreen(
              cart: alamatPelangganWithCart.newCart,
              alamatPelangganWithCart : alamatPelangganWithCart,
            )),
      if (state.uri.pathSegments.contains('payment'))
        BeamPage(
            key: ValueKey('payment'),
            child: WppPaymentWebScreen(checkoutTemp: checkoutTempWeb,),
            ),
      if (state.uri.pathSegments.contains('paymentdetail'))
        BeamPage(
            key: ValueKey('paymentdetail'),
            child: WppPaymentDetailWebScreen(
              orderData: wppInvoice.order,
              checkoutTempWeb: wppInvoice.checkout,
            )),
      if (state.uri.pathSegments.contains('invoice'))
        BeamPage(
            key: ValueKey('invoice'),
            child: WppInvoicePaymentWebScreen(
              order: wppInvoice.order,
              checkout: wppInvoice.checkout,
            )),
    ];
  }
}

// class ProductDetailLocation extends BeamLocation {
//   @override
//   List<String> get pathBlueprints => [
//         '/wpp/productdetail/:productId',
//       ];

//   @override
//   List<BeamPage> pagesBuilder(BuildContext context) => [
//     ...HomeLocation().pagesBuilder(context),
//     if (state.uri.pathSegments.contains('productdetail'))
//       BeamPage(key: ValueKey('productdetail'),
//       child: WppProductDetailWebScreen(
//         isPublicWarung: true,
//         productId: int.parse(state.pathParameters['productId'])
//         )),
//   ];
// }

// class CartLocation extends BeamLocation {
//   @override
//   List<String> get pathBlueprints => [
//         '/wpp/cart',
//       ];

//   @override
//   List<BeamPage> pagesBuilder(BuildContext context) => [
//     ...HomeLocation().pagesBuilder(context),
//     if (state.uri.pathSegments.contains('cart'))
//       BeamPage(
//         key: ValueKey('cart'),
//         child:  WppCartWebScreen()
//       ),
//   ];
// }

// class CheckoutLocation extends BeamLocation {
//   @override
//   List<String> get pathBlueprints => [
//         '/checkout/:cart',
//       ];

//   @override
//   List<BeamPage> pagesBuilder(BuildContext context) => [
//     ...HomeLocation().pagesBuilder(context),
//     if (state.uri.pathSegments.contains('checkout'))
//       BeamPage(
//         key: ValueKey('checkout'),
//         child: WppCheckoutWebScreen(
//           cart: state.data['cart'],
//           alamatPelanggan: state.data['alamatPelanggan'],
//         )
//       ),
//   ];
// }

// class AddressLocation extends BeamLocation {
//   AddressLocation() : super();

//   @override
//   List<String> get pathBlueprints => [
//         '/addressentry',
//       ];

//   List<BeamPage> pagesBuilder(BuildContext context) {
//     return [
//       ...HomeLocation().pagesBuilder(context),
//       if (state.uri.pathSegments.contains('addressentry'))
//         BeamPage(
//         key: ValueKey('addressentry'),
//         child: WppAlamatPelangganScreen(
//           cart: state.data['cart']
//         )
//       ),
//     ];
//   }
// }

// class PaymentLocation extends BeamLocation {
//   PaymentLocation() : super();

//   @override
//   List<String> get pathBlueprints => [
//         '/payment',
//         '/paymentdetail'
//       ];

//   List<BeamPage> pagesBuilder(BuildContext context) {
//     return [
//       ...HomeLocation().pagesBuilder(context),
//       if (state.uri.pathSegments.contains('payment'))
//         BeamPage(
//         key: ValueKey('payment'),
//         child: WppPaymentWebScreen(
//           checkoutTemp: state.data['checkoutdata'],
//         )
//       ),
//       if (state.uri.pathSegments.contains('paymentdetail'))
//         BeamPage(
//         key: ValueKey('paymentdetail'),
//         child: WppPaymentDetailWebScreen(
//           orderData: state.data['orderdata'],
//         )
//       ),
//     ];
//   }
// }

//=================================================================================
//=================================================================================
//=================================================================================
//=================================================================================
//=================================================================================
//=================================================================================
//=================================================================================
//=================================================================================
//=================================================================================
//=================================================================================
//=================================================================================
//=================================================================================
//=================================================================================
//=================================================================================
//=================================================================================
//=================================================================================
//=================================================================================
//=================================================================================
//=================================================================================
//=================================================================================
//=================================================================================
//=================================================================================
//=================================================================================
//=================================================================================
//=================================================================================
//=================================================================================
//=================================================================================
//=================================================================================
//=================================================================================
//=================================================================================
// class AuthenticationLocation extends BeamLocation {
//   AuthenticationLocation() : super();
//   @override
//   List<String> get pathBlueprints => ['/signup', '/signin', '/join/:shopType'];

//   @override
//   List<BeamPage> pagesBuilder(BuildContext context) => [
//         ...HomeLocation().pagesBuilder(context),
//         if (state.uri.pathSegments.contains('signup'))
//           BeamPage(key: ValueKey('signup'), child: SignUpScreen()),
//         if (state.uri.pathSegments.contains('signin'))
//           BeamPage(key: ValueKey('signin'), child: SignInScreen()),
//         if (state.uri.pathSegments.contains('join'))
//           BeamPage(
//             key: ValueKey('join-${state.pathParameters['shopType']}'),
//             child: ShopEntryScreenOld(
//               showRegisterationForm: true,
//               shopType: state.pathParameters['shopType'] == 'reseller'
//                   ? ShopType.reseller
//                   : state.pathParameters['shopType'] == 'catering'
//                       ? ShopType.catering
//                       : state.pathParameters['shopType'] == 'supplier'
//                           ? ShopType.supplier
//                           : state.pathParameters['shopType'] == 'horeca'
//                               ? ShopType.horeca
//                               : null,
//             ),
//           ),
//       ];
// }

class ProductLocation extends BeamLocation {
  ProductLocation() : super();

  @override
  List<String> get pathBlueprints => [
        '/product/:categoryName/:categoryId/:categoryIndex',
        '/product/detail/:isFromShopOrCatering/:productOrSellerName/:productId/:categoryIdParam',
        '/list/reseller'
        // '/${AppConst.WP_URL_PATH_ID}/product/detail/:isFromShopOrCatering/:productOrSellerName/:productId'
      ];

  List<BeamPage> pagesBuilder(BuildContext context) {
    return [
      ...HomeLocation().pagesBuilder(context),
      // s
      // if (state.pathParameters.containsKey('productId'))
      // BeamPage(
      //   key: ValueKey('productId-${state.pathParameters['productId']}'),
      //   child: ProductDetailNewScreen(
      //     productId: int.parse(state.pathParameters['productId']),
      //     categoryId: int.parse(state.pathParameters['categoryIdParam']),
      //     isFromShop: state.pathParameters['isFromShopOrCatering'] == "is"
      //         ? true
      //         : false,
      //     isCatering: state.pathParameters['isFromShopOrCatering'] == "ic"
      //         ? true
      //         : false,
      //     isPrediction: state.data['isPrediction'],
      //     monthId: state.data['monthId'],
      //     sellerName: state.pathParameters['productOrSellerName']
      //         .replaceAll('-', ' '),
      //   ),
      // ),
      // if (state.uri.pathSegments.contains('reseller'))
      //   BeamPage(
      //     key: ValueKey('product-reseller'),
      //     child: SellersScreen(
      //             recipentId: jsonDecode(
      //                 AppExt.decryptMyData(state.queryParameters['recid'])),
      //             isReseller: true,
      //             isCatering:false,
      //             firstTitleRoutePage: "reseller",
      //           ),
      //   ),
    ];
  }
}

// class CartLocation extends BeamLocation {
//   CartLocation() : super();

//   @override
//   List<String> get pathBlueprints => [
//         '/cart',
//       ];

//   List<BeamPage> pagesBuilder(BuildContext context) {
//     return [
//       ...HomeLocation().pagesBuilder(context),
//       if (state.uri.pathSegments.contains('cart'))
//         BeamPage(
//           key: ValueKey('cart'),
//           child: CartScreen(),
//         ),
//     ];
//   }
// }

// class InvoiceLocation extends BeamLocation {
//   InvoiceLocation({this.data}) : super();

//   final OrderDetailUser data;

//   @override
//   List<String> get pathBlueprints => [
//         '/invoice',
//       ];

//   List<BeamPage> pagesBuilder(BuildContext context) {
//     return [
//       ...HomeLocation().pagesBuilder(context),
//       // if (state.uri.pathSegments.contains('invoice'))
//       BeamPage(
//         key: ValueKey('invoice'),
//         child: InvoiceScreen(data: data),
//       ),
//     ];
//   }
// }

class SearchLocation extends BeamLocation {
  SearchLocation() : super();

  @override
  List<String> get pathBlueprints => [
        '/search/:keyword',
      ];

  List<BeamPage> pagesBuilder(BuildContext context) {
    return [
      ...HomeLocation().pagesBuilder(context),
      if (state.pathParameters.containsKey('keyword'))
        BeamPage(
          key: ValueKey('search-${state.pathParameters['keyword']}'),
          child: SearchScreen(
            keyword: state.pathParameters['keyword'],
          ),
        ),
    ];
  }
}

//============================================ TRANSACTION & CHECKOUT ============================================
// class TransactionLocation extends BeamLocation {
//   TransactionLocation() : super();

//   @override
//   List<String> get pathBlueprints => [
//         '/transactionlist',
//         '/checkout/:from/:sellerId',
//         '/paymentweb/:orderId',
//         //===== Mobile Web route =====
//         '/choosepayment/:orderId',
//         '/payment/:orderId',
//         '/orderdetail/:orderId',
//         '/orderdetailResell/:orderId'
//       ];

//   @override
//   List<BeamPage> pagesBuilder(BuildContext context) {
//     List<dynamic> dataCartproduct;
//     Map<String, dynamic> objectCartProduct;
//     List<CartProduct> filteredCart;
//     CartProduct cartProduct;
//     String dataEncryptForNullQueryParam =
//         'OMwvZ0xvDoaKbxocs87+KPqgUOnFWCAsWEoA0SdkBpKpllsM1vfk3vC7Z7SCfVfi8S2RVVN8C8/ssRMsTmyGejomGAAy8RlxsuFR8RqaIGbAvVGpb0WMSnezZzt1lWGCrijIxRsRMy2IU1RuInRnskCWefBa8vQ0iI6LIkIDa29oIQaHX0g9EtmOoIA3CZuxM9jeHka4MgOK4idBwCsfcw==';

//     state.pathParameters['from'] == "cart"
//         ? () {
//             final List<dynamic> data = json.decode(AppExt.decryptMyData(
//                 state.queryParameters['c'] ?? dataEncryptForNullQueryParam));
//             filteredCart = data.map((e) => CartProduct.fromJson(e)).toList();
//             // filteredCart.map((e) => CartProduct.fromJson(e)).toList();
//           }()
//         : state.pathParameters['from'] == "booking"
//             ? () {
//                 dataCartproduct = json
//                     .decode(AppExt.decryptMyData(state.queryParameters['c']));
//                 // debugPrint(dataCartproduct.toString());
//                 objectCartProduct = {
//                   "id": dataCartproduct[0],
//                   "cart_id": null,
//                   "name": dataCartproduct[2],
//                   "product_photo": dataCartproduct[3],
//                   "promo": dataCartproduct[4],
//                   "stock": dataCartproduct[6],
//                   "weight": dataCartproduct[7],
//                   "unit": dataCartproduct[8],
//                   "prediction": dataCartproduct[9],
//                   "quantity": dataCartproduct[10],
//                   "grocirs": dataCartproduct[11],
//                   "coverage": dataCartproduct[12],
//                 };
//                 cartProduct = CartProduct.fromJson(objectCartProduct);
//               }()
//             : cartProduct = CartProduct.fromJson(json.decode(
//                 AppExt.decryptMyData(state.queryParameters['c'] ??
//                     dataEncryptForNullQueryParam)));

//     return [
//       ...HomeLocation().pagesBuilder(context),
//       if (state.uri.pathSegments.contains('transactionlist'))
//         BeamPage(key: ValueKey('transactionlist'), child: TransactionNav()),
//       if (state.uri.pathSegments.contains('checkout'))
//         // BeamPage(
//         //     key: ValueKey('checkout'),
//         //     child: CheckoutScreenOld(
//         //       sellerId: int.parse(state.pathParameters['sellerId']),
//         //       cart: state.pathParameters['from'] == "cart"
//         //           ? filteredCart
//         //           : [
//         //               CartProduct(
//         //                   id: cartProduct.id,
//         //                   cartId: cartProduct.cartId,
//         //                   name: cartProduct.name,
//         //                   productPhoto: cartProduct.productPhoto,
//         //                   enduserPrice: cartProduct.enduserPrice,
//         //                   initialPrice: cartProduct.initialPrice,
//         //                   stock: cartProduct.stock,
//         //                   weight: cartProduct.weight,
//         //                   quantity: cartProduct.quantity,
//         //                   unit: cartProduct.unit,
//         //                   wholesale: cartProduct.wholesale,
//         //                   coverage: cartProduct.coverage)
//         //             ],
//         //       isBuyNow: state.pathParameters['from'] == "detail" ? true : false,
//         //       isPrediction:
//         //           state.pathParameters['from'] == "booking" ? true : false,
//         //     )),
//         if (state.uri.pathSegments.contains('choosepayment'))
//           BeamPage(
//             key: ValueKey('choosepayment'),
//             child: PaymentOldScreen(
//               orderId: int.parse(state.pathParameters['orderId']),
//             ),
//           ),
//       if (state.uri.pathSegments.contains('payment'))
//         BeamPage(
//             key: ValueKey('payment'),
//             child: PaymentDetailOldScreen(
//                 paymentId: int.parse(state.pathParameters['orderId']))),
//       if (state.uri.pathSegments.contains('paymentweb'))
//         BeamPage(
//             key: ValueKey('paymentweb'),
//             child: PaymentDialogWebScreen(
//               orderId: int.parse(state.pathParameters['orderId']),
//             )),
//       if (state.uri.pathSegments.contains('orderdetail'))
//         BeamPage(
//           key: ValueKey('orderdetail'),
//           child: OrderDetailUserScreen(
//               orderId: int.parse(state.pathParameters['orderId'])),
//         ),
//       if (state.uri.pathSegments.contains('orderdetailResell'))
//         BeamPage(
//           key: ValueKey('orderdetailResell'),
//           child: OrderDetailUserScreen(
//             orderId: int.parse(state.pathParameters['orderId']),
//             isOrderReseller: true,
//           ),
//         )
//     ];
//   }
// }

class CheckoutSuccessLocation extends BeamLocation {
  CheckoutSuccessLocation() : super();

  @override
  List<String> get pathBlueprints => ['/successcheckout/:sellerId'];

  List<BeamPage> pagesBuilder(BuildContext context) {
    List<CartProduct> filteredCart;
    String dataEncryptForNullQueryParam =
        'OMwvZ0xvDoaKbxocs87+KPqgUOnFWCAsWEoA0SdkBpKpllsM1vfk3vC7Z7SCfVfi8S2RVVN8C8/ssRMsTmyGejomGAAy8RlxsuFR8RqaIGbAvVGpb0WMSnezZzt1lWGCrijIxRsRMy2IU1RuInRnskCWefBa8vQ0iI6LIkIDa29oIQaHX0g9EtmOoIA3CZuxM9jeHka4MgOK4idBwCsfcw==';

    final List<dynamic> data = json.decode(AppExt.decryptMyData(
        state.queryParameters['c'] ?? dataEncryptForNullQueryParam));
    filteredCart = data.map((e) => CartProduct.fromJson(e)).toList();

    return [
      ...HomeLocation().pagesBuilder(context),
      if (state.pathParameters.containsKey('sellerId'))
        BeamPage(
            key: ValueKey('sellerId'),
            child: CheckoutSuccessDialogWebScreen(
              cart: filteredCart,
              sellerId: int.parse(state.pathParameters['sellerId']),
            )),
    ];
  }
}

// class VoucherLocation extends BeamLocation {
//   VoucherLocation() : super();

//   @override
//   List<String> get pathBlueprints => [
//         '/voucher',
//       ];

//   List<BeamPage> pagesBuilder(BuildContext context) {
//     return [
//       ...HomeLocation().pagesBuilder(context),
//       if (state.uri.pathSegments.contains('voucher'))
//         BeamPage(
//           key: ValueKey('voucher'),
//           child: VouchersScreen(),
//         ),
//     ];
//   }
// }

// class RecipeLocation extends BeamLocation {
//   RecipeLocation() : super();

//   @override
//   List<String> get pathBlueprints => [
//         '/recipe/:recipeId',
//       ];

//   List<BeamPage> pagesBuilder(BuildContext context) {
//     return [
//       ...HomeLocation().pagesBuilder(context),
//       if (state.pathParameters.containsKey('recipeId'))
//         BeamPage(
//           key: ValueKey('recipe-${state.pathParameters['recipeId']}'),
//           child: RecipeDetailScreen(
//             recipeId: int.parse(state.pathParameters['recipeId']),
//           ),
//         ),
//     ];
//   }
// }

// class AccountLocation extends BeamLocation {
//   AccountLocation() : super();

//   @override
//   List<String> get pathBlueprints => [
//         '/account/profile',
//         '/account/shop/dashboard',
//         '/account/shop/productlist',
//         '/account/shop/config',
//         '/account/shop/transaction',
//         '/account/shop/addproduct',
//         '/account/shop/editproduct'
//       ];

//   List<BeamPage> pagesBuilder(BuildContext context) {
//     List<dynamic> dataProductV2;
//     Map<String, dynamic> objectProductV2;

//     state.queryParameters['c'] != null
//         ? () {
//             dataProductV2 =
//                 json.decode(AppExt.decryptMyData(state.queryParameters['c']));
//             objectProductV2 = {
//               "id": dataProductV2[0],
//               "category_id": dataProductV2[1],
//               "category_name": dataProductV2[2],
//               "subcategory_name": dataProductV2[3],
//               "subcategory_id": dataProductV2[4],
//               "seller_id": dataProductV2[5],
//               "product_photo": dataProductV2[6],
//               "name": dataProductV2[7],
//               "description": dataProductV2[8],
//               "price": dataProductV2[9],
//               "disc": dataProductV2[10],
//               "promo": dataProductV2[11],
//               "sold": dataProductV2[12],
//               "stock": dataProductV2[13],
//               "weight": dataProductV2[14],
//               "isprediction": dataProductV2[15],
//               "unit": dataProductV2[16],
//               "badge": dataProductV2[17],
//               "prediction_data": dataProductV2[18],
//               "grocir": dataProductV2[19],
//               "coverage": dataProductV2[20]
//             };
//           }()
//         : null;

//     return [
//       ...HomeLocation().pagesBuilder(context),
//       if (state.uri.pathSegments.contains('profile'))
//         BeamPage(
//             key: ValueKey('profile'),
//             child: UpdateAccountScreen(
//                 user: BlocProvider.of<UserDataCubit>(context).state.user)),
//       // if (state.uri.pathSegments.contains('edit'))
//       //   BeamPage(
//       //     key: ValueKey('profileEdit'),
//       //     child: UpdateAccountScreen(
//       //       user: BlocProvider.of<UserDataCubit>(context).state.user
//       //     )
//       //   ),
//       if (state.uri.pathSegments.contains('dashboard'))
//         BeamPage(
//             key: ValueKey('producerDashboard'),
//             child: ProducerDashboardScreen()),
//       // if (state.uri.pathSegments.contains('productlist'))
//       //   BeamPage(key: ValueKey('shopProductlist'), child: ProductsScreen()),
//       if (state.uri.pathSegments.contains('config'))
//         BeamPage(
//           key: ValueKey('shopConfig'),
//           child: ShopEntryScreenOld(
//             shopType: BlocProvider.of<UserDataCubit>(context)
//                         .state
//                         .user
//                         ?.roleId ==
//                     '3'
//                 ? ShopType.horeca
//                 : BlocProvider.of<UserDataCubit>(context).state.user?.roleId ==
//                         '4'
//                     ? ShopType.supplier
//                     : BlocProvider.of<UserDataCubit>(context)
//                                 .state
//                                 .user
//                                 ?.roleId ==
//                             '6'
//                         ? ShopType.reseller
//                         : BlocProvider.of<UserDataCubit>(context)
//                                     .state
//                                     .user
//                                     ?.roleId ==
//                                 '5'
//                             ? ShopType.catering
//                             : null,
//           ),
//         ),
//       // if (state.uri.pathSegments.contains('addproduct'))
//       //   BeamPage(key: ValueKey('shopProductAdd'), child: ProductEntryScreen()),
//       // if (state.uri.pathSegments.contains('editproduct'))
//       //   BeamPage(
//       //       key: ValueKey('shopProductEdit'),
//       //       child: ProductEntryScreen(
//       //         product: ProductV2.fromJson(objectProductV2),
//       //       )),
//       if (state.uri.pathSegments.contains('transaction'))
//         BeamPage(
//             key: ValueKey('shopTransaction'),
//             child: TransactionHistoryScreen(
//               initialIndex: state.data['initialIndex'] ?? 0,
//             )),
//     ];
//   }
// }

// class WpHomeLocation extends BeamLocation {
//   WpHomeLocation() : super();

//   @override
//   List<String> get pathBlueprints => [
//         '/${AppConst.WP_URL_PATH_ID}/:phone/product/:categoryName/:categoryId',
//         '/${AppConst.WP_URL_PATH_ID}/:phone/detail/:productId',
//         '/${AppConst.WP_URL_PATH_ID}/:phone/promo',
//         '/${AppConst.WP_URL_PATH_ID}/:phone/best-seller',
//         '/${AppConst.WP_URL_PATH_ID}/:phone/search',
//       ];

//   List<BeamPage> pagesBuilder(BuildContext context) {
//     return [
//       ...HomeLocation().pagesBuilder(context),
//       if (state.pathParameters.containsKey('phone'))
//         BeamPage(
//           key: ValueKey('wpHome-${state.pathParameters['phone']}'),
//           child: WpHomeScreen(
//             phone: int.tryParse(state.pathParameters['phone']),
//           ),
//         ),
//       if (state.uri.pathSegments.contains('product'))
//         BeamPage(
//           key: ValueKey(
//               'productCategory-${state.pathParameters['categoryName']}'),
//           child: ProductsByCategoryScreenOld(
//             categoryId: int.parse(state.pathParameters['categoryId']),
//             firstTitleRoutePage:
//                 toBeginningOfSentenceCase(state.pathParameters['categoryName']),
//             recipentId: BlocProvider.of<ShippingAddressCubit>(context)
//                         .state
//                         .selectedRecipent !=
//                     null
//                 ? BlocProvider.of<ShippingAddressCubit>(context)
//                     .state
//                     .selectedRecipent
//                     .id
//                 : null,
//             warungPhoneNumber: int.parse(state.pathParameters['phone']),
//             isWarung: true,
//           ),
//         ),
//       if (state.uri.pathSegments.contains('detail'))
//         // BeamPage(
//         //   key: ValueKey('productId-${state.pathParameters['productId']}'),
//         //   child: ProductDetailNewScreen(
//         //     productId: int.parse(state.pathParameters['productId']),
//         //     warungPhoneNumber: int.parse(state.pathParameters['phone']),
//         //     isWarung: true,
//         //   ),
//         // ),
//         if (state.uri.pathSegments.contains('promo'))
//           BeamPage(
//             key: ValueKey('productpromo'),
//             child: ViewAllProductScreen(
//               phoneNumber: int.parse(state.pathParameters['phone']),
//               productsType: FetchProductsType.promo,
//             ),
//           ),
//       if (state.uri.pathSegments.contains('best-seller'))
//         BeamPage(
//           key: ValueKey('productbestseller'),
//           child: ViewAllProductScreen(
//             phoneNumber: int.parse(state.pathParameters['phone']),
//             productsType: FetchProductsType.bestSell,
//           ),
//         ),
//       if (state.uri.pathSegments.contains('search'))
//         BeamPage(
//           key: ValueKey('search-cust'),
//           child: SearchScreen(
//             warungPhoneNumber: int.parse(state.pathParameters['phone']),
//           ),
//         ),
//       // if (state.uri.pathSegments.contains('my-warung'))
//       //   BeamPage(key: ValueKey('my-warung'), child: WpCustomerScreen()),
//       // if (state.uri.pathSegments.contains('edit-warung'))
//       //   BeamPage(
//       //       key: ValueKey('edit-warung'),
//       //       child: WpEntryScreen(
//       //           producer:
//       //               BlocProvider.of<UserDataCubit>(context).state.seller ??
//       //                   null)),
//     ];
//   }
// }

// class WpHostLocation extends BeamLocation {
//   WpHostLocation() : super();

//   @override
//   List<String> get pathBlueprints => [
//         '/my-warung',
//         '/edit-warung',
//       ];

//   List<BeamPage> pagesBuilder(BuildContext context) {
//     return [
//       ...HomeLocation().pagesBuilder(context),
//       if (state.uri.pathSegments.contains('my-warung'))
//         BeamPage(key: ValueKey('my-warung'), child: WpCustomerScreen()),
//       // if (state.uri.pathSegments.contains('edit'))
//       //   BeamPage(key: ValueKey('my-warung'), child: WpCustomerScreen()),
//       if (state.uri.pathSegments.contains('edit-warung'))
//         BeamPage(
//           key: ValueKey('edit-warung'),
//           child: ShopEntryScreenOld(
//             shopType: ShopType.reseller,
//           ),
//         ),
//     ];
//   }
// }

// class WpCartLocation extends BeamLocation {
//   WpCartLocation() : super();

//   @override
//   List<String> get pathBlueprints => [
//         '/${AppConst.WP_URL_PATH_ID}/:phone/cart',
//         '/${AppConst.WP_URL_PATH_ID}/:phone/checkout',
//       ];

//   List<BeamPage> pagesBuilder(BuildContext context) {
//     // List<WpCartItem> cart;

//     // state.uri.pathSegments.contains('checkout') ? (){
//     //   debugPrint("HALOOO" + json.decode(AppExt.decryptMyData(state.queryParameters['dc'])).toString());
//     //   // cart = json.decode(AppExt.decryptMyData(state.queryParameters['dc']));
//     // }()
//     // :null;

//     return [
//       ...HomeLocation().pagesBuilder(context),
//       if (state.uri.pathSegments.contains('cart'))
//         BeamPage(
//           key: ValueKey('wpCart-${state.pathParameters['phone']}'),
//           child: WpCartScreen(
//             phone: int.tryParse(state.pathParameters['phone']),
//           ),
//         ),
//       if (state.uri.pathSegments.contains('checkout'))
//         BeamPage(
//           key: ValueKey('wpCheckout-${state.pathParameters['phone']}'),
//           child: WpCheckoutScreen(
//             phone: state.pathParameters['phone'],
//             // cart: [],
//           ),
//         ),
//     ];
//   }
// }

// class WpShippingLocation extends BeamLocation {
//   WpShippingLocation() : super();

//   @override
//   List<String> get pathBlueprints => [
//         // '/${AppConst.WP_URL_PATH_ID}/:warungPhone/input-shipping-courier-expedition',//Ekspedisi
//         // '/${AppConst.WP_URL_PATH_ID}/:warungPhone/input-shipping-drop-point',//Drop point
//         '/${AppConst.WP_URL_PATH_ID}/:warungPhone/:userPhone/detail-order',
//         '/${AppConst.WP_URL_PATH_ID}/:warungPhone/:userPhone/register-shipping',
//       ];

//   List<BeamPage> pagesBuilder(BuildContext context) {
//     return [
//       ...HomeLocation().pagesBuilder(context),
//       if (state.uri.pathSegments.contains('detail-order'))
//         BeamPage(
//             key: ValueKey(
//                 'wpRegisterShipping-${state.pathParameters['warungPhone']}-${state.pathParameters['userPhone']}'),
//             child: WpDetailOrderScreen(
//               checkoutData: boxData.read("checkoutData"),
//             )),
//       if (state.uri.pathSegments.contains('register-shipping'))
//         BeamPage(
//           key: ValueKey(
//               'wpRegisterShipping-${state.pathParameters['warungPhone']}-${state.pathParameters['userPhone']}'),
//           child: WpRegisterShippingScreen(
//             warungPhone: state.pathParameters['warungPhone'],
//             userPhone: state.pathParameters['userPhone'],
//           ),
//         ),
//     ];
//   }
// }
