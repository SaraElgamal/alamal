import 'package:charity_app/core/config/res/app_sizes.dart';
import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:charity_app/core/helpers/url_launcher_helper.dart';
import 'package:charity_app/core/navigation/routes/app_routes.dart';
import 'package:charity_app/core/widgets/card_widget.dart';
import 'package:charity_app/core/widgets/custom_app_header.dart';
import 'package:charity_app/core/widgets/custom_messages.dart';
import 'package:charity_app/features/admin/presentation/cubit/admin_dashboard_cubit.dart';
import 'package:charity_app/features/admin/presentation/cubit/admin_dashboard_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../injection_container.dart' as di;

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<AdminDashboardCubit>()..loadStats(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            key:
                GlobalKey<
                  ScaffoldState
                >(), // Use generic key/context finding or pass key if needed, but Builder handles context
            backgroundColor: context.colors.scaffoldBackground,
            drawer: _buildDrawer(context),
            body: BlocListener<AdminDashboardCubit, AdminDashboardState>(
              listener: (context, state) {
                if (state.errorMessage != null) {
                  MessageUtils.showError(state.errorMessage!, context: context);
                }
              },
              child: Column(
                children: [
                  CustomAppHeader(
                    title: 'لوحة التحكم',
                    showBackButton: false,
                    leading: Builder(
                      builder: (context) {
                        return IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<AdminDashboardCubit>().loadStats();
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.all(AppSize.sW16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildWelcomeSection(context),
                            SizedBox(height: 20.h),
                            Text(
                              'الإحصائيات العامة',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: context.colors.text,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            _buildStatsGrid(context),
                            SizedBox(height: 24.h),
                            Text(
                              'الوصول السريع',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: context.colors.text,
                              ),
                            ),
                            // SizedBox(height: 12.h),
                            _buildNavigationGrid(context),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return CardWidget(
      backgroundColor: context.colors.primary.withOpacity(0.1),
      padding: EdgeInsets.all(16.w),
      radius: 12.r,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: context.colors.primary,
            radius: 24.r,
            child: Icon(
              Icons.admin_panel_settings,
              color: Colors.white,
              size: 28.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مرحباً بك، أدمن',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: context.colors.text,
                  ),
                ),
                Text(
                  user?.email ?? '',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: context.colors.textSubtle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    return BlocBuilder<AdminDashboardCubit, AdminDashboardState>(
      builder: (context, state) {
        final currencyFormatter = NumberFormat.currency(
          symbol: 'ج.م',
          decimalDigits: 0,
          locale: 'ar',
        );

        return LayoutBuilder(
          builder: (context, constraints) {
            return Wrap(
              spacing: 12.w,
              runSpacing: 12.h,
              children: [
                _buildStatCardFull(
                  context,
                  title: 'إجمالي الحالات',
                  value: state.isLoading ? '...' : '${state.totalCases}',
                  icon: Icons.people_alt,
                  color: Colors.blue,
                  width: (constraints.maxWidth - 12.w) / 2,
                ),
                _buildStatCardFull(
                  context,
                  title: 'عدد المتبرعين',
                  value: state.isLoading
                      ? '...'
                      : '${state.distinctDonorsCount}',
                  icon: Icons.volunteer_activism,
                  color: Colors.purple,
                  width: (constraints.maxWidth - 12.w) / 2,
                ),
                _buildStatCardFull(
                  context,
                  title: 'إجمالي التبرعات',
                  value: state.isLoading
                      ? '...'
                      : currencyFormatter.format(state.totalDonationsAmount),
                  icon: Icons.account_balance_wallet,
                  color: Colors.green,
                  width: constraints.maxWidth, // Full width
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildStatCardFull(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required double width,
  }) {
    return Container(
      width: width,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.colors.card,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.1), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: color, size: 28.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: context.colors.text,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: context.colors.textSubtle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16.w,
      mainAxisSpacing: 16.h,
      childAspectRatio: 1.3,
      children: [
        _buildNavCard(
          context,
          title: 'إدارة الحالات',
          icon: Icons.diversity_1,
          color: Colors.blue,
          onTap: () => context.push(AppRoutes.casesList),
        ),
        _buildNavCard(
          context,
          title: 'سجل المتبرعين',
          icon: Icons.handshake,
          color: Colors.green,
          onTap: () => context.push(AppRoutes.donationsList),
        ),
      ],
    );
  }

  Widget _buildNavCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return CardWidget(
      onClick: onTap,
      isShadow: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(icon, size: 32.sp, color: color),
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: context.colors.text,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final displayName =
        (user?.displayName != null && user!.displayName!.isNotEmpty)
        ? user.displayName!
        : 'مسؤول النظام';

    return Drawer(
      backgroundColor: context.colors.scaffoldBackground,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(16.w, 50.h, 16.w, 20.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.colors.primary,
                  context.colors.primary.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30.r),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30.r,
                  backgroundColor: Colors.white,
                  child: Text(
                    displayName.characters.first.toUpperCase(),
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: context.colors.primary,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        displayName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        user?.email ?? '',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          _buildDrawerItem(
            context,
            icon: Icons.person_outline,
            title: 'الملف الشخصي',
            onTap: () {
              context.pop();
              context.push(AppRoutes.profile);
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.people_outline,
            title: 'إدارة الحالات',
            onTap: () {
              context.pop();
              context.push(AppRoutes.casesList);
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.volunteer_activism_outlined,
            title: 'سجل المتبرعين',
            onTap: () {
              context.pop();
              context.push(AppRoutes.donationsList);
            },
          ),
          Divider(color: context.colors.textSubtle.withOpacity(0.1)),
           InkWell(
                    onTap: () => UrlLauncherHelper.openUrl(
                      url:
                          'https://www.facebook.com/alamalaweshelhagar/about?locale=ar_AR', 
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(24.r),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.facebook,
                            color: const Color(0xFF1877F2),
                            size: 24.sp,
                          ),
                          SizedBox(width: 8.w),
                          Flexible(
                            child: Text(
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              'زيارة صفحة الجمعية على فيسبوك',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1877F2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          const Spacer(),
          Divider(color: context.colors.textSubtle.withOpacity(0.1)),
          _buildDrawerItem(
            context,
            icon: Icons.logout,
            title: 'تسجيل الخروج',
            color: Colors.red,
            onTap: () {
              FirebaseAuth.instance.signOut();
              context.pop();
              context.go(AppRoutes.landing);
            },
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    final itemColor = color ?? context.colors.text;
    return ListTile(
      leading: Icon(icon, color: itemColor),
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Text(
          title,
          style: TextStyle(
            color: itemColor,
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 24.w),
      horizontalTitleGap: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
    );
  }
}
