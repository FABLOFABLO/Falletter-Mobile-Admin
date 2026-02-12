String normalizeDsmEmail(String input) {
  final t = input.trim();
  if (t.isEmpty) return t;
  if (t.contains('@')) return t;
  return '$t@dsm.hs.kr';
}