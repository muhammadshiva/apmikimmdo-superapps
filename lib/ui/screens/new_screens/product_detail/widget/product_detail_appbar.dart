import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beamer/beamer.dart';
import 'package:marketplace/data/blocs/new_cubit/bagikan_produk/bagikan_produk_cubit.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/ui/screens/new_screens/cart_screen/cart_screen.dart';
import 'package:marketplace/ui/screens/sign_in_screen.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:open_file/open_file.dart';

import 'package:path/path.dart' as p;

import '../../../../widgets/image_blur.dart';
import 'bs_bagikan_produk.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;

class ProductDetailAppbar extends StatelessWidget {
  const ProductDetailAppbar(
      {Key key,
        @required this.backgroundColor,
        @required this.shadowColor,
        @required this.iconBackundColor,
        @required this.iconColor, this.isPublicResellerShop = false, this.product})
      : super(key: key);

  final Color backgroundColor;
  final Color iconColor;
  final Color iconBackundColor;
  final Color shadowColor;
  final bool isPublicResellerShop;
  final Products product;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      color: backgroundColor,
      shadowColor: shadowColor,
      child: Container(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                if (kIsWeb) {
                  context.beamBack();
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: ImageBlur(
                  color: iconBackundColor,
                  child: Icon(
                    EvaIcons.arrowBack,
                    color: iconColor,
                  )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {
                    try {
                      final path = await AppExt.downloadImage(image: product.productPhoto[0].image);
                      if (path != null) {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Text('$path berhasil disimpan'),
                              action: SnackBarAction(
                                label: "Buka",
                                onPressed: () async {
                                  await OpenFile.open(p.fromUri(path));
                                },
                              ),
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(seconds: 5),
                              margin: EdgeInsets.all(15),
                            ),
                          );
                      }else{
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Text('Gagal menyimpan gambar, Aplikasi memerlukan izin'),
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(seconds: 5),
                              margin: EdgeInsets.all(15),
                            ),
                          );
                      }

                    } on Exception catch (e){
                      debugPrint(e.toString());
                    }
                  },
                  child: ImageBlur(
                    color: iconBackundColor,
                    child: Icon(
                      EvaIcons.downloadOutline,
                      color: iconColor,
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  onTap: () {
                    if (product.stock > 0) {
                      context.read<BagikanProdukCubit>().reset();
                      BsBagikanProduk().showBsReview(context,product,null,false);
                    }else{
                      BSFeedback.show(context,color: AppColor.danger,title: "Gagal bagikan produk",description: "Stok barang habis",icon: Icons.cancel_outlined);
                    }

                  },
                  child: ImageBlur(
                    color: iconBackundColor,
                    child: Icon(
                      EvaIcons.shareOutline,
                      color: iconColor,
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  onTap: () {
                    isPublicResellerShop ?
                    context.beamToNamed('/cart')
                        :
                    BlocProvider.of<UserDataCubit>(context).state.user == null
                        ? AppExt.pushScreen(context, SignInScreen())
                        : kIsWeb
                        ? context.beamToNamed('/cart')
                        : AppExt.pushScreen(context, CartScreen()) ;
                  },
                  child: Stack(
                    children: [
                      ImageBlur(
                        color: iconBackundColor,
                        child: Icon(
                          EvaIcons.shoppingCart,
                          color: iconColor,
                        ),
                      ),
                      BlocProvider.of<UserDataCubit>(context).state.countCart != null &&
                          BlocProvider.of<UserDataCubit>(context).state.countCart > 0
                          ? new Positioned(
                        right: 6,
                        top: -12,
                        child: Chip(
                          shape: CircleBorder(side: BorderSide.none),
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.zero,
                          labelPadding: BlocProvider.of<UserDataCubit>(context)
                              .state
                              .countCart >
                              99
                              ? EdgeInsets.all(2)
                              : EdgeInsets.all(4),
                          label: Text(
                            "${BlocProvider.of<UserDataCubit>(context).state.countCart}",
                            style: AppTypo.overlineInv.copyWith(fontSize: 8),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}