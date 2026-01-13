import 'package:flutter_riverpod/flutter_riverpod.dart';

class DefaultModalState {
  final int selectedDays;
  final String reason;
  final bool isReasonFocused;

  const DefaultModalState({
    required this.selectedDays,
    required this.reason,
    required this.isReasonFocused,
  });

  bool get confirmEnabled => reason.trim().isNotEmpty;
  bool get showMessage => isReasonFocused || reason.trim().isNotEmpty;

  DefaultModalState copyWith({
    int? selectedDays,
    String? reason,
    bool? isReasonFocused,
  }) {
    return DefaultModalState(
      selectedDays: selectedDays ?? this.selectedDays,
      reason: reason ?? this.reason,
      isReasonFocused: isReasonFocused ?? this.isReasonFocused,
    );
  }
}

class DefaultModalController extends StateNotifier<DefaultModalState> {
  DefaultModalController({required int initialDay})
      : super(
    DefaultModalState(
      selectedDays: initialDay,
      reason: '',
      isReasonFocused: false,
    ),
  );

  void setDays(int days) {
    state = state.copyWith(selectedDays: days);
  }

  void setReason(String reason) {
    state = state.copyWith(reason: reason);
  }

  void setReasonFocused(bool focused) {
    state = state.copyWith(isReasonFocused: focused);
  }
}

final defaultModalProvider = StateNotifierProvider.autoDispose
    .family<DefaultModalController, DefaultModalState, List<int>>(
      (ref, duration) {
    final initialDays = duration.contains(3)
        ? 3
        : (duration.isNotEmpty ? duration.first : 3);

    return DefaultModalController(initialDay: initialDays);
  },
);