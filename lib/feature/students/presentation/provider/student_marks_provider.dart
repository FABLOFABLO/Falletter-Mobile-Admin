import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlockMark {
  final DateTime start;
  final DateTime end;
  final int days;
  final String reason;

  const BlockMark({
    required this.start,
    required this.end,
    required this.days,
    required this.reason,
  });
}

class StudentsMarksState {
  final Map<int, List<DateTime>> warningDates;
  final Map<int, BlockMark> blockMarks;

  const StudentsMarksState({
    this.warningDates = const {},
    this.blockMarks = const {},
  });

  StudentsMarksState copyWith({
    Map<int, List<DateTime>>? warningDates,
    Map<int, BlockMark>? blockMarks,
  }) {
    return StudentsMarksState(
      warningDates: warningDates ?? this.warningDates,
      blockMarks: blockMarks ?? this.blockMarks,
    );
  }
}

final studentsMarksProvider =
StateNotifierProvider<StudentsMarksNotifier, StudentsMarksState>(
      (ref) => StudentsMarksNotifier(),
);

class StudentsMarksNotifier extends StateNotifier<StudentsMarksState> {
  StudentsMarksNotifier() : super(const StudentsMarksState());

  void addWarning(int userId, DateTime when) {
    final next = Map<int, List<DateTime>>.from(state.warningDates);
    final list = List<DateTime>.from(next[userId] ?? const []);
    list.insert(0, when);
    next[userId] = list;
    state = state.copyWith(warningDates: next);
  }

  void setBlock({
    required int userId,
    required DateTime start,
    required int days,
    required String reason,
  }) {
    final next = Map<int, BlockMark>.from(state.blockMarks);
    next[userId] = BlockMark(
      start: start,
      end: start.add(Duration(days: days)),
      days: days,
      reason: reason,
    );
    state = state.copyWith(blockMarks: next);
  }
}