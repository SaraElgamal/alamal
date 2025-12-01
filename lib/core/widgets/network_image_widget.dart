// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:lost/src/core/network/api_endpoints.dart';

// class NetworkImageWidget extends StatelessWidget {
//   final String image;
//   final double? height, width;
//   final double? loadingSize;
//   final double? radius;
//   final BorderRadiusGeometry? radiusOnly  ;
//   final BoxFit? boxFit;

//   const NetworkImageWidget({
//     super.key,
//     required this.image,
//     this.height,
//     this.width,
//     this.loadingSize,
//     this.radius,
//     this.radiusOnly,
//     this.boxFit,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: radiusOnly ?? BorderRadius.circular(radius ?? 0),
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           CachedNetworkImage(
//             imageUrl: image,
//             height: height,
//             width: width,
//             fit: boxFit ?? BoxFit.fill,
//             placeholder: (context, url) => SizedBox(
//               height: height,
//               width: width,
//               child: Image.network(
//                 ApiConstants.emptyImage,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             errorWidget: (context, url, error) => SizedBox(
//               height: height,
//               width: width,
//               child: const Center(
//                 child: Icon(Icons.error_outline, size: 28.0, color: Colors.red),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
