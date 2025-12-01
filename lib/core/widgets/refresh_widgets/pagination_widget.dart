import 'package:flutter/material.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class PaginationWidget extends StatelessWidget {
  const PaginationWidget({
    super.key,
    required this.refreshKey,
    required this.refreshController,
    required this.child,
    this.onRefresh,
    this.onLoading,
    this.enableOnLoad,
    this.enableOnRefresh,
  });

  final GlobalKey refreshKey;
  final RefreshController refreshController;
  final Widget child;
  final VoidCallback? onRefresh, onLoading;
  final bool? enableOnLoad, enableOnRefresh;

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      key: refreshKey,
      controller: refreshController,
      enablePullUp: enableOnLoad ?? true,
      enablePullDown: enableOnRefresh ?? true,
      physics: const BouncingScrollPhysics(),
      onRefresh: onRefresh,
      onLoading: onLoading,
      child: child,
    );
  }
}

///About initialization for screen util and pull to refresh packages
// _() {
//   ScreenUtilInit(
//     designSize: const Size(360, 690),
//     minTextAdapt: true,
//     splitScreenMode: true,
//     builder: (_, child) =>
//         RefreshConfiguration(
//           headerBuilder: () => const MaterialClassicHeader(),
//           footerBuilder: () => const ClassicFooter(),
//           headerTriggerDistance: 10,
//           maxOverScrollExtent: 80,
//           maxUnderScrollExtent: 0,
//           enableScrollWhenRefreshCompleted: true,
//           enableLoadingWhenFailed: true,
//           hideFooterWhenNotFull: false,
//           enableBallisticLoad: true,
//           child: MaterialApp(),),
//     child: const FirstPage(),
//   )
// }
