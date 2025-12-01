// import 'package:flutter/material.dart';
// import 'package:lost/src/config/language/locale_keys.g.dart';
// import 'package:lost/src/config/res/app_sizes.dart';
// import 'package:lost/src/config/res/assets.gen.dart';
// import 'package:lost/src/core/extensions/context_extension.dart';
// import 'package:lost/src/core/extensions/sized_box_helper.dart';
// import 'package:lost/src/core/navigation/navigation.dart';
// import 'package:lost/src/core/widgets/bottom_sheets/bottom_sheet_widget.dart';
// import 'package:lost/src/core/widgets/buttons/default_button.dart';
// import 'package:lost/src/core/widgets/custom_text.dart';

// enum SheetStatus { success, error }

// class StatusSheet extends StatelessWidget {
//   final SheetStatus status;
//   final String title;
//   final String? subTitle;
//   final String? buttonText;
//   final VoidCallback? onTap;

//   const StatusSheet({
//     super.key,
//     required this.status,
//     required this.title,
//     this.subTitle,
//     this.buttonText,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final SvgGenImage icon =
//         (status == SheetStatus.success) ? AppAssets.svg.success : AppAssets.svg.close;

//     return BottomSheetWidget(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           icon.svg(),
//           AppSize.sH32.szH,
//           CustomText.headlineMedium(
//             title,
//             textAlign: TextAlign.center,
//             textStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                   color: context.colors.black80,
//                 ),
//           ),
//           if (subTitle != null && subTitle!.isNotEmpty)
//             Padding(
//               padding: EdgeInsets.only(top: AppPadding.pH16),
//               child: CustomText.titleMedium(
//                 subTitle!,
//                 textAlign: TextAlign.center,
//                 textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
//                       color: context.colors.black60,
//                     ),
//               ),
//             ),
//           AppSize.sH36.szH,
//           DefaultButton(
//             onTap: onTap ?? () => AppRouter.pop(context),
//             title: buttonText ?? LocaleKeys.yes,
//             margin: EdgeInsets.zero,
//           ),
//           AppSize.sH25.szH,
//         ],
//       ),
//     );
//   }
// }
