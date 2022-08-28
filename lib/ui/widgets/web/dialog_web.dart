import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:beamer/beamer.dart';
import 'package:marketplace/utils/extensions.dart' as AppExt;
import 'package:marketplace/utils/typography.dart' as AppTypo;

class DialogWeb extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final double elevation;
  final EdgeInsets marginValue;
  final bool hasTitle;
  final bool hasMargin;
  final bool hasHeader;
  final String title;
  final Function onPressedClose;
  const DialogWeb(
      {Key key,
      @required this.child,
      this.height = 500,
      this.width,
      this.elevation,
      this.title = "Example Title",
      this.hasTitle = false,
      @required this.onPressedClose,
      this.hasMargin = false,
      this.marginValue,
      this.hasHeader = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: hasMargin == true ? marginValue : EdgeInsets.zero,
      child: Dialog(
        elevation: elevation ?? 24,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ), //
        child: Container(
          constraints: BoxConstraints(
            maxWidth: width ?? 500,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: AnimatedContainer(
              curve: Curves.easeInOut,
              // padding: const EdgeInsets.all(12.0),
              duration: Duration(milliseconds: 200),
              height: height,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                // alignment: WrapAlignment.center,
                // runAlignment: WrapAlignment.center,
                // crossAxisAlignment: WrapCrossAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(15).copyWith(bottom: 0),
                      child: hasHeader == true
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                hasTitle == true
                                    ? Padding(
                                        padding: EdgeInsets.only(left: 5),
                                        child: Text(title,
                                            style: AppTypo.subtitle1.copyWith(
                                                fontWeight: FontWeight.w700)))
                                    : Spacer(),
                                IconButton(
                                    iconSize: 40,
                                    padding: EdgeInsets.zero,
                                    splashRadius: 20,
                                    // hoverColor: Colors.transparent,
                                    icon: Icon(
                                      Boxicons.bx_x,
                                    ),
                                    onPressed: onPressedClose
                                    // (){
                                    //   if (closeToHome == true) {
                                    //     AppExt.popScreen(context);
                                    //     context.beamToNamed('/');
                                    //   }else{
                                    //     AppExt.popScreen(context);
                                    //   }
                                    // }
                                    ),
                              ],
                            )
                          : SizedBox()),
                  Expanded(child: child)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
