// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';

// class StatusBuilder<T> extends StatelessWidget {
//   final BaseStatus status;
//   final T placeHolder;
//   final Function(T placeHolder, bool isLoading) builder;
//   final bool? isSliver;
//   final bool isEmpty;
//   final bool ignoreContainers;
//   final bool circularLoading;

//   const StatusBuilder(
//       {super.key,
//       required this.status,
//       required this.placeHolder,
//       this.ignoreContainers = false,
//       this.isEmpty = false,
//       required this.builder})
//       : isSliver = false,
//         circularLoading = false;

//   const StatusBuilder.circularLoading(
//       {super.key,
//       required this.status,
//       required this.placeHolder,
//       this.ignoreContainers = false,
//       this.isEmpty = false,
//       required this.builder})
//       : isSliver = true,
//         circularLoading = true;

//   const StatusBuilder.sliver(
//       {super.key,
//       required this.status,
//       required this.placeHolder,
//       this.ignoreContainers = false,
//       this.isEmpty = false,
//       required this.builder})
//       : isSliver = true,
//         circularLoading = false;

//   Widget _buildShimmerLoading() {
//     return isSliver!
//         ? Shimmer.fromColors(
//             baseColor: Colors.grey[300]!,
//             highlightColor: Colors.grey[100]!,
//             child: builder(placeHolder, status.isLoading))
//         : Shimmer.fromColors(
//             baseColor: Colors.grey[300]!,
//             highlightColor: Colors.grey[100]!,
//             child: builder(placeHolder, status.isLoading));
//   }

//   Widget _buildCircularLoading() {
//     return isSliver!
//         ? const SliverFillRemaining(
//             child: Center(
//               child: CupertinoActivityIndicator(),
//             ),
//           )
//         : const Center(
//             child: CupertinoActivityIndicator(),
//           );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return status.when(
//       onLoading: () => circularLoading ? _buildCircularLoading() : _buildShimmerLoading(),
//       onSuccess: () => isEmpty
//           ? !isSliver!
//               ? Center(
//                   child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     AppAssets.lottie.noData.lottie(),
//                     AppText(
//                       LocaleKeys.noDataFound,
//                       color: context.colors.hintText,
//                     ),
//                   ],
//                 ))
//               : SliverFillRemaining(
//                   child: Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         AppAssets.lottie.noData.lottie(),
//                         AppText(
//                           LocaleKeys.noDataFound,
//                           color: context.colors.hintText,
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//           : builder(placeHolder, status.isLoading),
//       onError: () => isSliver!
//           ? const SliverFillRemaining(child: ExceptionView())
//           : const Expanded(child: ExceptionView()),
//     );
//   }
// }
