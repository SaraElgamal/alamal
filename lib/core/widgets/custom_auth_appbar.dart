// import 'package:flutter/material.dart';
// import 'package:lost/src/config/res/app_sizes.dart';
// import 'package:lost/src/config/res/color_manager.dart';
// import 'package:lost/src/core/extensions/sized_box_helper.dart';
// import 'package:lost/src/core/widgets/buttons/back_button.dart';

// class CustomAuthAppbar extends StatelessWidget {
//   const CustomAuthAppbar({
//     super.key,  
//     this.withBack = false,
//   });

//   final bool withBack;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: AppSize.sH150,
//       decoration: const BoxDecoration(
//         color: AppColors.primary,
//       ),
//       clipBehavior: Clip.antiAlias,
//       child: Column(
//         children: [
//           AppSize.sH60.szH,
//           Row(
//             children: [
//               if (withBack) const BackButtonWidget(),
//               (withBack) ? AppSize.sW39.szW : AppSize.sW100.szW,
//               // Center(
//               //   child: AppAssets.images.authLogo.image(
//               //     width: AppSize.sW240,
//               //     height: AppSize.sH60,
//               //   ),
//               // ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
