extension ListUtils<T> on List<T> {
  List<T> movedToFront(T item) {
    final itemIndex = indexOf(item);
    if (itemIndex != -1 && itemIndex != 0) {
      final result = [...this];
      return result
        ..insert(
          0,
          result.removeAt(itemIndex),
        );
    }
    return this;
  }


  T? getOrNull(int index) {
    if (index >= 0 && index < length) {
      return this[index];
    }
    return null;
  }

  T nextOr(int index, T Function() or) {
    final nextIndex = index + 1;
    if (nextIndex >= 0 && nextIndex < length) {
      return this[nextIndex];
    }
    return or();
  }

}
