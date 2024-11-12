import 'dart:math' as math;

typedef IndexedMapper<K, V> = V Function(int index, K value);

extension ExtendedCollection<T> on List<T> {
  List<V> mapIndexed<V>(IndexedMapper<T, V> mapper) {
    final List<V> results = [];

    for (int i = 0; i < length; i++) {
      results.add(mapper(i, this[i]));
    }

    return results;
  }
}

extension ExtendedIterable<T> on Iterable<T> {
  T random() {
    if (isEmpty) {
      throw Exception('Iterable<T> should not be empty');
    }

    final int length = this.length;
    final int randomIndex = math.Random().nextInt(length);

    if (this is List<T>) {
      return _randomOfList(randomIndex);
    }

    int i = 0;
    for (final T item in this) {
      if (randomIndex == i) {
        return item;
      }
      i++;
    }
    throw Exception('Not found an item with index $randomIndex');
  }

  T? randomOrNull() {
    try {
      return random();
    } catch (_) {}
    return null;
  }

  T _randomOfList(int randomIndex) {
    return (this as List<T>)[randomIndex];
  }
}
