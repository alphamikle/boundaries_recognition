final Map<String, int> _benchKeys = {};

void start(String id) => _benchKeys[id] = DateTime.now().microsecondsSinceEpoch;

void stop(
  String id, {
  bool clear = false,
}) {
  final int? start = _benchKeys[id];
  if (start == null) {
    return;
  }

  final int now = DateTime.now().microsecondsSinceEpoch;

  print('$id: ${(now - start) / 1000}ms');

  if (clear) {
    _benchKeys.remove(id);
  }
}
