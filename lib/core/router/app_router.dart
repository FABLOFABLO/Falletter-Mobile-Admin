import 'package:falletter_mobile_admin/core/components/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:falletter_mobile_admin/core/provider/bottom_nav_provider.dart';
import 'package:falletter_mobile_admin/core/router/router_path.dart';
import 'package:falletter_mobile_admin/presentation/community/view/community_view.dart';
import 'package:falletter_mobile_admin/presentation/letter/view/letter_view.dart';
import 'package:falletter_mobile_admin/presentation/notice/view/notice_view.dart';
import 'package:falletter_mobile_admin/presentation/students/view/students_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouterPath.letter,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return Scaffold(
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
              ),
            ],
          ),
        ],
      ),
    ],
  );
});