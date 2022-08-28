import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get/get.dart';
import 'package:marketplace/data/blocs/new_cubit/bagikan_produk/bagikan_produk_cubit.dart';
import 'package:marketplace/data/blocs/user_data/user_data_cubit.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/data/repositories/repositories.dart';
import 'package:marketplace/ui/screens/new_screens/cart_screen/cart_screen.dart';
import 'package:marketplace/ui/screens/sign_in_screen.dart';
import 'package:marketplace/ui/widgets/image_blur.dart';
import 'package:marketplace/ui/widgets/widgets.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:open_file/open_file.dart';

import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';

import 'wpp_product_detail_bs_bagikan_produk.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;

class WppProductDetailAppbar extends StatelessWidget {
  const WppProductDetailAppbar(
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

  void _handleCopy(BuildContext context, String text, String message) {
    Clipboard.setData(new ClipboardData(text: text));
    ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      margin: EdgeInsets.zero,
                      duration: Duration(seconds: 2),
                      content: Text('$message'),
                      backgroundColor: Colors.grey[900],
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
  }

  void _launchUrl(BuildContext context,String _url) async {
    if (await canLaunch(_url)) {
      await launch(_url);
    } else {
      BSFeedback.show(
        context,
        icon: Boxicons.bx_x_circle,
        color: AppColor.red,
        title: "Gagal mengakses halaman",
        description: "Halaman atau koneksi internet bermasalah",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final JoinUserRepository _recRepo = JoinUserRepository();

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
                   context.beamToNamed('/wpp/dashboard/${_recRepo.getSlugReseller()}');
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: ImageBlur(
                  color: iconBackundColor,
                  child: Icon(
                    Icons.arrow_back,
                    color: iconColor,
                  )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    _launchUrl(context, product.coverPhoto);
                  },
                  child: ImageBlur(
                    color: iconBackundColor,
                    child: Icon(
                      Icons.download_outlined,
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
                      if (!context.isPhone) {
                        _handleCopy(context, "https://warung.panenpanen.id/wpp/productdetail/${product.reseller.slug}/${product.slug}/${product.id}", "Link produk tersalin");
                      }else{
                        context.read<BagikanProdukCubit>().reset();
                      WppProductDetailBsBagikanProduk().showBsReview(context,product,null,false);
                      }
                      
                    }else{
                      BSFeedback.show(context,color: AppColor.danger,title: "Gagal bagikan produk",description: "Stok barang habis",icon: Icons.cancel_outlined);
                    }

                  },
                  child: ImageBlur(
                    color: iconBackundColor,
                    child: Icon(
                      Icons.share_outlined,
                      color: iconColor,
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  onTap: () {
                    context.beamToNamed('/wpp/cart');
                  },
                  child: Stack(
                    children: [
                      ImageBlur(
                        color: iconBackundColor,
                        child: Icon(
                          Icons.shopping_cart,
                          color: iconColor,
                        ),
                      ),
                      // BlocProvider.of<UserDataCubit>(context).state.countCart != null &&
                      //     BlocProvider.of<UserDataCubit>(context).state.countCart > 0
                      //     ? new Positioned(
                      //   right: 6,
                      //   top: -10,
                      //   child: Chip(
                      //     shape: CircleBorder(side: BorderSide.none),
                      //     backgroundColor: Colors.red,
                      //     padding: EdgeInsets.zero,
                      //     labelPadding: BlocProvider.of<UserDataCubit>(context)
                      //         .state
                      //         .countCart >
                      //         99
                      //         ? EdgeInsets.all(2)
                      //         : EdgeInsets.all(4),
                      //     label: Text(
                      //       "${BlocProvider.of<UserDataCubit>(context).state.countCart}",
                      //       style: AppTypo.overlineInv.copyWith(fontSize: 8),
                      //       textAlign: TextAlign.center,
                      //     ),
                      //   ),
                      // )
                      //     : SizedBox.shrink(),
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