enum DialogType { ban, logout, delete }

class DefaultModalUiModel {
  final DialogType dialogType;

  final String cancelText;
  final String confirmText;

  final String logoutTitle;
  final String logoutMessage;

  final List<int> duration;
  final String banHintMessage;

  const DefaultModalUiModel._({
    required this.dialogType,
    required this.cancelText,
    required this.confirmText,
    required this.logoutTitle,
    required this.logoutMessage,
    required this.duration,
    required this.banHintMessage,
  });

  factory DefaultModalUiModel.ban({
    List<int> duration = const [3, 7, 30, 70],
    String banHintMessage = '정지 사유 입력',
    String cancelText = '취소',
    String confirmText = '확인',
  }) {
    return DefaultModalUiModel._(
      dialogType: DialogType.ban,
      cancelText: cancelText,
      confirmText: confirmText,
      logoutTitle: '로그아웃',
      logoutMessage: '로그아웃 하시겠습니까?',
      duration: duration,
      banHintMessage: banHintMessage,
    );
  }

  factory DefaultModalUiModel.logout({
    String title = '로그아웃',
    String message = '로그아웃 하시겠습니까?',
    String cancelText = '취소',
    String confirmText = '확인',
  }) {
    return DefaultModalUiModel._(
      dialogType: DialogType.logout,
      cancelText: cancelText,
      confirmText: confirmText,
      logoutTitle: title,
      logoutMessage: message,
      duration: const [3, 7, 30, 70],
      banHintMessage: '정지 사유 입력',
    );
  }

  factory DefaultModalUiModel.delete({
    String title = '삭제하시겠습니까?',
    String message = '공지를 삭제하시겠습니까?',
    String cancelText = '취소',
    String confirmText = '삭제',
  }) {
    return DefaultModalUiModel._(
      dialogType: DialogType.delete,
      cancelText: cancelText,
      confirmText: confirmText,
      logoutTitle: title,
      logoutMessage: message,
      duration: const [3, 7, 30, 70],
      banHintMessage: '정지 사유 입력',
    );
  }
}