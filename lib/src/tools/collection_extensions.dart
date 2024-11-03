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
