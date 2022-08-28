import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:marketplace/data/models/models.dart';
import 'package:marketplace/ui/screens/nav/new/account/address_entry_screen.dart';
import 'package:marketplace/utils/typography.dart' as AppTypo;
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/transitions.dart' as AppTrans;
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/constants.dart' as AppConst;
import 'package:shimmer/shimmer.dart';

final gs = GetStorage();

class UpdateAccountListRecipentItem extends StatefulWidget {
  const UpdateAccountListRecipentItem(
      {Key key,
      this.recipent,
      this.onDelete,
      this.onSelected,
      this.triggerRefresh,
      this.recipentMainAddress})
      : super(key: key);

  final List<Recipent> recipent;
  final Recipent recipentMainAddress; //=>>>> SELECTED RECIPENT
  final Function(bool isSelected, int recipentId) onSelected;
  final Function(int recipentId) onDelete;
  final Function() triggerRefresh;

  @override
  State<UpdateAccountListRecipentItem> createState() =>
      _UpdateAccountListRecipentItemState();
}

class _UpdateAccountListRecipentItemState
    extends State<UpdateAccountListRecipentItem> {
  // final dataRecipentSelected = gs.read('recipentSelected');

  int recipentId = 0;
  int isMainAddress = 0;

  @override
  void initState() {
    recipentId =
        widget.recipentMainAddress != null ? widget.recipentMainAddress.id : 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;

    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.recipent.length,
      separatorBuilder: (context, index) => SizedBox(
        height: 15,
      ),
      itemBuilder: (context, index) {
        Recipent recipentData = widget.recipent[index];
        // Map<String, dynamic> recipentMap = {
        //   "id": recipent.id,
        //   "subdistrict_id": recipent.subdistrictId,
        //   "name": recipent.name,
        //   "phone": recipent.phone,
        //   "address": recipent.address,
        //   "postal_code": recipent.postalCode,
        //   "subdistrict": recipent.subdistrict,
        //   "is_main_address": recipent.isMainAddress,
        //   "email": recipent.email,
        //   "note": recipent.note,
        // };
        return InkWell(
          onTap: () {
            if (recipentId != recipentData.id) {
              setState(() {
                recipentId = recipentData.id;
              });
              widget.onSelected(true, recipentId);
            }
          },
          child: Container(
            padding: EdgeInsets.all(_screenWidth * (4.5 / 100)),
            decoration: BoxDecoration(
              color: recipentId == 0
                  ? widget.recipentMainAddress != null &&
                          widget.recipentMainAddress.isMainAddress == 1 &&
                          recipentData.isMainAddress == 1
                      ? AppColor.bgBadgePink
                      : AppColor.white
                  : recipentId == recipentData.id
                      ? AppColor.bgBadgePink
                      : AppColor.white,
              border: recipentId == 0
                  ? widget.recipentMainAddress != null &&
                          widget.recipentMainAddress.isMainAddress == 1 &&
                          recipentData.isMainAddress == 1
                      ? Border.all(color: AppColor.primary, width: 1.5)
                      : Border.all(color: AppColor.line, width: 1)
                  : recipentId == recipentData.id
                      ? Border.all(color: AppColor.primary, width: 1.5)
                      : Border.all(color: AppColor.line, width: 1),
              borderRadius: BorderRadius.circular(7.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "${recipentData.name}",
                  style: AppTypo.overline.copyWith(fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                    "${recipentData.address}, ${recipentData.subdistrict}, ${recipentData.city}, ${recipentData.province}",
                    style: AppTypo.overline),
                SizedBox(
                  height: 10,
                ),
                Text("+${recipentData.phone}", style: AppTypo.overline),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          bool refresh = await AppExt.pushScreen(
                              context,
                              AddressEntryScreen(
                                recipent: recipentData,
                              ));
                          if (refresh != null && refresh) {
                            widget.triggerRefresh();
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5)),
                          child: Text("Ubah Alamat",
                              style: AppTypo.caption
                                  .copyWith(color: Colors.black)),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5)),
                      child: InkWell(
                        onTap: () {
                          widget.onDelete(recipentData.id);
                        },
                        child: Icon(
                          EvaIcons.trash2Outline,
                          color: AppColor.grey,
                          size: 22,
                        ),
                      ),
                    ),
                    /*IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: AppColor.danger,
                          size: 30,
                        ),
                        onPressed: () {
                          widget.onDelete(recipent.id);
                        }),*/
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class UpdateAccountListRecipentItemLoading extends StatelessWidget {
  const UpdateAccountListRecipentItemLoading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;
    Widget _unShim = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 15,
                width: 90,
                color: Colors.grey[200],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 10,
                width: 150,
                color: Colors.grey[200],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 10,
                width: 130,
                color: Colors.grey[200],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 10,
                width: 140,
                color: Colors.grey[200],
              ),
            ],
          ),
          Icon(
            Icons.delete,
            color: AppColor.grey,
            size: 35,
          ),
        ],
      ),
    );

    return Container(
      padding: EdgeInsets.all(_screenWidth * (4.5 / 100)),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.line, width: 1),
        borderRadius: BorderRadius.circular(7.5),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[200],
        period: Duration(milliseconds: 1000),
        child: _unShim,
      ),
    );
  }
}
