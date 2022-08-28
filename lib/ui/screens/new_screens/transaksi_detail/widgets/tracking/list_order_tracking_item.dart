import 'package:flutter/material.dart';
import 'package:marketplace/data/models/new_models/tracking.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/transitions.dart' as AppTrans;
import 'package:marketplace/utils/typography.dart' as AppTypo;

class ListOrderTrackingItem extends StatelessWidget {
  const ListOrderTrackingItem({ Key key, this.isStatused = false, this.trackingOrderLogs}) : super(key: key);

  final bool isStatused;
  final TrackingOrderLogs trackingOrderLogs;

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: _screenWidth * (5/100)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: isStatused ? AppColor.primary : AppColor.silverFlashSale,
                          borderRadius: BorderRadius.circular(5)
                        ),
                      ),
                      SizedBox(width: 10,),
                      Text(trackingOrderLogs.date ?? '-',style: AppTypo.body2Lato.copyWith(color: AppColor.primary))
                    ],
                  ),
                ),
                Text(trackingOrderLogs.time ?? '-',style: AppTypo.body2Lato,)
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: _screenWidth * (6/100)),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(width: 1.5, color: isStatused ? AppColor.primary : AppColor.silverFlashSale),
                )
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5,),
                    Text(trackingOrderLogs.status ?? '-',style: AppTypo.body2Lato.copyWith(color: AppColor.grey)),
                    Text(trackingOrderLogs.note ?? '-',style: AppTypo.body2Lato.copyWith(color: AppColor.grey)),
                    SizedBox(height: 5,),
                  ],
                ),
            ),
          )
        ],
      ),
    );
  }
}