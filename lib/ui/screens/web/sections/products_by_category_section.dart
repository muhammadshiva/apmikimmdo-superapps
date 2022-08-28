import 'package:flutter/material.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/ui/screens/web/sections/web_sections.dart';
import 'package:marketplace/ui/widgets/a_app_config.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/colors.dart' as AppColor;

class ProductsByCategorySection extends StatefulWidget {
  final int categoryId;
  final int subCategoryIdFromBreadCumb;
  // final Recipent selectedAddress;

  const ProductsByCategorySection({
    Key key,
    this.categoryId,
    this.subCategoryIdFromBreadCumb,
  }) : super(key: key);
  @override
  _ProductsByCategorySectionState createState() =>
      _ProductsByCategorySectionState();
}

class _ProductsByCategorySectionState extends State<ProductsByCategorySection> {
  //Subcategori ID = 0->semua,1->segar,2->olahan
  int subCategoryId = 0;

  @override
  void initState() {
    if (widget.subCategoryIdFromBreadCumb == null) {
      subCategoryId = 0;
    } else {
      subCategoryId = widget.subCategoryIdFromBreadCumb;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final config = AAppConfig.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisSize: MainAxisSize.min,
      children: [
        //TAB INDICATOR
        SizedBox(
          height: 25,
        ),
        // config.appType == AppType.panenpanen
        //     ? Padding(
        //         padding: EdgeInsets.symmetric(horizontal: 82),
        //         child: Container(
        //           decoration: BoxDecoration(
        //               color: AppColor.textPrimaryInverted,
        //               border: Border(bottom: BorderSide(color: AppColor.grey))),
        //           width: double.infinity,
        //           child: Row(
        //             children: [
        //               InkWell(
        //                 onTap: () {
        //                   setState(() {
        //                     subCategoryId = 0;
        //                   });
        //                 },
        //                 child: Container(
        //                     decoration: BoxDecoration(
        //                         color: AppColor.textPrimaryInverted,
        //                         border: Border(
        //                             bottom: BorderSide(
        //                                 color: subCategoryId == 0
        //                                     ? AppColor.primary
        //                                     : Colors.transparent))),
        //                     padding: EdgeInsets.symmetric(
        //                         horizontal: 20, vertical: 5),
        //                     // color: Colors.blue,
        //                     child: Text("Semua",
        //                         style: AppTypo.subtitle1.copyWith(
        //                             color: subCategoryId == 0
        //                                 ? AppColor.primary
        //                                 : AppColor.grey,
        //                             fontWeight: FontWeight.bold))),
        //               ),
        //               InkWell(
        //                 onTap: () {
        //                   setState(() {
        //                     subCategoryId = 1;
        //                   });
        //                 },
        //                 child: Container(
        //                     decoration: BoxDecoration(
        //                         color: AppColor.textPrimaryInverted,
        //                         border: Border(
        //                             bottom: BorderSide(
        //                                 color: subCategoryId == 1
        //                                     ? AppColor.primary
        //                                     : Colors.transparent))),
        //                     padding: EdgeInsets.symmetric(
        //                         horizontal: 20, vertical: 5),
        //                     // color: Colors.yellow,
        //                     child: Text("Segar",
        //                         style: AppTypo.subtitle1.copyWith(
        //                             color: subCategoryId == 1
        //                                 ? AppColor.primary
        //                                 : AppColor.grey,
        //                             fontWeight: FontWeight.bold))),
        //               ),
        //               InkWell(
        //                 onTap: () {
        //                   setState(() {
        //                     subCategoryId = 2;
        //                   });
        //                 },
        //                 child: Container(
        //                     decoration: BoxDecoration(
        //                         color: AppColor.textPrimaryInverted,
        //                         border: Border(
        //                             bottom: BorderSide(
        //                                 color: subCategoryId == 2
        //                                     ? AppColor.primary
        //                                     : Colors.transparent))),
        //                     padding: EdgeInsets.symmetric(
        //                         horizontal: 20, vertical: 5),
        //                     // color: Colors.green,
        //                     child: Text("Olahan",
        //                         style: AppTypo.subtitle1.copyWith(
        //                             color: subCategoryId == 2
        //                                 ? AppColor.primary
        //                                 : AppColor.grey,
        //                             fontWeight: FontWeight.bold))),
        //               ),
        //             ],
        //           ),
        //         ),
        //       )
        //     : SizedBox(),
        // Container(
        //     // padding: EdgeInsets.symmetric(horizontal: 82),
        //     child: TabSubCategoriesSemuaSection(
        //   categoryId: widget.categoryId,
        // ))
      ],
    );
  }
}
