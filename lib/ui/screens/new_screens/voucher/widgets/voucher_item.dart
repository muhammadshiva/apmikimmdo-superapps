import 'package:flutter/material.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;

class VoucherItem extends StatelessWidget {
  const VoucherItem({
    Key key,
    @required this.name,
    this.isChosen = false,
    this.isExpired = false,
  }) : super(key: key);

  final String name;
  final bool isChosen;
  final bool isExpired;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Image.asset(
                      "images/img_logo_placeholder.jpg",
                      width: 100,
                      height: 100,
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    flex: 8,
                    child: Text(
                      name,
                      style: AppTypo.subtitle2.copyWith(
                          fontWeight: FontWeight.bold,
                          color: !isExpired ? Colors.black : Colors.grey),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    flex: 1,
                    child: !isExpired
                        ? Container(
                            width: 25,
                            height: 25,
                            decoration: isChosen
                                ? null
                                : BoxDecoration(
                                    border: Border.all(color: Color(0xFFBEBEBE)),
                                    shape: BoxShape.circle),
                            child: isChosen
                                ? Icon(
                                    Icons.check_circle,
                                    color: Theme.of(context).primaryColor,
                                    size: 30,
                                  )
                                : SizedBox(),
                          )
                        : SizedBox(),
                  )
                ],
              ),
              Divider(
                thickness: 1.5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Berakhir dalam 8 jam lagi",
                    style: AppTypo.caption.copyWith(color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text("S&K",
                        style: AppTypo.caption.copyWith(
                            color: !isExpired ? Colors.red : Colors.grey)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
