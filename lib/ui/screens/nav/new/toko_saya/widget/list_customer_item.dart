import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:url_launcher/url_launcher.dart';

class ListCustomerItem extends StatelessWidget {
  const ListCustomerItem({ Key key, this.customer }) : super(key: key);

  final TokoSayaCustomer customer;

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;
    return Container( 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(customer.name, overflow: TextOverflow.ellipsis,style:
                        AppTypo.body1v2.copyWith(fontWeight: FontWeight.w700),),
              SizedBox(height: 4,),
                Text("${customer.phone}",style: AppTypo.caption,),
                SizedBox(height: 6,),
                Text("Kel. ${customer.address}",style: AppTypo.caption,maxLines: 2,overflow: TextOverflow.ellipsis,),
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async => await launch(
                        customer.whatsappLink),
              child: Icon(FlutterIcons.whatsapp_faw,color: AppColor.bgTextGreen,)),
          )
        ],
      ),
    );
  }
}