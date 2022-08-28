// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:marketplace/utils/typography.dart' as AppTypo;
// import 'package:marketplace/utils/colors.dart' as AppColor;

// class GeneralOutlineButton extends StatelessWidget {
//   final String title;
//   final double width;
//   final Function onPressed;
//   final Widget icon;
//   const GeneralOutlineButton(
//       {Key key,
//       @required this.title,
//       @required this.width,
//       this.onPressed,
//       this.icon})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: width,
//       child: OutlinedButton(
//         style: OutlinedButton.styleFrom(
//           padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(7.r),
//           ),
//           side: BorderSide(color: AppColor.primary, width: 1),
//         ),
//         onPressed: onPressed,
//         child: Center(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               icon != null ? icon: SizedBox.shrink(),
//               icon != null ? SizedBox(width: 10) : SizedBox.shrink(),
//               Flexible(
//                 child: Text(
//                     "$title",
//                     style: AppTypo.body1.copyWith(
//                         fontWeight: FontWeight.w700,
//                         fontSize: 14,
//                         color: AppColor.primary),
//                   ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
