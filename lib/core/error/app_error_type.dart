enum AppErrorType {
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  server,
  network,
  unknown,
}

extension AppErrorTypeMessage on AppErrorType {
  String get message {
    switch (this) {
      case AppErrorType.badRequest:
        return '요청이 올바르지 않아요.';
      case AppErrorType.unauthorized:
        return '로그인이 만료됐어요. 다시 로그인해주세요.';
      case AppErrorType.forbidden:
        return '권한이 없어요.';
      case AppErrorType.notFound:
        return '요청한 정보를 찾을 수 없어요.';
      case AppErrorType.server:
        return '서버에 문제가 생겼어요. 잠시 후 다시 시도해주세요.';
      case AppErrorType.network:
        return '서버에 연결할 수 없어요. 네트워크를 확인해주세요.';
      case AppErrorType.unknown:
        return '알 수 없는 오류가 발생했어요.';
    }
  }
}
