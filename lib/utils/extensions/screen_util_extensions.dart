// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// /// Extension methods for responsive dimensions and spacing
// extension SizeExtension on num {
//   double get w => ScreenUtil().setWidth(this);
//   double get h => ScreenUtil().setHeight(this);
//   double get sp => ScreenUtil().setSp(this);
//   double get r => ScreenUtil().radius(this);
//
//   SizedBox get horizontalSpace => SizedBox(width: w);
//   SizedBox get verticalSpace => SizedBox(height: h);
// }
//
// /// Extension methods for responsive EdgeInsets
// extension EdgeInsetsExtension on num {
//   EdgeInsets get paddingAll => EdgeInsets.all(r);
//   EdgeInsets get paddingSymmetric =>
//       EdgeInsets.symmetric(horizontal: w, vertical: h);
//   EdgeInsets get paddingLeft => EdgeInsets.only(left: w);
//   EdgeInsets get paddingRight => EdgeInsets.only(right: w);
//   EdgeInsets get paddingTop => EdgeInsets.only(top: h);
//   EdgeInsets get paddingBottom => EdgeInsets.only(bottom: h);
// }
//
// /// Extension for responsive EdgeInsets with multiple parameters
// extension EdgeInsetsDirectionalExtension on EdgeInsets {
//   static EdgeInsets fromLTRB(
//       double left, double top, double right, double bottom) {
//     return EdgeInsets.fromLTRB(left.w, top.h, right.w, bottom.h);
//   }
// }
//
// /// Extension methods for responsive BorderRadius
// extension BorderRadiusExtension on num {
//   BorderRadius get borderRadius => BorderRadius.circular(r);
// }
//
// /// Extension on TextStyle to make font sizes responsive
// extension TextStyleExtensions on TextStyle {
//   TextStyle get responsive => copyWith(fontSize: fontSize?.sp);
// }
//
// /// Extension on Icon to make size responsive
// extension IconExtensions on Icon {
//   Icon get responsive => Icon(
//     this.icon,
//     size: this.size?.w,
//     color: this.color,
//     semanticLabel: this.semanticLabel,
//     textDirection: this.textDirection,
//   );
// }
//
// /// Extension on SizedBox to make dimensions responsive
// extension SizedBoxExtension on SizedBox {
//   static SizedBox responsive({double? width, double? height, Widget? child}) {
//     return SizedBox(
//       width: width?.w,
//       height: height?.h,
//       child: child,
//     );
//   }
// }
//
// /// Extension on BorderSide to make width responsive
// extension BorderExtension on BorderSide {
//   BorderSide get responsive => copyWith(width: width.w);
// }
//
// /// Extension on BoxConstraints for responsive constraints
// extension BoxConstraintsExtension on BoxConstraints {
//   static BoxConstraints responsive({
//     double? minWidth,
//     double? maxWidth,
//     double? minHeight,
//     double? maxHeight,
//   }) {
//     return BoxConstraints(
//       minWidth: minWidth?.w ?? 0.0,
//       maxWidth: maxWidth?.w ?? double.infinity,
//       minHeight: minHeight?.h ?? 0.0,
//       maxHeight: maxHeight?.h ?? double.infinity,
//     );
//   }
// }
//
// /// Extension on CircleAvatar to make radius responsive
// extension CircleAvatarExtension on CircleAvatar {
//   CircleAvatar get responsive => CircleAvatar(
//     radius: this.radius?.w,
//     backgroundColor: this.backgroundColor,
//     backgroundImage: this.backgroundImage,
//     child: this.child,
//   );
// }
//
// /// Extension on Positioned to make positions responsive
// extension PositionedExtension on Positioned {
//   static Positioned responsive({
//     double? left,
//     double? top,
//     double? right,
//     double? bottom,
//     double? width,
//     double? height,
//     required Widget child,
//   }) {
//     return Positioned(
//       left: left?.w,
//       top: top?.h,
//       right: right?.w,
//       bottom: bottom?.h,
//       width: width?.w,
//       height: height?.h,
//       child: child,
//     );
//   }
// }
//
// /// Extension on RoundedRectangleBorder to make border radius responsive
// extension RoundedRectangleBorderExtension on RoundedRectangleBorder {
//   RoundedRectangleBorder get responsive => copyWith(
//     borderRadius: (borderRadius as BorderRadius)
//         .topLeft
//         .x !=
//         0
//         ? BorderRadius.circular((borderRadius as BorderRadius).topLeft.x * ScreenUtil().scaleWidth)
//         : borderRadius,
//   );
// }
//
// /// MediaQuery Extensions for easy access
// extension MediaQueryExtension on BuildContext {
//   double get screenWidth => MediaQuery.of(this).size.width;
//   double get screenHeight => MediaQuery.of(this).size.height;
//   Orientation get orientation => MediaQuery.of(this).orientation;
// }
//
// /// Responsive Spacer Widget
// student_class ResponsiveSpacer extends StatelessWidget {
//   const ResponsiveSpacer({super.key, this.flex = 1});
//
//   final double flex;
//
//   @override
//   Widget build(BuildContext context) {
//     return Spacer(flex: (flex * ScreenUtil().scaleWidth).toInt());
//   }
// }
