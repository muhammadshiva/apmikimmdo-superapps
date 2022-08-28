import 'package:flutter/material.dart';
import 'package:marketplace/ui/screens/new_screens/cart_screen/widgets/cache_image.dart';
import 'package:marketplace/ui/screens/new_screens/product_detail/widget/rounded_container.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;

class NotificationList extends StatelessWidget {
  const NotificationList(
      {Key key,
      @required this.statusName,
      @required this.statusMessage,
      @required this.dates,
      @required this.image,
      this.indexStore})
      : super(key: key);

  final String statusName;
  final String statusMessage;
  final String dates;
  final String image;
  final int indexStore;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return RoundedContainer(
      padding: EdgeInsets.all(14),
      child: ListTileTheme(
        tileColor: Colors.white,
        child: ExpansionTile(
          leading: CacheImage(
            image: image,
            width: 50,
            height: 50,
          ),
          title: Text(
            statusName,
            style: AppTypo.caption.copyWith(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                statusMessage,
                maxLines: 3,
                textAlign: TextAlign.left,
                style: AppTypo.caption.copyWith(color: Colors.black38),
              ),
              SizedBox(height: 3),
              Text(
                dates,
                maxLines: 1,
                textAlign: TextAlign.left,
                style: AppTypo.caption.copyWith(color: Colors.black54),
              ),
            ],
          ),
          children: [
            ListTile(
              contentPadding: EdgeInsets.all(10),
              title: Text(
                'Pesanan Tiba di Tujuan',
                style: AppTypo.caption.copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pesanan INV/20210412/1827182 telah tiba di tujuan. Segera periksa kelengkapan produk kamu.',
                    maxLines: 3,
                    textAlign: TextAlign.left,
                    style: AppTypo.caption.copyWith(color: Colors.black38),
                  ),
                  SizedBox(height: 3),
                  Text(
                    '18 Maret 2022 15:32',
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    style: AppTypo.caption.copyWith(color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
