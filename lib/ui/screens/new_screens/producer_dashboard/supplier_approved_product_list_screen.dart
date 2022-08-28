import 'dart:async';

import 'package:animations/animations.dart';
import 'package:beamer/beamer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:marketplace/api/api.dart';
import 'package:marketplace/data/blocs/new_cubit/add_product_supplier/add_product_supplier_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/supplier/edit_profile_supplier/edit_profile_supplier_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/supplier/edit_stock_product_supplier/edit_stock_product_supplier_cubit.dart';
import 'package:marketplace/data/blocs/new_cubit/supplier/get_product_supplier/get_product_supplier_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/ui/screens/new_screens/join_user/join_user_add_product_screen.dart';
import 'package:marketplace/ui/screens/new_screens/producer_dashboard/supplier_except_approved_product_list_screen.dart';
import 'package:marketplace/ui/screens/new_screens/producer_dashboard/widgets/bs_change_stock.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/constants.dart' as AppConst;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/images.dart' as AppImg;
import 'package:marketplace/utils/transitions.dart' as AppTrans;
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:shimmer/shimmer.dart';

class SupplierApprovedProductListScreen extends StatefulWidget {
  @override
  _SupplierApprovedProductListScreenState createState() =>
      _SupplierApprovedProductListScreenState();
}

class _SupplierApprovedProductListScreenState
    extends State<SupplierApprovedProductListScreen> {
  GetProductSupplierCubit _getProductSupplierCubit;
  EditStockProductSupplierCubit _editStockProductSupplierCubit;

  ScrollController _scrollController;
  Timer _debounce;
  TextEditingController _stockController;
  TextEditingController _searchController;
  String _searchHintText;
  Completer<void> _refreshCompleter;
  FocusNode _focusNode;

  @override
  void initState() {
    _getProductSupplierCubit = GetProductSupplierCubit()
      ..fetchProductApproved();
    _editStockProductSupplierCubit = EditStockProductSupplierCubit();
    _focusNode = FocusNode();
    _scrollController = ScrollController();
    _stockController = TextEditingController(text: "");
    _searchController = TextEditingController(text: "");
    _refreshCompleter = Completer<void>();
    // _products = [];
    // _newProducts = [];
    super.initState();
  }

  String toRupiah(int number) {
    final currencyFormatter = NumberFormat('#,##0', 'ID');
    return currencyFormatter.format(number);
  }

  _onSearchChanged(String keyword) {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () {
      AppExt.hideKeyboard(context);
      if (keyword.isNotEmpty) {
        _getProductSupplierCubit.fetchProductApproved(keyword: keyword);
      }
    });
  }

  Future<void> _refresh() {
    return _getProductSupplierCubit.fetchProductApproved();
  }

  @override
  void dispose() {
    // _productsBloc.close();
    _scrollController.dispose();
    _stockController.dispose();
    _searchController.dispose();
    _editStockProductSupplierCubit.close();
    _getProductSupplierCubit.close();
    if (_debounce?.isActive ?? false) _debounce.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;
    final double _screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        AppExt.popScreen(context, true);
        return true;
        // if (_searchController.text.trim().isNotEmpty) {
        //   setState(() {
        //     onItemChanged('');
        //     _searchController = TextEditingController(text: '');
        //   });
        //   return false;
        // } else {
        //   if (kIsWeb) {
        //     context.beamToNamed('/account/shop/dashboard');
        //     return false;
        //   } else {
        //     return true;
        //   }
        // }
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => _getProductSupplierCubit,
          ),
          BlocProvider(
            create: (context) => _editStockProductSupplierCubit,
          ),
        ],
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
          child: GestureDetector(
            onTap: () => AppExt.hideKeyboard(context),
            child: Scaffold(
                extendBody: true,
                backgroundColor: Colors.white,
                body: MultiBlocListener(
                  listeners: [
                    BlocListener<GetProductSupplierCubit,
                        GetProductSupplierState>(
                      listener: (context, state) {
                        if (state is GetProductSupplierDeleteSuccess) {
                          _getProductSupplierCubit.fetchProductApproved();
                          BSFeedback.show(context,
                              title: "Berhasil dihapus!", description: "");
                        }
                      },
                    ),
                    BlocListener<EditStockProductSupplierCubit,
                        EditStockProductSupplierState>(
                      listener: (context, state) {
                        if (state is EditStockProductSupplierSuccess) {
                          AppExt.popScreen(context);
                          BSFeedback.show(context,
                              title: "Berhasil edit stock", description: "");
                          _getProductSupplierCubit.fetchProductApproved();
                        }
                        if (state is EditStockProductSupplierFailure) {
                          BSFeedback.show(context,
                              title: "Gagal edit stock", description: "");
                        }
                      },
                    ),
                  ],
                  child: SafeArea(
                    child: RefreshIndicator(
                      displacement: 10,
                      color: AppColor.primary,
                      backgroundColor: Colors.white,
                      strokeWidth: 3,
                      onRefresh: () {
                        return _refresh();
                      },
                      child: NestedScrollView(
                        floatHeaderSlivers: true,
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) => [
                          SliverAppBar(
                              iconTheme: IconThemeData(color: AppColor.black),
                              textTheme:
                                  TextTheme(headline6: AppTypo.subtitle2),
                              backgroundColor: Colors.white,
                              snap: true,
                              centerTitle: true,
                              // forceElevated: true,
                              pinned: true,
                              shadowColor: Colors.black54,
                              floating: true,
                              title: Text("Daftar Produk"),
                              brightness: Brightness.dark,
                              bottom: PreferredSize(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                _screenWidth * (4 / 100)),
                                        child: Center(
                                          child: EditText(
                                            controller: _searchController,
                                            hintText: "Cari produk ...",
                                            inputType: InputType.search,
                                            focusNode: _focusNode,
                                            onChanged: this._onSearchChanged,
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: () => AppExt.pushScreen(
                                              context,
                                              JoinUserAddProductScreen()),
                                          child: Text(
                                            "Tambah Produk",
                                            style: AppTypo.overline.copyWith(
                                                color: AppColor.primary,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal:
                                                _screenWidth * (4 / 100)),
                                        child: Container(
                                          // padding: EdgeInsets.symmetric(
                                          //     horizontal:
                                          //         _screenWidth * (2/ 100)),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                  color: AppColor
                                                      .silverFlashSale)),
                                          child: ListTile(
                                              onTap: () {
                                                AppExt.pushScreen(context,
                                                    SupplierExceptApprovedProductListScreen());
                                              },
                                              title: Text(
                                                "Menunggu verifikasi & Ditolak",
                                                style: AppTypo.caption,
                                              ),
                                              trailing: Icon(
                                                Icons
                                                    .arrow_forward_ios_outlined,
                                                size: 18,
                                              )
                                              //  Row(
                                              //   mainAxisSize: MainAxisSize.min,
                                              //   mainAxisAlignment:
                                              //       MainAxisAlignment.end,
                                              //   children: [
                                              //     Container(
                                              //       padding: EdgeInsets.all(5),
                                              //       decoration: BoxDecoration(
                                              //           color:
                                              //               Color(0xFFE7366B),
                                              //           borderRadius:
                                              //               BorderRadius
                                              //                   .circular(5)),
                                              //       child: Text(
                                              //         "3",
                                              //         style: AppTypo.caption
                                              //             .copyWith(
                                              //                 color:
                                              //                     Colors.white,
                                              //                 fontSize: 10),
                                              //       ),
                                              //     ),
                                              //     Icon(
                                              //       Icons
                                              //           .arrow_forward_ios_outlined,
                                              //       size: 18,
                                              //     )
                                              //   ],
                                              // ),
                                              ),
                                        ),
                                      )
                                    ],
                                  ),
                                  preferredSize: Size.fromHeight(200))),
                        ],
                        body: BlocBuilder<GetProductSupplierCubit,
                            GetProductSupplierState>(
                          builder: (context, state) =>
                              AppTrans.SharedAxisTransitionSwitcher(
                            transitionType: SharedAxisTransitionType.vertical,
                            fillColor: Colors.transparent,
                            child: state is GetProductSupplierSuccess
                                ? Align(
                                    alignment: Alignment.topCenter,
                                    child: state.products.length > 0
                                        ? CustomScrollView(
                                            slivers: [
                                              SliverToBoxAdapter(
                                                child: SizedBox(
                                                  height: 10,
                                                ),
                                              ),
                                              SliverList(
                                                delegate:
                                                    SliverChildBuilderDelegate(
                                                  (context, index) {
                                                    final _item =
                                                        state.products[index];
                                                    return GestureDetector(
                                                      behavior: HitTestBehavior
                                                          .opaque,
                                                      onTap: () {
                                                        /*AppExt.pushScreen(
                                                        context,
                                                        ProductDetailScreen(
                                                            product: _item),
                                                      )*/
                                                      },
                                                      child: _buildProductItem(
                                                          context, _item),
                                                    );
                                                  },
                                                  childCount:
                                                      state.products.length,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Column(
                                            children: [
                                              SizedBox(height: 200),
                                              EmptyData(
                                                title: "Produk kosong",
                                                subtitle:
                                                    "Produk akan tampil setelah disetujui oleh admin",
                                              ),
                                            ],
                                          ),
                                  )
                                : state is GetProductSupplierLoading
                                    ? Container(
                                        padding: EdgeInsets.only(
                                            bottom: kToolbarHeight),
                                        child: CircularProgressIndicator(
                                            valueColor:
                                                new AlwaysStoppedAnimation<
                                                    Color>(AppColor.primary)),
                                      )
                                    : state is GetProductSupplierFailure
                                        ? Center(
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  bottom: kToolbarHeight),
                                              child: state.type ==
                                                      ErrorType.network
                                                  ? Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Image.asset(
                                                          AppImg
                                                              .img_no_connection,
                                                          width: _screenWidth *
                                                              (60 / 100),
                                                          height:
                                                              _screenHeight *
                                                                  (30 / 100),
                                                          fit: BoxFit.contain,
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        SizedBox(
                                                          width: _screenWidth *
                                                              (75 / 100),
                                                          child: Text(
                                                            "Tidak ada koneksi internet",
                                                            style: AppTypo.h3
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        SizedBox(
                                                          width: _screenWidth *
                                                              (75 / 100),
                                                          child: Text(
                                                            "Cek paket data/koneksi wifi kamu lalu coba lagi..",
                                                            style: AppTypo
                                                                .overlineAccent,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        SizedBox(
                                                          width: _screenWidth *
                                                              (60 / 100),
                                                          child: RoundedButton
                                                              .contained(
                                                                  isCompact:
                                                                      true,
                                                                  label:
                                                                      "Coba Lagi",
                                                                  onPressed:
                                                                      () {
                                                                    context
                                                                        .read<
                                                                            GetProductSupplierCubit>()
                                                                        .fetchProductApproved();
                                                                  }),
                                                        ),
                                                      ],
                                                    )
                                                  : Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        // Icon(
                                                        Icon(
                                                          FlutterIcons
                                                              .error_outline_mdi,
                                                          size: 45,
                                                          color: AppColor
                                                              .primaryDark,
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        SizedBox(
                                                          width: 250,
                                                          child: Text(
                                                            state.message,
                                                            style: AppTypo
                                                                .overlineAccent,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 7,
                                                        ),
                                                        OutlineButton(
                                                          child:
                                                              Text("Coba lagi"),
                                                          onPressed: () {
                                                            context
                                                                .read<
                                                                    GetProductSupplierCubit>()
                                                                .fetchProductApproved();
                                                          },
                                                          textColor: AppColor
                                                              .primaryDark,
                                                          color:
                                                              AppColor.danger,
                                                        ),
                                                      ],
                                                    ),
                                            ),
                                          )
                                        : SizedBox.shrink(),
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      {@required String productName, @required void Function() onDelete}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)), //this right here
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: AppTypo.body2,
                        children: [
                          TextSpan(
                            text: 'Apakah kamu yakin menghapus produk ',
                          ),
                          TextSpan(
                            text: '$productName?',
                            style: AppTypo.body2
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RoundedButton.outlined(
                            isUpperCase: false,
                            isCompact: true,
                            label: "Ya",
                            onPressed: () {
                              Navigator.pop(context);
                              onDelete();
                            },
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: RoundedButton.contained(
                            isUpperCase: false,
                            isCompact: true,
                            label: "Tidak",
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _buildProductItem(
      BuildContext context, SupplierDataResponseItem _item) {
    final double _screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          _screenWidth * (5 / 100), 10, _screenWidth * (5 / 100), 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container(
          //   margin: const EdgeInsets.only(bottom: 5),
          //   padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          //   decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(2),
          //       color: AppColor.bgBadgeGold.withOpacity(0.75)),
          //   child: Text(
          //     _item.productStatus,
          //     style: AppTypo.overline.copyWith(
          //       fontWeight: FontWeight.w700,
          //       color: _item.productStatus == "Diterima"
          //           ? AppColor.bgTextGreen
          //           : Color(0xFFCE6C24),
          //     ),
          //   ),
          // ),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _ImageWidget(
                  product: _item,
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      _item.productName,
                      style: AppTypo.subtitle2
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'Rp ${this.toRupiah(_item.productSellingPrice)}',
                      style: AppTypo.caption.copyWith(
                          fontWeight: FontWeight.w700, color: AppColor.primary),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Stok : ${_item.productStock}",
                      style: AppTypo.caption,
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Wrap(
            children: [
              SizedBox(
                width: 90,
                child: OutlineButton(
                  borderSide: BorderSide(
                    color: AppColor.danger,
                  ),
                  highlightColor: AppColor.danger.withOpacity(0.3),
                  splashColor: AppColor.danger.withOpacity(0.3),
                  highlightedBorderColor: AppColor.danger,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  onPressed: () => _showDeleteConfirmationDialog(
                    productName: _item.productName,
                    onDelete: () {
                      context
                          .read<GetProductSupplierCubit>()
                          .deleteProductApproved(_item.id);
                    },
                  ),
                  child: Text(
                    "Hapus",
                    style: AppTypo.caption.copyWith(color: AppColor.danger),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Visibility(
                visible: true,
                child: SizedBox(
                  width: 120,
                  child: OutlineButton(
                    borderSide: BorderSide(
                      color: AppColor.textPrimary,
                    ),
                    textColor: AppColor.primary,
                    disabledTextColor: AppColor.textSecondary,
                    padding: EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    // onPressed: null,
                    onPressed: () {
                      //   if (_item.productStatus != "Ditolak") {
                      //     context.read<AddProductSupplierCubit>().addItem(_item);
                      context.read<AddProductSupplierCubit>().addItem(_item);
                      AppExt.pushScreen(
                          context,
                          JoinUserAddProductScreen(
                            item: _item,
                          ));
                      //   }
                    },
                    child: Text(
                      "Ubah Produk",
                      style:
                          AppTypo.caption.copyWith(color: AppColor.textPrimary),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 110,
                child: OutlineButton(
                  borderSide: BorderSide(
                    color: AppColor.textPrimary,
                  ),
                  padding: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  // onPressed: null,
                  onPressed: () {
                    BsChangeStock().showChangeStockSheet(context,
                        onSubmit: (value) {
                      _editStockProductSupplierCubit.editStock(
                          id: _item.id, stock: value);
                    }, stock: _item.productStock);
                    /*_stockController.text = _item.stock.toString();
                          _showChangeStockSheet(
                            context,
                            onSubmit: (id) {
                              Navigator.pop(context);
                              _productsBloc.add(
                                ChangeStockButtonPressed(
                                  productId: id,
                                  stock: int.parse(_stockController.text),
                                ),
                              );
                            },
                            product: _item,
                          );*/
                  },
                  child: Text(
                    "Ubah Stok",
                    style: AppTypo.caption,
                  ),
                ),
              )
            ],
          ),
          Divider(
            color: AppColor.line,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}

class _ImageWidget extends StatelessWidget {
  const _ImageWidget({Key key, this.product}) : super(key: key);

  final SupplierDataResponseItem product;

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? Image.network(
            product.coverPhoto,
            // "",
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded) {
                return child;
              } else {
                return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: frame != null
                        ? child
                        : Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.grey[200],
                            ),
                          ));
              }
            },
            errorBuilder: (context, url, error) => Image.asset(
              AppImg.img_error,
              width: 60,
              height: 60,
            ),
          )
        : CachedNetworkImage(
            imageUrl: product.coverPhoto,
            memCacheHeight:
                Get.height > 350 ? (Get.height * 0.25).toInt() : Get.height,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[200],
              period: Duration(milliseconds: 1000),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
              ),
            ),
            errorWidget: (context, url, error) => Image.asset(
              AppImg.img_error,
              width: 60,
              height: 60,
            ),
          );
  }
}
