import 'package:falletter_mobile_admin/core/components/app_bar/custom_app_bar.dart';
import 'package:falletter_mobile_admin/core/components/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:falletter_mobile_admin/core/provider/bottom_nav_provider.dart';
import 'package:falletter_mobile_admin/core/router/router_path.dart';
import 'package:falletter_mobile_admin/feature/auth/presentation/view/admin_register_view.dart';
import 'package:falletter_mobile_admin/feature/community/presentation/view/community_detail_view.dart';
import 'package:falletter_mobile_admin/feature/community/presentation/view/community_view.dart';
import 'package:falletter_mobile_admin/feature/inquiry/presentation/view/inquiry_view.dart';
import 'package:falletter_mobile_admin/feature/letter/presentation/view/letter_view.dart';
import 'package:falletter_mobile_admin/feature/notice/presentation/view/notice_detail_view.dart';
import 'package:falletter_mobile_admin/feature/notice/presentation/view/notice_view.dart';
import 'package:falletter_mobile_admin/feature/notice/presentation/view/notice_write_view.dart';
import 'package:falletter_mobile_admin/feature/signin/presentation/view/signin_view.dart';
import 'package:falletter_mobile_admin/feature/splash/presentation/view/splash_view.dart';
import 'package:falletter_mobile_admin/feature/students/presentation/view/students_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouterPath.splash,
    routes: [
      GoRoute(
        path: RouterPath.splash,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: RouterPath.inquiry,
        builder: (context, state) => const FalletterInquiryView(),
      ),
      GoRoute(
        path: RouterPath.signin,
        builder: (context, state) => const FalletterSigninView(),
      ),
      GoRoute(
        path: RouterPath.register,
        builder: (context, state) => const AdminRegisterView(),
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return Scaffold(
            backgroundColor: FalletterColor.background,
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(70),
              child: CustomAppBar(showBack: false, showLogout: true),
            ),
            body: navigationShell,
            bottomNavigationBar: CustomBottomNavigationBar(
              currentIndex: navigationShell.currentIndex,
              onTap: (index) {
                if (index == navigationShell.currentIndex) {
                  navigationShell.goBranch(index, initialLocation: true);
                } else {
                  ref.read(bottomNavIndexProvider.notifier).state = index;
                  navigationShell.goBranch(index);
                }
              },
            ),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouterPath.letter,
                builder: (_, __) => const FalletterLetterView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouterPath.community,
                builder: (_, __) => const FalletterCommunityView(),
                routes: [
                  GoRoute(
                    path: 'detail',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final postId = state.extra as String;
                      return CommunityDetailView(
                        postId: postId,
                      );
                    },
                  ),
                ]
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouterPath.students,
                builder: (_, __) => const FalletterStudentsView(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouterPath.notice,
                builder: (_, __) => const FalletterNoticeView(),
                routes: [
                  GoRoute(
                    path: 'write',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const NoticeWriteView(),
                  ),
                  GoRoute(
                    path: 'detail',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final noticeId = state.extra as int;
                      return NoticeDetailView(noticeId: noticeId);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
