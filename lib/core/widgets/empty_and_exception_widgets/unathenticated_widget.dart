// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:lost/src/config/language/locale_keys.g.dart';
// import 'package:lost/src/core/extensions/context_extension.dart';
// import 'package:lost/src/core/navigation/navigation.dart';
// import 'package:lost/src/core/widgets/card_widget.dart';
// import 'package:lost/src/core/widgets/custom_app_header.dart';
// import 'package:lost/src/core/widgets/empty_and_exception_widgets/custom_empty_widget.dart';

// import '../../helpers/cache_service.dart';

// class UnAuthenticatedWidget extends StatelessWidget {
//   const UnAuthenticatedWidget({super.key, required this.title});
//   final String title;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           CustomAppHeader(title: title),
//           Padding(
//             padding: EdgeInsets.only(top: 160.0.h),
//             child: CustomEmptyWidget(
//               title: LocaleKeys.youAreNotLoggedIn,
//               subTitle: LocaleKeys.thisPageIsAvailableForRegisteredUsersOnly,
//               icon: CardWidget(
//                 backgroundColor: context.colors.black5,
//                 radius: 50.r,
//                 child: Icon(
//                   Icons.login,
//                   size: 30.sp,
//                   color: context.colors.primary,
//                 ),
//                 height: 60.h,
//                 width: 60.w,
//               ),
//               buttonText: LocaleKeys.login,
//               hasButton: true,
//               onPressed: () {
//                 AppRouter.router.go(AppRoutes.login);
//                 _clearCacheAfterLogout();
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _clearCacheAfterLogout() async {
//     AppRouter.router.go(AppRoutes.login);
//     await SecureStorage.deleteAll();
//     await CacheStorage.deleteAll();
//   }
// }
