import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;

import 'rounded_container.dart';

class ProductDetailRecommendedItem extends StatelessWidget {
  const ProductDetailRecommendedItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset("images/img_recipe1.png", height: 120, width: 160, fit: BoxFit.cover,),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Baju Batik Anak"),
                  SizedBox(
                    height: 5,
                  ),
                  Text("Rp 120.000", style: TextStyle(color: Theme.of(context).primaryColor),),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      RoundedContainer(
                        padding: EdgeInsets.all(1),
                        fillColor: Color(0x40EB4F4D),
                        child: Text(
                          "50 %",
                          style: AppTypo.caption.copyWith(
                              color: Color(0xFFEB4F4D), fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Rp. 300.000",
                        style: AppTypo.caption,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on_rounded, color: Colors.red,),
                      Text("Surabaya")
                    ],
                  ),
                  Text("Terjual 203"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
