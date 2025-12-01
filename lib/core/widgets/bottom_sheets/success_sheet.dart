// import 'package:flutter/material.dart';
// import 'package:lost/src/core/extensions/context_extension.dart';
// import 'package:lost/src/core/widgets/bottom_sheets/alert_bottom_sheet_widget.dart';
// import 'package:lost/src/core/widgets/custom_text.dart';
// import 'package:lost/src/config/res/assets.gen.dart';

// class SuccessSheet extends StatelessWidget {
//   const SuccessSheet({
//     super.key,
//     required this.title,
//   });

//   final String title;

//   @override
//   Widget build(BuildContext context) {
//     return AlertBottomSheetWidget(
//       icon: AppAssets.svg.success,
//       enableBack: false,
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           CustomText.headlineMedium(
//             title,
//             textStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                   color: context.colors.black80,
//                 ),
//           ),
//         ],
//       ),
//     );
//   }
// }
