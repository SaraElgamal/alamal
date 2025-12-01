// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:lost/src/config/language/locale_keys.g.dart';
// import 'package:lost/src/config/res/assets.gen.dart';
// import 'package:lost/src/core/widgets/empty_and_exception_widgets/custom_empty_widget.dart';

// class ExceptionErrorWidget extends StatelessWidget {
//   const ExceptionErrorWidget({
//     super.key,
//     this.error,
//     this.onPressed,
//     this.hasButton,
//     this.height,
//     this.maxLines,
//   });

//   final String? error;
//   final VoidCallback? onPressed;
//   final bool? hasButton;
//   final double? height;
//   final int? maxLines;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(top: height ?? 100.0.h),
//       child: CustomEmptyWidget(
//         title: LocaleKeys.excpetionErrorDesc,
//         subTitle: error ?? LocaleKeys.serverError,
//         icon: AppAssets.svg.exception.svg(
//           height: 250.h,
//           width: 250.w,
//         ),
//         buttonText: LocaleKeys.retry,
//         maxLines: maxLines,
//         hasButton: hasButton ?? false,
//         onPressed: onPressed,
//       ),
//     );
//   }
// }
