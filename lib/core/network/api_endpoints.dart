import 'package:falletter_mobile_admin/core/config/app_env.dart';

class ApiEndpoints {
  /// BaseUrl
  static const baseUrl = AppEnv.baseUrl;

  /// Auth
  static const signUp = "/admin/auth/signup";
  static const signIn = "/admin/auth/signin";
  static const emailVerify = "/auth/email/verify";
  static const emailMatch = "/auth/email/match";

  /// Letter
  static const letterUnpassed = "/admin/letter/unpassed";

  static String letterUnpassedDetail(String letterId) =>
      "/admin/letter/unpassed/$letterId";

  /// Notice
  static const notice = "/admin/notice";

  static String noticeDetailDelete(String noticeId) =>
      "/admin/notice/$noticeId";

  /// Community
  static String communityDelete(String communityId) =>
      "/admin/community/$communityId";

  /// User
  static const userAll = "/admin/user/all";

  static String userProfile(String userId) => "/admin/user/$userId";

  /// Suspend
  static String userWarn(String userId) => "/admin/warning/$userId";

  static String userBan(String userId) => "/admin/block/$userId";
}
