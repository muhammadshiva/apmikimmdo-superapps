import 'dart:math';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:marketplace/utils/colors.dart' as AppColor;
import 'package:marketplace/utils/typography.dart' as AppTypo;

class ExpandableCardWeb extends StatefulWidget {
  const ExpandableCardWeb({ Key key, this.title, this.child }) : super(key: key);

  final String title;
  final Widget child;

  @override
  _ExpandableCardWebState createState() => _ExpandableCardWebState();
}

class _ExpandableCardWebState extends State<ExpandableCardWeb>  {

  ExpandableController _expandableController = ExpandableController();
  bool active = false;

  // Animation _arrowAnimation;
  // AnimationController _arrowAnimationController;
  
  // @override
  //   void initState() {
  //     _arrowAnimationController = AnimationController(
  //     vsync: this,
  //     duration: Duration(milliseconds: 200),
  //   );
  //   _arrowAnimation = Tween(begin: 0.0, end: pi / 2).animate(
  //     new CurvedAnimation(
  //       parent: _arrowAnimationController,
  //       curve: Curves.ease,
  //     ),
  //   );
  //     super.initState();
  //   }

  @override
  Widget build(BuildContext context) {
    return 
    Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Material(
          type: MaterialType.transparency,
          child: ExpandableNotifier(
            child: Column(
            children: <Widget>[
              ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToExpand: true,
                  tapBodyToCollapse: true,
                  hasIcon: false,
                ),
                header: Container(
                  color: Color(0xFFFAFAFA),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.title,style: AppTypo.body1.copyWith(fontWeight:FontWeight.w700,fontSize: 14),
                          ),
                        ),
                        ExpandableIcon(
                          theme: const ExpandableThemeData(
                            expandIcon: FlutterIcons.ios_arrow_up_ion,
                            collapseIcon: FlutterIcons.ios_arrow_down_ion,
                            iconColor: AppColor.textPrimary,
                            iconSize: 15.0,
                            iconRotationAngle: pi / 2,
                            iconPadding: EdgeInsets.only(right: 5),
                            hasIcon: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                collapsed: Container(),
                expanded: widget.child,
              ),
            ],
          )
        ),
      ),  
  ),
   decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          width: 1,
          color: Colors.grey[400],
      ),
      )    
    );
  }
}