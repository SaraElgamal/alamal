import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

/// Global shimmer loading widget for consistent loading UI across the app
class ShimmerLoadingWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? margin;

  const ShimmerLoadingWidget({
    super.key,
    this.height,
    this.width,
    this.borderRadius,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xff1F2937) : Colors.grey[300]!,
      highlightColor: isDark ? const Color(0xff374151) : Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        margin: margin,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xff1F2937) : Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}

/// Shimmer loading for list items (ads, categories, etc.)
class ShimmerListLoading extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final EdgeInsetsGeometry? padding;

  const ShimmerListLoading({
    super.key,
    this.itemCount = 6,
    this.itemHeight = 320,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        return ShimmerLoadingWidget(
          height: itemHeight.h,
          margin: const EdgeInsets.symmetric(vertical: 4.0),
        );
      },
    );
  }
}

/// Shimmer loading for grid items
class ShimmerGridLoading extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;
  final double childAspectRatio;
  final EdgeInsetsGeometry? padding;

  const ShimmerGridLoading({
    super.key,
    this.itemCount = 6,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.0,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding ?? EdgeInsets.all(16.w),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return const ShimmerLoadingWidget();
      },
    );
  }
}

/// Shimmer loading for horizontal list items (categories, etc.)
class ShimmerHorizontalList extends StatelessWidget {
  final int itemCount;
  final double height;
  final double itemWidth;
  final EdgeInsetsGeometry? padding;

  const ShimmerHorizontalList({
    super.key,
    this.itemCount = 5,
    this.height = 40,
    this.itemWidth = 100,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (_, __) => ShimmerLoadingWidget(
          height: height,
          width: itemWidth,
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
    );
  }
}
