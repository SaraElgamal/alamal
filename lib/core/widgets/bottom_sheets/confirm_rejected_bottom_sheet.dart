// import 'package:flutter/material.dart';
// import 'package:lost/src/config/language/locale_keys.g.dart';
// import 'package:lost/src/config/res/app_sizes.dart';
// import 'package:lost/src/config/res/assets.gen.dart';
// import 'package:lost/src/core/extensions/context_extension.dart';
// import 'package:lost/src/core/extensions/sized_box_helper.dart';
// import 'package:lost/src/core/navigation/navigation.dart';
// import 'package:lost/src/core/widgets/bottom_sheets/bottom_sheet_widget.dart';
// import 'package:lost/src/core/widgets/buttons/default_button.dart';
// import 'package:lost/src/core/widgets/buttons/loading_button.dart';
// import 'package:lost/src/core/widgets/custom_text.dart';

// class ConfirmRejectedBottomSheet extends StatelessWidget {
//   const ConfirmRejectedBottomSheet({
//     super.key,
//     this.icon,
//     required this.title,
//     required this.subtitle,
//     this.primaryButtonTitle,
//     required this.onPrimaryButtonTap,
//     this.secondaryButtonTitle,
//     this.onSecondaryButtonTap,
//   });

//   final Widget? icon;
//   final String title;
//   final String subtitle;
//   final String? primaryButtonTitle;
//   final Future<void> Function() onPrimaryButtonTap;
//   final String? secondaryButtonTitle;
//   final VoidCallback? onSecondaryButtonTap;

//   @override
//   Widget build(BuildContext context) {
//     return BottomSheetWidget(
//       child: Column(
//         children: [
//           icon ?? AppAssets.svg.close.svg(),
//           CustomText.headlineMedium(
//             title,
//             textAlign: TextAlign.center,
//             textStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                   color: context.colors.black80,
//                 ),
//           ),
//           AppSize.sH16.szH,
//           CustomText.titleMedium(
//             subtitle,
//             textAlign: TextAlign.center,
//             textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
//                   color: context.colors.black60,
//                   fontWeight: FontWeight.w500,
//                 ),
//           ),
//           AppSize.sH25.szH,
//           Row(
//             children: [
//               Expanded(
//                 child: LoadingButton(
//                   onTap: onPrimaryButtonTap,
//                   margin: EdgeInsets.zero,
//                   title: primaryButtonTitle ?? LocaleKeys.refuse,
//                 ),
//               ),
//               AppSize.sW14.szW,
//               Expanded(
//                 child: DefaultButton(
//                   onTap: onSecondaryButtonTap ?? () => AppRouter.router.pop(),
//                   margin: EdgeInsets.zero,
//                   title: secondaryButtonTitle ?? LocaleKeys.backText,
//                   color: context.colors.primary.withValues(alpha: 0.05),
//                   textColor: context.colors.primary,
//                 ),
//               ),
//             ],
//           ),
//           AppSize.sH15.szH,
//         ],
//       ),
//     );
//   }
// }
