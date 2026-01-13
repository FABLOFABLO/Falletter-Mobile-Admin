enum HeaderType { fromTo, title }

class LetterModalUiModel {
  final HeaderType headerType;

  final String? from;
  final String? to;
  final String? title;
  final String content;
  final String dateText;

  const LetterModalUiModel._({
    required this.headerType,
    this.from,
    this.to,
    this.title,
    required this.content,
    required this.dateText,
  });

  factory LetterModalUiModel.fromTo({
    required String from,
    required String to,
    required String content,
    required String dateText,
  }) {
    return LetterModalUiModel._(
      headerType: HeaderType.fromTo,
      from: from,
      to: to,
      content: content,
      dateText: dateText,
    );
  }

  factory LetterModalUiModel.title({
    required String title,
    required String content,
    required String dateText,
  }) {
    return LetterModalUiModel._(
      headerType: HeaderType.title,
      title: title,
      content: content,
      dateText: dateText,
    );
  }

  String get headerText {
    switch (headerType) {
      case HeaderType.fromTo:
        return '${from ?? ''} → ${to ?? ''}';
      case HeaderType.title:
        return title ?? '';
    }
  }
}